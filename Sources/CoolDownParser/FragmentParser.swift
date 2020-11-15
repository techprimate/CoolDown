//
//  FragmentParser.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

enum FragmentType {
    case header
    case paragraph
}

class Fragment {

}

class FragmentHeader: Fragment {
    let depth: Int
    init(depth: Int) {
        self.depth = depth
    }
}

class FragmentCursive: Fragment {
    var text: [Character]

    init(characters: [Character]) {
        self.text = characters
    }
}

class FragmentBold: Fragment {
    var text: [Character]

    init(characters: [Character]) {
        self.text = characters
    }
}

class FragmentBoldCursive: Fragment {
    var text: [Character]

    init(characters: [Character]) {
        self.text = characters
    }
}

class FragmentText: Fragment {
    var text: [Character]

    init(character: Character) {
        self.text = [character]
    }
}

class FragmentCode: Fragment {
    var text: [Character]

    init(characters: [Character]) {
        self.text = characters
    }
}

class FragmentListItem: Fragment {}

class FragmentParser {

    static func parseHeader(using lexer: FragmentLexer) -> FragmentHeader? {
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
    static func parseCursiveOrBold(using lexer: FragmentLexer) -> [Fragment]? {
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

    static func parseCodeBlock(from fragment: Substring, using lexer: FragmentLexer) -> [ASTNode] {
        // A code section can be arbitary block, but all lines have 4 leading spaces which are trimmed.
        let code = fragment[fragment.index(fragment.startIndex, offsetBy: 4)...]
        return [
            .code(String(code))
        ]
    }

    static func parseInlineCodeBlock(using lexer: FragmentLexer) -> FragmentCode? {
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

    static func parseListItem(using lexer: FragmentLexer) -> FragmentListItem? {
        guard lexer.next() == " " else {
            lexer.rewindCharacters(count: 1)
            return nil
        }
        return FragmentListItem()
    }
}
