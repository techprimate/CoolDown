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
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.cursive("foo")])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            describe("bold inline") {
                it("should be parsed") {
                    let text = "**foo**"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.bold("foo")])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            describe("bold & cursive inline") {
                it("should be parsed") {
                    let text = "***foo***"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.cursiveBold("foo")])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            context("bold in cursive") {
                it("should return both elements") {
                    let text = "***bold** in cursive*"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursiveBold("bold"),
                            .cursive(" in cursive")
                        ])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            context("cursive in bold") {
                it("should return both elements") {
                    let text = "***cursive* in bold**"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursiveBold("cursive"),
                            .bold(" in bold")
                        ])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            context("in bold cursive") {
                it("should return both elements") {
                    let text = "**in bold *cursive***"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .bold("in bold "),
                            .cursiveBold("cursive"),
                        ])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }

            context("in cursive bold") {
                it("should return both elements") {
                    let text = "**in bold *cursive***"
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursive("in cursive "),
                            .cursiveBold("bold"),
                        ])
                    ]

                    expect(CoolDown(text).nodes) == expectedNodes
                }
            }
        }
    }
}
