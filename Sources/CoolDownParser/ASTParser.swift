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
        // Split block by lines
        let fragments = block.split(separator: "\n")
        for fragment in fragments {
            var fragmentResult = [ASTNode]()
            let fragmentLexer = FragmentLexer(content: fragment)
            var whiteSpaceCount = 0
            var hasTrimmedWhitespaces = false
            var fragmentStack = [Fragment]()

            var isFirstCharacter = true

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
                // After trimming the whitespaces, the first relevant character is in focus.
                // At the end of the loop it can't be the first character anymore.
                // Therefore add a defer statement, to make sure
                defer {
                    isFirstCharacter = false
                }

                // some first characters are distinct
                if isFirstCharacter {
                    // List items begin with leading dash or asteriks
                    if character == "-" || character == "*", let listItem = FragmentParser.parseListItem(using: fragmentLexer) {
                        fragmentStack.append(listItem)
                        continue
                    } else if character.isNumber, let numberItem = FragmentParser.parseNumberedItem(using: fragmentLexer, character: character) {
                        fragmentStack.append(numberItem)
                        continue
                    } else if character == "#", let header = FragmentParser.parseHeader(using: fragmentLexer) { // could be a header
                        fragmentStack.append(header)
                        continue
                    } else if character == ">", let quote = FragmentParser.parseQuote(using: fragmentLexer) {
                        fragmentStack.append(quote)
                        continue
                    }
                }

                // Fragment text content begins here
                if character == "*", let parsedFragments = FragmentParser.parseCursiveOrBold(using: fragmentLexer) {
                    fragmentStack += parsedFragments
                } else if character == "`", let parsedFragment = FragmentParser.parseInlineCodeBlock(using: fragmentLexer) {
                    fragmentStack.append(parsedFragment)
                } else {
                    if let textFragment = fragmentStack.last as? FragmentText {
                        textFragment.text.append(character)
                    } else {
                        fragmentStack.append(FragmentText(character: character))
                    }
                }
            }
            flatFragmentsStack(stack: fragmentStack, result: &fragmentResult, previous: result)
            result += fragmentResult
        }
    }

    func flatFragmentsStack(stack: [Fragment], result: inout [ASTNode], previous: [ASTNode]) {
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
