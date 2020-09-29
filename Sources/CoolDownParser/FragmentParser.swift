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

class FragmentText: Fragment {
    var text: [Character]

    init(character: Character) {
        self.text = [character]
    }
}

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

    static func parseCursiveOrBold(using lexer: FragmentLexer) -> Fragment? {
        guard let nextCharacter = lexer.peakNext() else {
            return nil
        }
        if nextCharacter == "*" { // bold
            _ = lexer.next()
            var characters = [Character]()
            while let character = lexer.next() {
                if character == "*" && lexer.peakNext() == "*" {
                    break
                }
                characters.append(character)
            }
            return FragmentBold(characters: characters)
        } else {
            var characters = [Character]()
            while let character = lexer.next() {
                if character == "*" {
                    if lexer.peakNext() == "*" {
                        lexer.rewindCharacter()
                    }
                    break
                }
                characters.append(character)
            }
            return FragmentCursive(characters: characters)
        }
    }

//    static func parse(cursive fragment: Substring) throws -> FragmentCursive? {
//        var characterIterator = fragment.enumerated().makeIterator()
//        var cursiveStartOffset = -1
//        var cursiveEndOffset = 0
//        while let (offset, character) = characterIterator.next() {
//            // Find beginning of cursive inline object
//            if character == "*" && cursiveStartIndex == -1 {
//                cursiveStartOffset = offset
//                continue
//            }
//            // If there is another * directly afterwards, it can not be a cursive object
//            if character == "*" && offset == cursiveStartIndex + 1 {
//                return nil
//            }
//            if character == "*" {
//                cursiveEndOffset = offset
//                break
//            }
//        }
//        let startIndex = fragment.index(fragment.startIndex, offsetBy: cursiveStartOffset)
//        let endIndex = fragment.index(fragment.startIndex, offsetBy: cursiveEndOffset)
//        let preContent = fragment[...startIndex]
//        let content = fragment[startIndex..<endIndex]
//        let postContent = fragment[endIndex...]
//        return FragmentCursive(preContent: preContent, content: content, postContent: postContent)
//    }
//
//    private func matchesCursive(text: String) -> [String]? {
//        let regex = try! Regex(pattern: "(.*)\\*(.+)\\*(.*)")
//        let groups = regex.match(in: String(text)).captures
//        return groups.isEmpty ? nil : groups
//    }
//
//    private func matchesBold(text: String) -> [String]? {
//        let regex = try! Regex(pattern: "(.*)\\*\\*(.+)\\*\\*(.*)")
//        let groups = regex.match(in: String(text)).captures
//        return groups.isEmpty ? nil : groups
//    }

    static func parseCodeBlock(from fragment: Substring, using lexer: FragmentLexer) -> [ASTNode] {
        return []
    }
}
