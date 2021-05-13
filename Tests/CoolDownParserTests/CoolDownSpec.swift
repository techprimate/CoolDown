//
//  CoolDownSpec.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble
@testable import CoolDownParser

class CoolDownSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("Header") {
                it("should parse single element starting with single hashtag") {
                    let text = "# Title 1"
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [.text("Title 1")])
                    ]

                    let coolDown = CDParser(text)
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
                        .header(depth: 1,nodes: [.text("Title 1")]),
                        .header(depth: 1,nodes: [.text("Title 2")]),
                        .header(depth: 1,nodes: [.text("Title 3")]),
                        .header(depth: 1,nodes: [.text("Title 4")])
                    ]

                    let coolDown = CDParser(text)
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
                            .header(depth: 1,nodes: [.text("Title 1")]),
                            .header(depth: 1,nodes: [.text("Title 2")]),
                            .header(depth: 1,nodes: [.text("Title 3")]),
                            .header(depth: 1,nodes: [.text("Title 4")])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }
                }
                
                it("should parse multiple header elements with different depths") {
                    let text = """
                    ## Title 1
                    # Title 2
                    #### Title 3
                    ## Title 4
                    # Title 5
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 2, nodes: [.text("Title 1")]),
                        .header(depth: 1, nodes: [.text("Title 2")]),
                        .header(depth: 4, nodes: [.text("Title 3")]),
                        .header(depth: 2, nodes: [.text("Title 4")]),
                        .header(depth: 1, nodes: [.text("Title 5")])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                context("with empty lines") {
                    it("should parse multiple header elements with different depths") {
                        let text = """
                        ## Title 1

                        # Title 2

                        #### Title 3

                        ## Title 4

                        # Title 5
                        """
                        let expectedNodes: [ASTNode] = [
                            .header(depth: 2, nodes: [.text("Title 1")]),
                            .header(depth: 1, nodes: [.text("Title 2")]),
                            .header(depth: 4, nodes: [.text("Title 3")]),
                            .header(depth: 2, nodes: [.text("Title 4")]),
                            .header(depth: 1, nodes: [.text("Title 5")])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }
                }

                it("should parse bold nodes in element") {
                    let text = "# Title 1 - **heavy title** more title"
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [
                            .text("Title 1 - "),
                            .bold("heavy title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse cursive nodes in element") {
                    let text = "# Title 1 - *cursive title* more title"
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [
                            .text("Title 1 - "),
                            .cursive("cursive title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse bold and cursive nodes in element") {
                    let text = "# Title 1 - **heavy title**, *cursive title* more title"
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [
                            .text("Title 1 - "),
                            .bold("heavy title"),
                            .text(", "),
                            .cursive("cursive title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }
                
                it("should parse bold and cursive nodes in element with high depth") {
                    let text = "#### Title 1 - **heavy title**, *cursive title* more title"
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 4, nodes: [
                            .text("Title 1 - "),
                            .bold("heavy title"),
                            .text(", "),
                            .cursive("cursive title"),
                            .text(" more title")
                        ])
                    ]

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                for i in 0..<4 {
                    context("\(i) leading spaces") {
                        it("should ignore leading spaces") {
                            // based on https://spec.commonmark.org/0.29/#example-38
                            let text = Array(repeating: " ", count: i).joined() + "# foo"
                            let expectedNodes: [ASTNode] = [.header(depth: 1, nodes: [.text("foo")])]
                            expect(CDParser(text).nodes) == expectedNodes
                        }
                    }
                }

                context("4 leading spaces") {
                    it("should not parse as a header") {
                        // based on https://spec.commonmark.org/0.29/#example-39
                        let text = "    # foo"
                        let expectedNodes: [ASTNode] = [.code("# foo")]
                        expect(CDParser(text).nodes) == expectedNodes
                    }
                }

                context("no space between # and content") {

                    it("should not parse headers") {
                        // based on https://spec.commonmark.org/0.29/#example-34
                        let text = """
                        #5 bolt

                        #hashtag

                        ##two hashtags

                        ###three hashtags

                        ####four hashtags
                        """
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [.text("#5 bolt")]),
                            .paragraph(nodes: [.text("#hashtag")]),
                            .paragraph(nodes: [.text("##two hashtags")]),
                            .paragraph(nodes: [.text("###three hashtags")]),
                            .paragraph(nodes: [.text("####four hashtags")])
                        ]

                        expect(CDParser(text).nodes) == expectedNodes
                    }
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

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, bold and cursive nodes") {
                    let text = """
                    # Paragraph Title
                    Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [.text("Paragraph Title")]),
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

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
            
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
                                .numbered(index: 1, nodes: [.text("Nullam ornare viverra purus")]),
                            ]),
                            .list(nodes: [
                                .numbered(index: 2, nodes: [.text("Nullam ornare viverra purus")]),
                            ]),
                            .list(nodes: [
                                .numbered(index: 3, nodes: [.text("Nullam ornare viverra purus")]),
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
            
            describe("Quote") {
                it("should parse a full text as a quote") {
                    let text = """
                    > Nullam ornare viverra purus
                    """
                    let expectedNodes: [ASTNode] = [
                        .quote(nodes: [
                            .text("Nullam ornare viverra purus")
                        ])
                    ]

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
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

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }

                it("should parse header, bold and cursive nodes") {
                    let text = """
                    # Paragraph Title
                    > Nullam **ornare** viverra *purus*, eget accumsan `leo gravida` eget.
                    """
                    let expectedNodes: [ASTNode] = [
                        .header(depth: 1, nodes: [.text("Paragraph Title")]),
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

                    let coolDown = CDParser(text)
                    expect(coolDown.nodes) == expectedNodes
                }
            }
            describe("Text") {
                context("text begins with numbers") {
                    it("should parse with single leading digit") {
                        let text = """
                        1world
                        """
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("1world")
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    it("should parse with multiple leading digits") {
                        let text = """
                        123world
                        """
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("123world")
                            ])
                        ]

                        let coolDown = CDParser(text)
                        expect(coolDown.nodes) == expectedNodes
                    }

                    context("with whitespace after number") {
                        it("should parse with single leading digit") {
                            let text = """
                            1 world
                            """
                            let expectedNodes: [ASTNode] = [
                                .paragraph(nodes: [
                                    .text("1 world")
                                ])
                            ]

                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }

                        it("should parse with multiple leading digits") {
                            let text = """
                            123 world
                            """
                            let expectedNodes: [ASTNode] = [
                                .paragraph(nodes: [
                                    .text("123 world")
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
}
