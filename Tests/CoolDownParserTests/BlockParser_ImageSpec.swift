@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_ImageSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("image") {
                context("inline") {
                    context("without closing bracket") {
                        it("should not parse image") {
                            let text = """
                            ![link(/uri)
                            """
                            let expectedNodes: [ASTNode] = [
                                .paragraph(nodes: [
                                    .text("![link(/uri)")
                                ])
                            ]
                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }
                    }
                    context("without closing parantheses") {
                        it("should not parse image") {
                            let text = """
                            ![link](/uri
                            """
                            let expectedNodes: [ASTNode] = [
                                .paragraph(nodes: [
                                    .text("![link](/uri")
                                ])
                            ]
                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }
                    }
                    context("with title") {
                        it("should parse image uri and title") {
                            let text = """
                            ![link](/uri "title")
                            """
                            let expectedNodes: [ASTNode] = [
                                .image(uri: "/uri", title: "title", nodes: [
                                    .text("link")
                                ])
                            ]

                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }
                    }
                    context("without title") {
                        it("should link and uri") {
                            let text = """
                            ![link](/uri)
                            """
                            let expectedNodes: [ASTNode] = [
                                .image(uri: "/uri", title: nil, nodes: [
                                    .text("link")
                                ])
                            ]

                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }

                        context("empty uri") {
                            it("should parse empty uri and title") {
                                let text = """
                                ![link]()
                                """
                                let expectedNodes: [ASTNode] = [
                                    .image(uri: "", title: nil, nodes: [
                                        .text("link")
                                    ])
                                ]

                                let coolDown = CDParser(text)
                                expect(coolDown.nodes) == expectedNodes
                            }
                        }

                        context("empty brackets as uri") {
                            it("should be an empty uri and title") {
                                let text = """
                                ![link](<>)
                                """
                                let expectedNodes: [ASTNode] = [
                                    .image(uri: "", title: nil, nodes: [
                                        .text("link")
                                    ])
                                ]

                                let coolDown = CDParser(text)
                                expect(coolDown.nodes) == expectedNodes
                            }
                        }

                        context("whitespace in uri") {
                            context("without brackets") {
                                it("should not return a valid link") {
                                    let text = """
                                    ![link](/my uri)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .paragraph(nodes: [
                                            .text("![link](/my uri)")
                                        ])
                                    ]

                                    let coolDown = CDParser(text)
                                    expect(coolDown.nodes) == expectedNodes
                                }
                            }

                            context("with brackets") {
                                it("should return a valid link") {
                                    let text = """
                                    ![link](</my uri>)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .image(uri: "/my uri", title: nil, nodes: [
                                            .text("link")
                                        ])
                                    ]

                                    let coolDown = CDParser(text)
                                    expect(coolDown.nodes) == expectedNodes
                                }

                                it("needs to unescaped") {
                                    let text = """
                                    ![link](</my uri\\>)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .paragraph(nodes: [
                                            .text("![link](</my uri\\>)")
                                        ])
                                    ]

                                    let coolDown = CDParser(text)
                                    expect(coolDown.nodes) == expectedNodes
                                }
                            }
                        }

                        context("line breaks in uri") {
                            context("without brackets") {
                                it("should not be parsed as image") {
                                    let text = """
                                    ![link](/my
                                    uri)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .paragraph(nodes: [
                                            .text("![link](/my"),
                                        ]),
                                        .paragraph(nodes: [
                                            .text("uri)")
                                        ])
                                    ]

                                    let coolDown = CDParser(text)
                                    expect(coolDown.nodes) == expectedNodes
                                }
                            }

                            context("with brackets") {
                                it("should not be parsed as link") {
                                    let text = """
                                    ![link](</my
                                    uri>)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .paragraph(nodes: [
                                            .text("![link](</my"),
                                        ]),
                                        .paragraph(nodes: [
                                            .text("uri>)")
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
    }
}
