//
//  ASTParser.swift
//  CDASTParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Stencil

class ASTParser {

    let lexer: Lexer

    var result: [ASTNode] = []

    init(lexer: Lexer) {
        self.lexer = lexer
    }

    func parse(token: String) {
        let lineTokens = token.split(separator: "\n")
        for line in lineTokens {
            if line.hasPrefix("# ") {
                // Token is an header
                let trimmedToken = line[token.index(line.startIndex, offsetBy: 2)...]

                result.append(.header(depth: 1, nodes: parseTextToNodes(text: String(trimmedToken))))
            } else {
                result.append(.paragraph(nodes: parseTextToNodes(text: String(line))))
            }
        }
    }

    private func parseTextToNodes(text: String) -> [ASTNode] {
        if let groups = matchesBold(text: text) {
            let preText = groups[0]
            let boldText = groups[1]
            let postText = groups[2]

            return parseTextToNodes(text: preText)
                + [.bold(String(boldText))]
                + parseTextToNodes(text: postText)
        } else {
            return [
                .text(String(text))
            ]
        }
    }

    private func matchesCursive(text: String) -> [String]? {
        let regex = try! Regex(pattern: "(.*)[^\\*]\\*(.+)\\*(.*)")
        let groups = regex.match(in: String(text)).captures
        return groups.isEmpty ? nil : groups
    }

    private func matchesBold(text: String) -> [String]? {
        let regex = try! Regex(pattern: "(.*)\\*\\*(.+)\\*\\*(.*)")
        let groups = regex.match(in: String(text)).captures
        return groups.isEmpty ? nil : groups
    }
}
