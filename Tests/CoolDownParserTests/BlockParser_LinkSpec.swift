@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_LinkSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
            describe("Link") {
                it("should parse a simple inline link with a title") {
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

                it("should parse a simple inline link without a title") {
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

                it("should parse a simple inline link without a title nor a uri") {
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
        }
    }
}
