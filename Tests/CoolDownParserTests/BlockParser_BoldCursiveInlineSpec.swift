//
//  BoldCursiveInlineSpec.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_BoldCursiveInlineSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("cursive inline") {
                context("standalone") {
                    it("should be parsed") {
                        let text = "*foo*"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [.cursive("foo")])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
                context("in full-text") {
                    it("should be parsed") {
                        let text = "some preceeding text *foo* some succeeding text"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("some preceeding text "),
                                .cursive("foo"),
                                .text(" some succeeding text")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
                context("in word") {
                    it("should be parsed") {
                        let text = "super*awesome*library"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("super"),
                                .cursive("awesome"),
                                .text("library")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }

            describe("bold inline") {
                context("standalone") {
                    it("should be parsed") {
                        let text = "**foo**"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [.bold("foo")])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
                context("in full-text") {
                    it("should be parsed") {
                        let text = "some preceeding text **foo** some succeeding text"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("some preceeding text "),
                                .bold("foo"),
                                .text(" some succeeding text")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
                context("in word") {
                    it("should be parsed") {
                        let text = "super**awesome**library"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("super"),
                                .bold("awesome"),
                                .text("library")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }

            describe("bold & cursive inline") {
                context("standalone") {
                it("should be parsed") {
                    let text = "***foo***"
                    let actualNodes = CDParser(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [.cursiveBold("foo")])
                    ]

                    expect(actualNodes) == expectedNodes
                }
                }
                context("in full-text") {
                    it("should be parsed") {
                        let text = "some preceeding text ***foo*** some succeeding text"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("some preceeding text "),
                                .cursiveBold("foo"),
                                .text(" some succeeding text")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
                context("in word") {
                    it("should be parsed") {
                        let text = "super***awesome***library"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .text("super"),
                                .cursiveBold("awesome"),
                                .text("library")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }

            context("bold in cursive") {
                it("should return both elements") {
                    let text = "*some **bold** in cursive*"
                    let actualNodes = CDParser(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursive("some "),
                            .cursiveBold("bold"),
                            .cursive(" in cursive")
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }

                context("at start") {
                    it("should return both elements") {
                        let text = "***bold** in cursive*"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .cursiveBold("bold"),
                                .cursive(" in cursive")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }

                context("at end") {
                    it("should return both elements") {
                        let text = "*cursive around **bold***"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .cursive("cursive around "),
                                .cursiveBold("bold")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }

            context("cursive in bold") {
                it("should return both elements") {
                    let text = "**some *cursive* in bold**"
                    let actualNodes = CDParser(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .bold("some "),
                            .cursiveBold("cursive"),
                            .bold(" in bold")
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }

                context("at start") {
                    it("should return both elements") {
                        let text = "***cursive* in bold*"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .cursiveBold("cursive"),
                                .bold(" in bold")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }

                context("at end") {
                    it("should return both elements") {
                        let text = "**bold around *cursive***"
                        let actualNodes = CDParser(text).nodes
                        let expectedNodes: [ASTNode] = [
                            .paragraph(nodes: [
                                .bold("bold around "),
                                .cursiveBold("cursive")
                            ])
                        ]

                        expect(actualNodes) == expectedNodes
                    }
                }
            }

            context("in cursive bold") {
                it("should return both elements") {
                    let text = "*in cursive **bold***"
                    let actualNodes = CDParser(text).nodes
                    let expectedNodes: [ASTNode] = [
                        .paragraph(nodes: [
                            .cursive("in cursive "),
                            .cursiveBold("bold")
                        ])
                    ]

                    expect(actualNodes) == expectedNodes
                }
            }
        }

        describe("non-terminating cursive") {
            it("should return a text with the leading asteriks") {
                let text = "word *some text"
                let actualNodes = CDParser(text).nodes
                let expectedNodes: [ASTNode] = [
                    .paragraph(nodes: [
                        .text(text)
                    ])
                ]

                expect(actualNodes) == expectedNodes
            }
        }

        describe("non-terminating bold") {
            it("should return a text with the leading two asteriks") {
                let text = "word **some text"
                let actualNodes = CDParser(text).nodes
                let expectedNodes: [ASTNode] = [
                    .paragraph(nodes: [
                        .text(text)
                    ])
                ]

                expect(actualNodes) == expectedNodes
            }
        }

        describe("non-terminating nested cursive in bold") {
            it("should ignore nested block") {
                let text = "some *cursive **unterminated-bold* text"
                let actualNodes = CDParser(text).nodes
                let expectedNodes: [ASTNode] = [
                    .paragraph(nodes: [
                        .text("some "),
                        .cursive("cursive **unterminated-bold"),
                        .text(" text")
                    ])
                ]

                expect(actualNodes) == expectedNodes
            }
        }

        describe("non-terminating nested bold in cursive") {
            it("should only parse the nested block") {
                let text = "some **cursive *unterminated-bold** text"
                let actualNodes = CDParser(text).nodes
                let expectedNodes: [ASTNode] = [
                    .paragraph(nodes: [
                        .text("some *"),
                        .cursive("cursive "),
                        .text("unterminated-bold** text")
                    ])
                ]

                expect(actualNodes) == expectedNodes
            }
        }
    }
}
