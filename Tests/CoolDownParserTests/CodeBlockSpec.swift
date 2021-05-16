//
//  CodeBlockSpec.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 16.05.21.
//  Copyright © techprimate GmbH & Co. KG 2021. All Rights Reserved!
//

import Quick
import Nimble
@testable import CoolDownParser

class CodeBlockSpec: QuickSpec {

    override func spec() {
        describe("CDParser") {
            describe("code block") {
                context("only 4 whitespaces") {
                    it("should return empty code block") {
                        let text = "    "
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .codeBlock(nodes: [])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }

                context("single code line") {
                    it("should return empty code block") {
                        let text = "    1 + 2 == 3"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .codeBlock(nodes: [
                                .code("1 + 2 == 3")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }

                context("multiple code lines") {
                    it("should return single block with multiple line nodes") {
                        let text = "    public func foo() -> String {\n"
                                 + "        return \"Hello World\"\n"
                                 + "    }"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .codeBlock(nodes: [
                                .code("public func foo() -> String {"),
                                .code("    return \"Hello World\""),
                                .code("}")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }

                context("empty lines inside code") {
                    it("should return single block with multiple line nodes") {
                        let text = "    let x = 1\n"
                                 + "    \n"
                                 + "    let y = 2"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .codeBlock(nodes: [
                                .code("let x = 1"),
                                .code(""),
                                .code("let y = 2")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }
        }
    }
}
