//
//  ASTParser.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

class ASTParser {

    let lexer: Lexer

    var result: [ASTNode] = []

    init(lexer: Lexer) {
        self.lexer = lexer
    }

    func parse(block: String) {
        let fragments = block.split(separator: "\n")
        for fragment in fragments {
            var fragmentResult = [ASTNode]()
            let fragmentLexer = FragmentLexer(content: fragment)
            var whiteSpaceCount = 0
            var hasTrimmedWhitespaces = false
            var fragmentStack = [Fragment]()
            while let character = fragmentLexer.next() {
                // Check if maximum leading whitespaces count is less than four otherwise it is a code block
                if character == " " && !hasTrimmedWhitespaces {
                    whiteSpaceCount += 1
                    guard whiteSpaceCount < 4 else {
                        result += FragmentParser.parseCodeBlock(from: fragment, using: fragmentLexer)
                        break
                    }
                    continue
                }
                hasTrimmedWhitespaces = true

                // Fragment text content begins here
                if character == "#", let header = FragmentParser.parseHeader(using: fragmentLexer) { // could be a header
                    fragmentStack.append(header)
                } else if character == "*", let parsedFragment = FragmentParser.parseCursiveOrBold(using: fragmentLexer) {
                    fragmentStack.append(parsedFragment)
                } else {
                    if let textFragment = fragmentStack.last as? FragmentText {
                        textFragment.text.append(character)
                    } else {
                        fragmentStack.append(FragmentText(character: character))
                    }
                }
            }
            flatFragmentsStack(stack: fragmentStack, result: &fragmentResult)
            result += fragmentResult
        }
    }

    func flatFragmentsStack(stack: [Fragment], result: inout [ASTNode]) {
        var contentNodes: [ASTNode] = []
        for node in stack.reversed() {
            if let cursiveNode = node as? FragmentCursive {
                contentNodes.insert(.cursive(String(cursiveNode.text)), at: 0)
            } else if let boldNode = node as? FragmentBold {
                contentNodes.insert(.bold(String(boldNode.text)), at: 0)
            } else if let textNode = node as? FragmentText {
                contentNodes.insert(.text(String(textNode.text)), at: 0)
            } else if let headerNode = node as? FragmentHeader {
                result.append(.header(depth: headerNode.depth, nodes: contentNodes))
                contentNodes = []
            }
        }
        if !contentNodes.isEmpty {
            appendNodesAsParagraph(nodes: contentNodes, result: &result)
        }
    }

    func appendNodesAsParagraph(nodes: [ASTNode], result: inout [ASTNode]) {
        if let paragraphNode = result.last as? ParagraphNode {
            paragraphNode.nodes += nodes
        } else {
            result.append(.paragraph(nodes: nodes))
        }
    }

    func getFragmentType(from fragment: Substring) -> FragmentType {
        switch fragment.prefix(1) {
        case "#":
            return .header
        default:
            return .paragraph
        }
    }
}

class FragmentLexer: IteratorProtocol {

    let content: Substring
    var offset: Int = 0

    init(content: Substring) {
        self.content = content
    }

    var currentCharacter: Character? {
        guard offset < content.count else {
            return nil
        }
        return content[content.index(content.startIndex, offsetBy: offset)]
    }

    func next() -> Character? {
        let character = self.currentCharacter
        offset += 1
        return character
    }

    func peakNext() -> Character? {
        let character = next()
        rewindCharacter()
        return character
    }

    func rewindCharacter() {
        offset -= 1
    }

    func rewindCharacters(count: Int) {
        offset -= count
    }
}
