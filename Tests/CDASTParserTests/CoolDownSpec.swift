//
//  CoolDownSpec.swift
//  CDASTParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble
@testable import CDASTParser

class CoolDownSpec: QuickSpec {

    override func spec() {
        describe("ASTParser") {
            describe("Header") {
                it("should parse single element starting with single hashtag") {
                    let text = "# Title 1"
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Title 1")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse multiple header elements starting with single hashtag") {
                    let text = """
                    # Title 1
                    # Title 2
                    # Title 3
                    # Title 4
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Title 1")]),
                        .header(nodes: [.text("Title 2")]),
                        .header(nodes: [.text("Title 3")]),
                        .header(nodes: [.text("Title 4")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                context("with empty lines") {
                    it("should parse multiple header elements starting with single hashtag") {
                        let text = """
                        # Title 1

                        # Title 2

                        # Title 3

                        # Title 4
                        """
                        let expectedNodes: [ASTNode] = [
                            .header(nodes: [.text("Title 1")]),
                            .header(nodes: [.text("Title 2")]),
                            .header(nodes: [.text("Title 3")]),
                            .header(nodes: [.text("Title 4")])
                        ]

                        let coolDown = CoolDown(text)
                        expect(coolDown.nodes) == expectedNodes
                    }
                }

                it("should parse bold nodes in element") {
                    let text = "# Title 1 - **heavy title** more title"
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [
                            .text("Title 1 - "),
                            .bold("heavy title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }

            describe("Paragraph") {
                it("should parse a full text as a paragraph") {
                    let text = """
                    Nullam ornare viverra purus, eget accumsan leo gravida eget. Nunc ligula mauris, molestie non aliquam a, pulvinar vel elit.
                    """
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.text("Nullam ornare viverra purus, eget accumsan leo gravida eget. Nunc ligula mauris, molestie non aliquam a, pulvinar vel elit.")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested bold nodes") {
                    let text = """
                    Nullam **ornare** viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested bold nodes") {
                    let text = """
                    Nullam **ornare** viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested bold nodes") {
                    let text = """
                    # Paragraph Title
                    Nullam **ornare** viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Paragraph Title")]),
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
        }
    }
}
