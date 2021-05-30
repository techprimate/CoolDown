@testable import CoolDownParser
import Nimble
import Quick

class BlockParser_TextSpec: QuickSpec {

    override func spec() {
        describe("BlockParser") {
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
