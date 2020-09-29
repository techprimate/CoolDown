//
//  BoldCursiveInlineSpec.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble
@testable import CoolDownParser

class BoldCursiveInlineSpec: QuickSpec {

    override func spec() {
        describe("ASTParser") {
            describe("cursive inline") {
                it("should be parsed") {
                    let text = "*foo*"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.cursive("foo")])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            describe("bold inline") {
                it("should be parsed") {
                    let text = "**foo**"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.bold("foo")])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            describe("bold & cursive inline") {
                it("should be parsed") {
                    let text = "***foo***"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.cursiveBold("foo")])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            context("bold in cursive") {
                it("should return both elements") {
                    let text = "***bold** in cursive*"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursiveBold("bold"),
                            .cursive(" in cursive")
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            context("cursive in bold") {
                it("should return both elements") {
                    let text = "***cursive* in bold**"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursiveBold("cursive"),
                            .bold(" in bold")
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            context("in bold cursive") {
                it("should return both elements") {
                    let text = "**in bold *cursive***"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .bold("in bold "),
                            .cursiveBold("cursive"),
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }

            context("in cursive bold") {
                it("should return both elements") {
                    let text = "**in bold *cursive***"
                    let actualNodes = CoolDown(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursive("in cursive "),
                            .cursiveBold("bold"),
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }
        }
    }
}
