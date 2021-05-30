@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_LinkSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("Link") {
                context("inline") {
                    context("with title") {
                        it("should parse link uri and title") {
                            // based on https://spec.commonmark.org/0.29/#example-481
                            let text = """
                            [link](/uri "title")
                            """
                            let expectedNodes: [ASTNode] = [
                                .link(uri: "/uri", title: "title", nodes: [
                                    .text("link")
                                ])
                            ]

                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }
                    }
                    context("without title") {
                        it("should link and uri") {
                            // based on https://spec.commonmark.org/0.29/#example-482
                            let text = """
                            [link](/uri)
                            """
                            let expectedNodes: [ASTNode] = [
                                .link(uri: "/uri", title: nil, nodes: [
                                    .text("link")
                                ])
                            ]

                            let coolDown = CDParser(text)
                            expect(coolDown.nodes) == expectedNodes
                        }

                        context("empty uri") {
                            it("should parse empty uri and title") {
                                // based on https://spec.commonmark.org/0.29/#example-483
                                let text = """
                                [link]()
                                """
                                let expectedNodes: [ASTNode] = [
                                    .link(uri: "", title: nil, nodes: [
                                        .text("link")
                                    ])
                                ]

                                let coolDown = CDParser(text)
                                expect(coolDown.nodes) == expectedNodes
                            }
                        }

                        context("empty brackets as uri") {
                            it("should be an empty uri and title") {
                                // based on https://spec.commonmark.org/0.29/#example-484
                                let text = """
                                [link](<>)
                                """
                                let expectedNodes: [ASTNode] = [
                                    .link(uri: "", title: nil, nodes: [
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
                                    // based on https://spec.commonmark.org/0.29/#example-485
                                    let text = """
                                    [link](/my uri)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .paragraph(nodes: [
                                            .text("[link](/my uri)")
                                        ])
                                    ]

                                    let coolDown = CDParser(text)
                                    expect(coolDown.nodes) == expectedNodes
                                }
                            }

                            context("with brackets") {
                                it("should return a valid link") {
                                    // based on https://spec.commonmark.org/0.29/#example-486
                                    let text = """
                                    [link](</my uri>)
                                    """
                                    let expectedNodes: [ASTNode] = [
                                        .link(uri: "/my uri", title: nil, nodes: [
                                            .text("link")
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
