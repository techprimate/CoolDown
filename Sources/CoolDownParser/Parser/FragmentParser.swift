/// Parses a text fragment into an abstract syntax tree by iterating its characters
///
/// Additionally this parser also performs stack flattening
internal class FragmentParser {

    /// Text fragment to be parsed.
    /// Used type is `Substring` as it is supposed to be faster for per-character access
    private let fragment: Substring

    /// Lexer used to iterate the characters
    private let lexer: FragmentLexer

    /// Creates a new parser for the given fragment
    ///
    /// - Parameter fragment: Text fragment to be parsed
    internal init(fragment: Substring) {
        self.fragment = fragment
        // Create a fragment lexer
        self.lexer = FragmentLexer(content: fragment)
    }

    /// Parses the fragment into the given result reference.
    ///
    /// # Complexity
    ///
    /// In average each character needs to iterated only once, therefore the performance is `O(1)`.
    ///
    /// - Parameter result: Reference of nodes array which will be mutated
    /// - Complexity: approx. O(1)
    internal func parse(into result: inout [ASTNode]) {
        // Create a stack for managing the nesting of fragments
        var fragmentStack: Stack<Fragment> = []

        // Variable to track leading whitespace indentation
        var indentation = 0
        // Flag to track if leading whitespaces have been trimmed
        var hasTrimmedWhitespaces = false
        // Flag to track if the current character is the first one.
        // This is necessary, as the first character returned by the lexer could be a leading whitespace
        // which are ignored, but we need to handle the first non-whitespace character different than others.
        var isFirstCharacter = true

        // Iterate all characters
        while let character = lexer.next() {
            // Check if maximum leading whitespaces count is less than four otherwise it is a code block
            if character == " " && !hasTrimmedWhitespaces {
                indentation += 1
                // As soon as the indentation hits level 4, it is considered a code block
                guard indentation < 4 else {
                    result += parseCodeBlock(from: fragment)
                    break
                }
                continue
            }
            // After analyzing the indentation, whitespaces are normal characters in the text
            hasTrimmedWhitespaces = true
            // After trimming the whitespaces, the first relevant character is in focus.
            // At the end of the loop it can't be the first character anymore.
            // Therefore add a defer statement, to make sure
            defer {
                isFirstCharacter = false
            }

            // some first characters are distinct
            if isFirstCharacter {
                // List items begin with leading dash or asteriks
                if character == "-" || character == "*", let listItem = parseListItem() {
                    fragmentStack.push(listItem)
                    continue
                } else if character.isNumber, let numberItem = parseNumberedItem(character: character) {
                    fragmentStack.push(numberItem)
                    continue
                } else if character == "#", let header = parseHeader() { // could be a header
                    fragmentStack.push(header)
                    continue
                } else if character == ">", let quote = parseQuote() {
                    fragmentStack.push(quote)
                    continue
                }
            }

            // Fragment text content begins here
            if character == "*", let parsedFragments = parseCursiveOrBold() {
                fragmentStack += parsedFragments
            } else if character == "`", let parsedFragment = parseInlineCodeBlock() {
                fragmentStack.push(parsedFragment)
            } else {
                if let textFragment = fragmentStack.top as? FragmentText {
                    textFragment.text.append(character)
                } else {
                    fragmentStack.push(FragmentText(character: character))
                }
            }
        }
        result += flatFragmentsStack(stack: fragmentStack, previous: result)
    }

    func flatFragmentsStack(stack: Stack<Fragment>, previous: [ASTNode]) -> [ASTNode] {
        var result: [ASTNode] = []
        var contentNodes: [ASTNode] = []
        for node in stack.reversed() {
            if let cursiveNode = node as? FragmentCursive {
                contentNodes.insert(.cursive(String(cursiveNode.text)), at: 0)
            } else if let boldNode = node as? FragmentBold {
                contentNodes.insert(.bold(String(boldNode.text)), at: 0)
            } else if let cursiveBoldNode = node as? FragmentBoldCursive {
                contentNodes.insert(.cursiveBold(String(cursiveBoldNode.text)), at: 0)
            } else if let textNode = node as? FragmentText {
                contentNodes.insert(.text(String(textNode.text)), at: 0)
            } else if let headerNode = node as? FragmentHeader {
                result.append(.header(depth: headerNode.depth, nodes: contentNodes))
                contentNodes = []
            } else if let codeNode = node as? FragmentCode {
                contentNodes.insert(.code(String(codeNode.text)), at: 0)
            } else if node is FragmentQuote {
                result.append(.quote(nodes: contentNodes))
                contentNodes = []
            } else if node is FragmentListItem {
                let node = ListNode.bullet(nodes: contentNodes)
                if let listNode = result.last as? ListNode ?? previous.last as? ListNode {
                    listNode.nodes.append(node)
                } else {
                    result.append(.list(nodes: [node]))
                }
                contentNodes = []
            } else if let numberedNode = node as? FragmentNumberedListItem {
                let node = ListNode.numbered(index: numberedNode.number, nodes: contentNodes)
                if let listNode = result.last as? ListNode ?? previous.last as? ListNode {
                    listNode.nodes.append(node)
                } else {
                    result.append(.list(nodes: [node]))
                }
                contentNodes = []
            }
        }
        if !contentNodes.isEmpty {
            if let paragraphNode = result.last as? ParagraphNode {
                paragraphNode.nodes += contentNodes
            } else {
                result.append(.paragraph(nodes: contentNodes))
            }
        }
        return result
    }

    private func parseHeader() -> FragmentHeader? {
        var hashtagCount = 1
        while let character = lexer.next() {
            // Count hashtags to determine depth
            if character == "#" {
                hashtagCount += 1
                continue
            }
            // First character after hashtags must be a whitespace
            guard character == " " else {
                lexer.rewindCharacters(count: hashtagCount)
                return nil
            }
            break
        }
        return FragmentHeader(depth: hashtagCount)
    }

    /// Tries to parse a fragment as either a cursive, bold or mix between them
    ///
    /// Precondition:This method shall be called if an asteriks (*) was found before
    private func parseCursiveOrBold() -> [Fragment]? {
        guard let nextCharacter = lexer.peakNext() else {
            // Asteriks has been the last character of this fragment and does not terminate.
            return nil
        }
        // Only terminated fragments are valid
        var hasTerminated = false
        var rewindCount = 1

        // We might find multiple nested bold/cursive combinations
        // e.g **bold *bold-cursive* bold *bold-cursive***
        var fragments = [Fragment]()

        // Characters found in current fragment
        var characters = [Character]()
        // We linearly scan all characters, so we need to track if we are another level deeper
        var isNested = false

        // If an asteriks follows another one (**), it must at least be bold.
        if nextCharacter == "*" {
            // Skip second asteriks
            _ = lexer.next()
            rewindCount += 1

            // Iterate remaining characters
            while let character = lexer.next() {
                rewindCount += 1
                // If another asteriks is found, it can either terminate the current bold text, or it can be a nested cursive.
                if character == "*" {
                    // If we are in a nested cursive block, this asteriks terminates the block
                    if isNested {
                        fragments.append(FragmentBoldCursive(characters: characters))
                        // Reset the scanned characters, as we have added them
                        characters = []
                        // We are exiting the nested block, reset tracking flag
                        isNested = false
                        continue
                    } else if lexer.peakNext() == "*" { // Two asteriks following each other terminate the bold statement
                        // Two subseeding asteriks terminates the statement
                        _ = lexer.next()
                        rewindCount += 1
                        hasTerminated = true
                        if let lastBold = fragments.last as? FragmentBold {
                            // If there is another cursive fragment in the list, append the characters
                            fragments[fragments.count - 1] = FragmentBold(characters: lastBold.text + ["*"] + characters)
                            characters = []
                        }
                        break
                    } else { // We might have found another valid cursive block

                        // If the bold block immediately begins with a cursive block, don't add the empty block
                        if !characters.isEmpty {
                            fragments.append(FragmentBold(characters: characters))
                            // Reset the scanned characters, as we have added them
                            characters = []
                        }
                        // Until we find a terminating asteriks, we are in a nested block
                        isNested = true
                        continue
                    }
                }
                characters.append(character)
            }

            // If the fragment didn't terminate correctly, it shall not be detected
            guard hasTerminated else {
                // Rewind to beginning of fragment
                lexer.rewindCharacters(count: rewindCount)
                return nil
            }
            if !characters.isEmpty {
                // If the bold block immediately begins with a cursive block, don't add the empty block
                fragments.append(FragmentBold(characters: characters))
            }
            return fragments
        } else {

            // Iterate remaining characters
            while let character = lexer.next() {
                rewindCount += 1

                // If another asteriks is found, it can either terminate the current cursive text, or it can be a nested bold.
                if character == "*" {
                    // Two adjacent asteriks are found, this can be the beginning or the end of a nested bold block
                    if lexer.peakNext() == "*" {
                        // Skip next character
                        _ = lexer.next()
                        // If we are already in a nested block, this is the end of the nested block
                        if isNested {
                            fragments.append(FragmentBoldCursive(characters: characters))
                            // Reset the scanned characters, as we have added them
                            characters = []
                            // We are exiting the nested block, reset tracking flag
                            isNested = false
                            continue
                        }
                        fragments.append(FragmentCursive(characters: characters))
                        // Reset the scanned characters, as we have added them
                        characters = []
                        // We are entering a nested block
                        isNested = true
                        continue
                    }
                    // a single asteriks terminates the block
                    // but if it is currently in a nested block, that means that the nested block does not terminate correctly, e.g. *cursive **bad block*
                    if isNested {
                        // we cancel the nested block and keep going
                        isNested = false
                        if let lastCursive = fragments.last as? FragmentCursive {
                            // If there is another cursive fragment in the list, append the characters
                            fragments[fragments.count - 1] = FragmentCursive(characters: lastCursive.text + ["*", "*"] + characters)
                            characters = []
                        }
                    }
                    // Terminating symbol found
                    hasTerminated = true
                    break
                }
                characters.append(character)
            }
            // If the fragment didn't terminate correctly, it shall not be detected
            guard hasTerminated else {
                // Rewind to beginning of fragment
                lexer.rewindCharacters(count: rewindCount)
                return nil
            }
            if !characters.isEmpty {
                // If the bold block immediately begins with a cursive block, don't add the empty block
                fragments.append(FragmentCursive(characters: characters))
            }
        }
        return fragments
    }

    private func parseCodeBlock(from fragment: Substring) -> [ASTNode] {
        // A code section can be arbitary block, but all lines have 4 leading spaces which are trimmed.
        let code = fragment[fragment.index(fragment.startIndex, offsetBy: 4)...]
        return [
            .code(String(code))
        ]
    }

    private func parseInlineCodeBlock() -> FragmentCode? {
        var characters = [Character]()
        var rewindCount = 1
        while let character = lexer.next() {
            if character == "`" {
                return FragmentCode(characters: characters)
            }
            characters.append(character)
            rewindCount += 1
        }
        lexer.rewindCharacters(count: rewindCount)
        return nil
    }

    private func parseListItem() -> FragmentListItem? {
        guard lexer.next() == " " else {
            lexer.rewindCharacters(count: 1)
            return nil
        }
        return FragmentListItem()
    }

    private func parseNumberedItem(character: Character) -> FragmentNumberedListItem? {
        // Numbered items begin with a number and a dot before a whitespaces
        var digits = [character]
        while let nextCharacter = lexer.next() {
            // Still searching for digits
            if nextCharacter.isNumber {
                digits.append(nextCharacter)
                continue
            }
            // check that after the numbers there is a dot
            guard nextCharacter == "." else {
                // otherwise rewind the cursor
                lexer.rewindCharacters(count: digits.count)
                return nil
            }
            // after the dot, there must be a whitespae
            guard lexer.next() == " " else {
                lexer.rewindCharacters(count: digits.count + 1)
                return nil
            }
            break
        }
        // If at least one digit is found, it is a valid number header
        guard !digits.isEmpty, let value = Int(String(digits)) else {
            return nil
        }
        return FragmentNumberedListItem(number: value)
    }

    private func parseQuote() -> FragmentQuote? {
        // After the quote character '>' there must be a whitespace
        guard lexer.next() == " " else {
            lexer.rewindCharacters(count: 1)
            return nil
        }
        return FragmentQuote()
    }
}