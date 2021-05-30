import Quick
import Nimble
@testable import CoolDownParser

class BlockParser_HeaderSpec: QuickSpec {

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
                        .header(depth: 1, nodes: [.text("Title 1")]),
                        .header(depth: 1, nodes: [.text("Title 2")]),
                        .header(depth: 1, nodes: [.text("Title 3")]),
                        .header(depth: 1, nodes: [.text("Title 4")])
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
                            .header(depth: 1, nodes: [.text("Title 1")]),
                            .header(depth: 1, nodes: [.text("Title 2")]),
                            .header(depth: 1, nodes: [.text("Title 3")]),
                            .header(depth: 1, nodes: [.text("Title 4")])
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
                        let expectedNodes: [ASTNode] = [
                            .codeBlock(nodes: [
                                .code("# foo")
                            ])
                        ]
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

        }
    }
}
