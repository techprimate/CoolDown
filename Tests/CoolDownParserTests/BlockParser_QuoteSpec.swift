@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_QuoteSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
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
        }
    }
}
