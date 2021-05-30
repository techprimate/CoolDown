@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_ListSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("List") {
                it("should parse multiple bullet item with - sign") {
                    let text = """
                    - Nullam ornare viverra purus
                    - eget accumsan leo gravida eget
                    - Nullam ornare viverra purus
                    - eget accumsan leo gravida eget
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")]),
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse multiple bullet item with * sign") {
                    let text = """
                    * Nullam ornare viverra purus
                    * eget accumsan leo gravida eget
                    * Nullam ornare viverra purus
                    * eget accumsan leo gravida eget
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")]),
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse multiple bullet item with mixeds signs") {
                    let text = """
                    * Nullam ornare viverra purus
                    - eget accumsan leo gravida eget
                    - Nullam ornare viverra purus
                    * eget accumsan leo gravida eget
                    - Nullam ornare viverra purus
                    * eget accumsan leo gravida eget
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")]),
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")]),
                            .bullet(nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [.text("eget accumsan leo gravida eget")])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, and list with bold and cursive nodes with mixed sign") {
                    let text = """
                    # Paragraph Title
                    * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [.text("Paragraph Title")]),
                        .list(nodes: [
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse multiple consecutive numbered items") {
                    let text = """
                    1. Nullam ornare viverra purus
                    2. Nullam ornare viverra purus
                    3. Nullam ornare viverra purus
                    4. Nullam ornare viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .numbered(index: 1, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 2, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 3, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 4, nodes: [.text("Nullam ornare viverra purus")])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                context("with empty lines") {
                    it("should parse multiple consecutive numbered items as individual lists") {
                        let text = """
                        1. Nullam ornare viverra purus

                        2. Nullam ornare viverra purus

                        3. Nullam ornare viverra purus

                        4. Nullam ornare viverra purus
                        """
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .numbered(index: 1, nodes: [.text("Nullam ornare viverra purus")])
                            ]),
                            .list(nodes: [
                                .numbered(index: 2, nodes: [.text("Nullam ornare viverra purus")])
                            ]),
                            .list(nodes: [
                                .numbered(index: 3, nodes: [.text("Nullam ornare viverra purus")])
                            ]),
                            .list(nodes: [
                                .numbered(index: 4, nodes: [.text("Nullam ornare viverra purus")])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }
                }

                it("should parse multiple non consecutive numbered items") {
                    let text = """
                    42. Nullam ornare viverra purus
                    891. eget accumsan leo gravida eget
                    1. Nullam ornare viverra purus
                    2. eget accumsan leo gravida eget
                    43. eget accumsan leo gravida eget
                    3. Nullam ornare viverra purus
                    44. Nullam ornare viverra purus
                    450. eget accumsan leo gravida eget
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .numbered(index: 42, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 891, nodes: [.text("eget accumsan leo gravida eget")]),
                            .numbered(index: 1, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 2, nodes: [.text("eget accumsan leo gravida eget")]),
                            .numbered(index: 43, nodes: [.text("eget accumsan leo gravida eget")]),
                            .numbered(index: 3, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 44, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 450, nodes: [.text("eget accumsan leo gravida eget")])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse multiple non consecutive numbered and mixed bulleted items") {
                    let text = """
                    42. Nullam ornare viverra purus
                    * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    43. eget accumsan leo gravida eget
                    1. Nullam ornare viverra purus
                    44. Nullam ornare viverra purus
                    * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .list(nodes: [
                            .numbered(index: 42, nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ]),
                            .numbered(index: 43, nodes: [.text("eget accumsan leo gravida eget")]),
                            .numbered(index: 3, nodes: [.text("Nullam ornare viverra purus")]),
                            .numbered(index: 44, nodes: [.text("Nullam ornare viverra purus")]),
                            .bullet(nodes: [
                                .text("Nullam "),
                                .bold("ornare"),
                                .text(" viverra "),
                                .cursive("purus"),
                                .text(", eget accumsan "),
                                .code("leo gravida"),
                                .text(" eget.")
                            ])
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                describe("Bullet") {
                    it("should parse a single bullet item with - sign as list") {
                        let text = "- Nullam ornare viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [.text("Nullam ornare viverra purus")])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a single bullet item with * sign as list") {
                        let text = "* Nullam ornare viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [.text("Nullam ornare viverra purus")])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested bold node with - sign") {
                        let text = "- Nullam **ornare** viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested bold node with * sign") {
                        let text = "- Nullam **ornare** viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested cursive node with - sign") {
                        let text = "- Nullam *ornare* viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .cursive("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested cursive node with * sign") {
                        let text = "* Nullam *ornare* viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .cursive("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested code node with - sign") {
                        let text = "- Nullam `ornare` viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .code("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested code node with * sign") {
                        let text = "* Nullam `ornare` viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .code("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse header, bold and cursive nodes with - sign") {
                        let text = """
                            # Paragraph Title
                            - Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                            """
                        let expectedNodes: [ASTNode] = [
                            .header(depth: 1, nodes: [.text("Paragraph Title")]),
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra "),
                                    .cursive("purus"),
                                    .text(", eget accumsan "),
                                    .code("leo gravida"),
                                    .text(" eget.")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse header, bold and cursive nodes with * sign") {
                        let text = """
                            # Paragraph Title
                            * Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                            """
                        let expectedNodes: [ASTNode] = [
                            .header(depth: 1, nodes: [.text("Paragraph Title")]),
                            .list(nodes: [
                                .bullet(nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra "),
                                    .cursive("purus"),
                                    .text(", eget accumsan "),
                                    .code("leo gravida"),
                                    .text(" eget.")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                }

                describe("Numbered") {
                    it("should parse a single numbered item") {
                        let text = "1. Nullam ornare viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .numbered(index: 1, nodes: [.text("Nullam ornare viverra purus")])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested bold node") {
                        let text = "23. Nullam **ornare** viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .numbered(index: 23, nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested cursive node") {
                        let text = "23. Nullam *ornare* viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .numbered(index: 23, nodes: [
                                    .text("Nullam "),
                                    .cursive("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse a nested code node") {
                        let text = "23. Nullam `ornare` viverra purus"
                        let expectedNodes: [ASTNode] = [
                            .list(nodes: [
                                .numbered(index: 23, nodes: [
                                    .text("Nullam "),
                                    .code("ornare"),
                                    .text(" viverra purus")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse header, bold and cursive nodes") {
                        let text = """
                            # Paragraph Title
                            23. Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                            """
                        let expectedNodes: [ASTNode] = [
                            .header(depth: 1, nodes: [.text("Paragraph Title")]),
                            .list(nodes: [
                                .numbered(index: 23, nodes: [
                                    .text("Nullam "),
                                    .bold("ornare"),
                                    .text(" viverra "),
                                    .cursive("purus"),
                                    .text(", eget accumsan "),
                                    .code("leo gravida"),
                                    .text(" eget.")
                                ])
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }
                }
            }
        }
    }
}
