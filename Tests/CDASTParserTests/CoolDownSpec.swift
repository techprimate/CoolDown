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
                
                it("should parse cursive nodes in element") {
                    let text = "# Title 1 - *cursive title* more title"
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [
                            .text("Title 1 - "),
                            .cursive("cursive title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse bold and cursive nodes in element") {
                    let text = "# Title 1 - **heavy title**, *cursive title* more title"
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [
                            .text("Title 1 - "),
                            .bold("heavy title"),
                            .text(", "),
                            .cursive("cursive title"),
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

                it("should parse a nested bold node") {
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

                it("should parse a nested cursive node") {
                    let text = """
                    Nullam *ornare* viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .cursive("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested code node") {
                    let text = """
                    Nullam `ornare` viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .code("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, bold and cursive nodes") {
                    let text = """
                    # Paragraph Title
                    Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Paragraph Title")]),
                        .paragraph(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra "),
                            .cursive("purus"),
                            .text(", eget accumsan "),
                            .code("leo gravida"),
                            .text(" eget.")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
            
            describe("Bullet") {
                it("should parse a single bullet item with - sign") {
                    let text = "- Nullam ornare viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [.text("Nullam ornare viverra purus")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a single bullet item with * sign") {
                    let text = "* Nullam ornare viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [.text("Nullam ornare viverra purus")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested bold node with - sign") {
                    let text = "- Nullam **ornare** purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested bold node with * sign") {
                    let text = "- Nullam **ornare** purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested cursive node with - sign") {
                    let text = "- Nullam *ornare* viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .cursive("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested cursive node with * sign") {
                    let text = "* Nullam *ornare* viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .cursive("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested code node with - sign") {
                    let text = "- Nullam `ornare` viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .code("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested code node with * sign") {
                    let text = "* Nullam `ornare` viverra purus"
                    let expectedNodes: [ASTNode] = [
                        .bullet(nodes: [
                            .text("Nullam "),
                            .code("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, bold and cursive nodes with - sign") {
                    let text = """
                    # Paragraph Title
                    - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Paragraph Title")]),
                        .bullet(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra "),
                            .cursive("purus"),
                            .text(", eget accumsan "),
                            .code("leo gravida"),
                            .text(" eget.")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse header, bold and cursive nodes with * sign") {
                    let text = """
                    # Paragraph Title
                    * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Paragraph Title")]),
                        .bullet(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra "),
                            .cursive("purus"),
                            .text(", eget accumsan "),
                            .code("leo gravida"),
                            .text(" eget.")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
            
            describe("Quote") {
                it("should parse a full text as a quote") {
                    let text = """
                    > Nullam ornare viverra purus, eget accumsan leo gravida eget. Nunc ligula mauris, molestie non aliquam a, pulvinar vel elit.
                    """
                    let expectedNodes: [ASTNode] = [
                        .quote(nodes: [.text("Nullam ornare viverra purus, eget accumsan leo gravida eget. Nunc ligula mauris, molestie non aliquam a, pulvinar vel elit.")])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested bold node") {
                    let text = """
                    > Nullam **ornare** viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .quote(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse a nested cursive node") {
                    let text = """
                    > Nullam *ornare* viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .quote(nodes: [
                            .text("Nullam "),
                            .cursive("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse a nested code node") {
                    let text = """
                    > Nullam `ornare` viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .quote(nodes: [
                            .text("Nullam "),
                            .code("ornare"),
                            .text(" viverra purus")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, bold and cursive nodes") {
                    let text = """
                    # Paragraph Title
                    > Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(nodes: [.text("Paragraph Title")]),
                        .quote(nodes: [
                            .text("Nullam "),
                            .bold("ornare"),
                            .text(" viverra "),
                            .cursive("purus"),
                            .text(", eget accumsan "),
                            .code("leo gravida"),
                            .text(" eget.")
                        ])
                    ]

                    let coolDown = CoolDown(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
        }
    }
}
