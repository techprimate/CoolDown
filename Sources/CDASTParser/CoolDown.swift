//
//  CoolDown.swift
//  CDASTParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

class CoolDown {

    private(set) var nodes: [ASTNode]

    public init(_ text: String) {
        guard let lexer = Lexer(raw: text) else {
            nodes = []
            return
        }
        let parser = ASTParser(lexer: lexer)
        while let token = lexer.next() {
            parser.parse(token: token)
        }
        nodes = parser.result
    }
}
