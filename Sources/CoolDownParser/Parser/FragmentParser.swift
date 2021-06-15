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
                    fragmentStack.push(parseCodeBlock(from: fragment))
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
                }
                // Numbered lists begin with a number
                if character.isNumber, let numberItem = parseNumberedItem(character: character) {
                    fragmentStack.push(numberItem)
                    continue
                }
                // Headers begin with a hash tag
                if character == "#", let header = parseHeader() { // could be a header
                    fragmentStack.push(header)
                    continue
                }
                // Quote blocks begin with a greater-than sign
                if character == ">", let quote = parseQuote() {
                    fragmentStack.push(quote)
                    continue
                }
            }

            // Fragment text content begins here
            if character == "*", let parsedFragments = parseCursiveOrBold() {
                fragmentStack += parsedFragments
            } else if character == "`", let parsedFragment = parseInlineCodeBlock() {
                fragmentStack.push(parsedFragment)
            } else if character == "!" && lexer.peakNext() == "[", let parsedFragments = parseImage() {
                fragmentStack += parsedFragments
            } else if character == "[", let parsedFragments = parseLink() {
                fragmentStack += parsedFragments
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
            } else if let codeBlockNode = node as? FragmentCodeBlock {
                // If there is a previous code block, append the code line
                if let previousBlockNode = result.last as? CodeBlockNode ?? previous.last as? CodeBlockNode {
                    let code = codeBlockNode.code ?? ""
                    // Ignore leading empty code lines
                    if !(previousBlockNode.nodes.isEmpty && code.isEmpty) {
                        previousBlockNode.nodes.append(CodeNode(content: code))
                    }
                } else {
                    if let code = codeBlockNode.code {
                        let node = CodeNode(content: code)
                        result.append(.codeBlock(nodes: [node]))
                    } else {
                        result.append(.codeBlock(nodes: []))
                    }
                }
                contentNodes = []
            } else if let linkNode = node as? FragmentLink {
                result.append(.link(uri: linkNode.uri, title: linkNode.title, nodes: contentNodes))
                contentNodes = []
            } else if let imageNode = node as? FragmentImage {
                result.append(.image(uri: imageNode.uri, title: imageNode.title, nodes: contentNodes))
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

        enum Marker {
            case bold
            case cursive
        }

        var markers: [Marker] = [.cursive]

        // If an asteriks follows another one (**), it must at least be bold.
        if nextCharacter == "*" {
            markers = [.bold]

            // Skip second asteriks
            _ = lexer.next()
            rewindCount += 1

            // Iterate remaining characters
            while let character = lexer.next() {
                rewindCount += 1
                // If another asteriks is found, it can either terminate the current bold text, or it can be a nested cursive.
                if character == "*" {
                    if markers.last == .cursive {
                        fragments.append(FragmentCursive(characters: characters))
                        characters = []
                        markers = markers.dropLast()
                    } else if isNested {
                    // If we are in a nested cursive block, this asteriks terminates the block
                        fragments.append(FragmentBoldCursive(characters: characters))
                        // Reset the scanned characters, as we have added them
                        characters = []
                        // We are exiting the nested block, reset tracking flag
                        isNested = false
                        continue
                    } else if lexer.peakNext() == "*" && markers.contains(.bold) { // Two asteriks following each other terminate the bold statement
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
        }

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
        return fragments
    }

    private func parseCodeBlock(from fragment: Substring) -> FragmentCodeBlock {
        // A code section can be arbitary block, but all lines have 4 leading spaces which are trimmed.
        let code = fragment[fragment.index(fragment.startIndex, offsetBy: 4)...]
        // If there is no code inside the code block, return an empty block
        // It should not return an empty code node
        if code.isEmpty {
            return FragmentCodeBlock(code: nil)
        }
        return FragmentCodeBlock(code: String(code))
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

    private func parseImage() -> [Fragment]? {
        _ = lexer.next()
        guard let (fragments, uri, title) = parseLinkFormatHelper() else {
            lexer.rewindCharacter()
            return nil
        }
        var frags = fragments
        frags.insert(FragmentImage(uri: uri, title: title), at: 0)
        return frags
    }

    private func parseLink() -> [Fragment]? {
        guard let (fragments, uri, title) = parseLinkFormatHelper() else {
            return nil
        }
        var frags = fragments
        frags.insert(FragmentLink(uri: uri, title: title), at: 0)
        return frags
    }

    private func parseLinkFormatHelper() -> (fragments: [Fragment], uri: String, title: String?)? {
        // Only terminated fragments are valid
        var hasTerminated = false
        var rewindCount = 1

        // We might find multiple nested bold/cursive combinations
        // e.g [**bold link**]()
        var fragments = [Fragment]()

        // Characters found in current fragment
        var characters = [Character]()

        // Parsed elements
        var link: [Character]?
        var uri: String?
        var title: String?

        // Iterate remaining characters
        while let character = lexer.next() {
            rewindCount += 1
            // If a closing bracket is found the link tag is closed
            if character == "]" {
                // the link content should be parsed now
                link = characters
                // continue with parsing the link, it needs to start with an opening parantheses
                guard lexer.next() == "(" else {
                    rewindCount += 1
                    // If the next character is not an opening parantheses, it is not a valid link
                    // Rewind to beginning of fragment
                    lexer.rewindCharacters(count: rewindCount)
                    return nil
                }
                hasTerminated = true
                break
            }
            characters.append(character)
        }

        // If the while-loop exited, but no link is set, it can not be a valid link
        guard let parsedLink = link else {
            // Rewind to beginning of fragment
            lexer.rewindCharacters(count: rewindCount)
            return nil
        }

        characters = []

        var shouldParseTitle = false
        var isEnclosedInPointyBrackets = false

        // Check if uri is enclosed in pointy brackets
        if lexer.peakNext() == "<" {
            _ = lexer.next()
            rewindCount += 1
            isEnclosedInPointyBrackets = true
        }

        // Parse content in paranetheses
        while let character = lexer.next() {
            rewindCount += 1
            // If the character is a whitespace and a double-quote character, it contains a title
            if character == " " {
                if lexer.peakNext() == "\"" {
                    // skip double quote of title tag
                    _ = lexer.next()
                    rewindCount += 1
                    // set uri
                    uri = String(characters)
                    shouldParseTitle = true
                    break
                } else if !isEnclosedInPointyBrackets {
                    // whitespaces are not allowed in the uri, if it is not enclosed in pointy brackets
                    // Rewind to beginning of fragment
                    lexer.rewindCharacters(count: rewindCount)
                    return nil
                }
            } else if isEnclosedInPointyBrackets && character == ">" && lexer.peakNext() == ")" {
                // if the closing pointy bracket is escaped, it is not valid
                // peak back two characters, as the previous one in the lexer is current character processing
                if lexer.peakPrevious(count: 2) == "\\" {
                    // Rewind to beginning of fragment
                    lexer.rewindCharacters(count: rewindCount)
                    return nil
                }
                _ = lexer.next()
                rewindCount += 1
                uri = String(characters)
                break
            } else if character == ")" {
                // a closing parantheses terminates the link
                uri = String(characters)
                break
            }
            characters.append(character)
        }

        // If the while-loop exited, but no uri is set, it did not terminate correctly
        guard let parsedUri = uri else {
            // Rewind to beginning of fragment
            lexer.rewindCharacters(count: rewindCount + 1)
            return nil
        }

        if shouldParseTitle {
            hasTerminated = false
            characters = []

            while let character = lexer.next() {
                rewindCount += 1
                if character == "\"" && lexer.peakNext() == ")" {
                    // skip closing parantheses
                    _ = lexer.next()
                    title = String(characters)
                    hasTerminated = true
                    break
                }
                characters.append(character)
            }
        }

        // If the fragment didn't terminate correctly, it shall not be detected
        guard hasTerminated else {
            // Rewind to beginning of fragment
            lexer.rewindCharacters(count: rewindCount)
            return nil
        }
        fragments.append(FragmentText(characters: parsedLink))
        return (fragments: fragments, uri: parsedUri, title: title)
    }
}
