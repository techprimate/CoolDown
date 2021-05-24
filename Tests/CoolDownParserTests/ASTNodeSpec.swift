//
//  ASTNodeSpec.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

@testable import CoolDownParser
import Nimble
import Quick

class ASTNodeSpec: QuickSpec {

    override func spec() {
        describe("ASTNode") {
            describe("Equatable") {

                let allCases: [ASTNode] = [
                    .header(depth: -1, nodes: []),
                    .paragraph(nodes: []),
                    .list(nodes: []),
                    .bullet(nodes: []),
                    .numbered(index: -1, nodes: []),
                    .quote(nodes: []),
                    .codeBlock(nodes: []),
                    .text(""),
                    .bold(""),
                    .cursive(""),
                    .cursiveBold(""),
                    .code("")
                ]

                for (i, lhsNode) in allCases.enumerated() {
                    for (j, rhsNode) in allCases.enumerated() where i != j {
                        it("should not be equal \(lhsNode) with \(rhsNode)") {
                            expect(lhsNode == rhsNode) == false
                        }
                    }
                }

                describe("Header") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.header(depth: 0, nodes: []) == ASTNode.header(depth: 0, nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.header(depth: 0, nodes: [
                                .text("A")
                            ]) == ASTNode.header(depth: 0, nodes: [])) == false
                            expect(ASTNode.header(depth: 0, nodes: []) == ASTNode.header(depth: 0, nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.header(depth: 0, nodes: [
                                .text("A")
                            ]) == ASTNode.header(depth: 0, nodes: [
                                .text("B")
                            ])) == false
                        }
                    }
                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.header(depth: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.header(depth: 0, nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.header(depth: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.header(depth: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Paragraph") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.paragraph(nodes: []) == ASTNode.paragraph(nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.paragraph(nodes: [
                                .text("A")
                            ]) == ASTNode.paragraph(nodes: [])) == false
                            expect(ASTNode.paragraph(nodes: []) == ASTNode.paragraph(nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.paragraph(nodes: [
                                .text("A")
                            ]) == ASTNode.paragraph(nodes: [
                                .text("B")
                            ])) == false
                        }
                    }
                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.paragraph(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.paragraph(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.paragraph(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.paragraph(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Numbered") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.numbered(index: 0, nodes: []) == ASTNode.numbered(index: 0, nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.numbered(index: 0, nodes: [
                                .text("A")
                            ]) == ASTNode.numbered(index: 0, nodes: [])) == false
                            expect(ASTNode.numbered(index: 0, nodes: []) == ASTNode.numbered(index: 0, nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.numbered(index: 0, nodes: [
                                .text("A")
                            ]) == ASTNode.numbered(index: 0, nodes: [
                                .text("B")
                            ])) == false
                        }
                    }

                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.numbered(index: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.numbered(index: 0, nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false

                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.numbered(index: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.numbered(index: 0, nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Bullet") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.bullet(nodes: []) == ASTNode.bullet(nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.bullet(nodes: [
                                .text("A")
                            ]) == ASTNode.bullet(nodes: [])) == false
                            expect(ASTNode.bullet(nodes: []) == ASTNode.bullet(nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.bullet(nodes: [
                                .text("A")
                            ]) == ASTNode.bullet(nodes: [
                                .text("B")
                            ])) == false
                        }
                    }

                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.bullet(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.bullet(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false

                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.bullet(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.bullet(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("List") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.list(nodes: []) == ASTNode.list(nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.list(nodes: [
                                .text("A")
                            ]) == ASTNode.list(nodes: [])) == false
                            expect(ASTNode.list(nodes: []) == ASTNode.list(nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.list(nodes: [
                                .text("A")
                            ]) == ASTNode.list(nodes: [
                                .text("B")
                            ])) == false
                        }
                    }

                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.list(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.list(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.list(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.list(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Quote") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.quote(nodes: []) == ASTNode.quote(nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.quote(nodes: [
                                .text("A")
                            ]) == ASTNode.quote(nodes: [])) == false
                            expect(ASTNode.quote(nodes: []) == ASTNode.quote(nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.quote(nodes: [
                                .text("A")
                            ]) == ASTNode.quote(nodes: [
                                .text("B")
                            ])) == false
                        }
                    }
                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.quote(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.quote(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.quote(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.quote(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Code Block") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.codeBlock(nodes: []) == ASTNode.codeBlock(nodes: [])) == true
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.codeBlock(nodes: [
                                .text("A")
                            ]) == ASTNode.codeBlock(nodes: [])) == false
                            expect(ASTNode.codeBlock(nodes: []) == ASTNode.codeBlock(nodes: [
                                .text("A")
                            ])) == false
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.codeBlock(nodes: [
                                .text("A")
                            ]) == ASTNode.codeBlock(nodes: [
                                .text("B")
                            ])) == false
                        }
                    }
                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.codeBlock(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.codeBlock(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])) == false
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.codeBlock(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.codeBlock(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])) == true
                            }
                        }
                    }
                }

                describe("Text") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.text("") == ASTNode.text("")) == true
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.text("A") == ASTNode.text("A")) == true
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.text("A") == ASTNode.text("B")) == false
                        }
                    }
                }

                describe("Bold") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.bold("") == ASTNode.bold("")) == true
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.bold("A") == ASTNode.bold("A")) == true
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.bold("A") == ASTNode.bold("B")) == false
                        }
                    }
                }

                describe("Cursive") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursive("") == ASTNode.cursive("")) == true
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursive("A") == ASTNode.cursive("A")) == true
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.cursive("A") == ASTNode.cursive("B")) == false
                        }
                    }
                }

                describe("CursiveBold") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursiveBold("") == ASTNode.cursiveBold("")) == true
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursiveBold("A") == ASTNode.cursiveBold("A")) == true
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.cursiveBold("A") == ASTNode.cursiveBold("B")) == false
                        }
                    }
                }

                describe("Code") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.code("") == ASTNode.code("")) == true
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.code("A") == ASTNode.code("A")) == true
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.code("A") == ASTNode.code("B")) == false
                        }
                    }
                }
            }
        }
    }
}
