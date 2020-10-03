//
//  CoolDown.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Foundation

public class CoolDown {

    public private(set) var nodes: [ASTNode]

    public init(_ text: String) {
        guard let lexer = Lexer(raw: text) else {
            nodes = []
            return
        }
        let parser = ASTParser(lexer: lexer)
        while let block = lexer.next() {
            parser.parse(block: block)
        }
        nodes = parser.result
    }

    public convenience init(url: URL) throws {
        self.init(try String(contentsOf: url, encoding: .utf8))
    }
}
