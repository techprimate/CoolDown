//
//  ASTNodeSpec.swift
//  CDASTParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble
@testable import CDASTParser

class ASTNodeSpec: QuickSpec {

    override func spec() {
        describe("ASTNode") {
            describe("Equatable") {

                let allCases: [ASTNode] = [
                    .header(nodes: []),
                    .paragraph(nodes: []),
                    .bullet(nodes: []),
                    .list(nodes: []),
                    .quote(nodes: []),
                    .text(""),
                    .bold(""),
                    .cursive(""),
                    .code("")
                ]

                for (i, lhsNode) in allCases.enumerated() {
                    for (j, rhsNode) in allCases.enumerated() where i != j {
                        it("should not be equal \(lhsNode) with \(rhsNode)") {
                            expect(lhsNode == rhsNode).to(beFalse())
                        }
                    }
                }

                describe("Header") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.header(nodes: []) == ASTNode.header(nodes: [])).to(beTrue())
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.header(nodes: [
                                .text("A")
                            ]) == ASTNode.header(nodes: [])).to(beFalse())
                            expect(ASTNode.header(nodes: []) == ASTNode.header(nodes: [
                                .text("A")
                            ])).to(beFalse())
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.header(nodes: [
                                .text("A")
                            ]) == ASTNode.header(nodes: [
                                .text("B")
                            ])).to(beFalse())
                        }
                    }
                    context("equal nodes") {
                        context("different order") {
                            it("should not be equal if elements equal but differ in order") {
                                expect(ASTNode.header(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.header(nodes: [
                                    .text("B"),
                                    .text("A")
                                ])).to(beFalse())
                            }
                        }

                        context("same order") {
                            it("should be equal truthy") {
                                expect(ASTNode.header(nodes: [
                                    .text("A"),
                                    .text("B")
                                ]) == ASTNode.header(nodes: [
                                    .text("A"),
                                    .text("B")
                                ])).to(beTrue())
                            }
                        }
                    }
                }

                describe("Paragraph") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.paragraph(nodes: []) == ASTNode.paragraph(nodes: [])).to(beTrue())
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.paragraph(nodes: [
                                .text("A")
                            ]) == ASTNode.paragraph(nodes: [])).to(beFalse())
                            expect(ASTNode.paragraph(nodes: []) == ASTNode.paragraph(nodes: [
                                .text("A")
                            ])).to(beFalse())
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.paragraph(nodes: [
                                .text("A")
                            ]) == ASTNode.paragraph(nodes: [
                                .text("B")
                            ])).to(beFalse())
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
                                ])).to(beFalse())
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
                                ])).to(beTrue())
                            }
                        }
                    }
                }
                
                describe("Bullet") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.bullet(nodes: []) == ASTNode.bullet(nodes: [])).to(beTrue())
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.bullet(nodes: [
                                .text("A")
                            ]) == ASTNode.bullet(nodes: [])).to(beFalse())
                            expect(ASTNode.bullet(nodes: []) == ASTNode.bullet(nodes: [
                                .text("A")
                            ])).to(beFalse())
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.bullet(nodes: [
                                .text("A")
                            ]) == ASTNode.bullet(nodes: [
                                .text("B")
                            ])).to(beFalse())
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
                                ])).to(beFalse())
                                    
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
                                ])).to(beTrue())
                            }
                        }
                    }
                }
                
                describe("List") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.list(nodes: []) == ASTNode.list(nodes: [])).to(beTrue())
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.list(nodes: [
                                .text("A")
                            ]) == ASTNode.list(nodes: [])).to(beFalse())
                            expect(ASTNode.list(nodes: []) == ASTNode.list(nodes: [
                                .text("A")
                            ])).to(beFalse())
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.list(nodes: [
                                .text("A")
                            ]) == ASTNode.list(nodes: [
                                .text("B")
                            ])).to(beFalse())
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
                                ])).to(beFalse())
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
                                ])).to(beTrue())
                            }
                        }
                    }
                }
                
                describe("Quote") {

                    context("no nodes") {
                        it("should be equal truthy") {
                            expect(ASTNode.quote(nodes: []) == ASTNode.quote(nodes: [])).to(beTrue())
                        }
                    }

                    context("different node count") {
                        it("should not be equal") {
                            expect(ASTNode.quote(nodes: [
                                .text("A")
                            ]) == ASTNode.quote(nodes: [])).to(beFalse())
                            expect(ASTNode.quote(nodes: []) == ASTNode.quote(nodes: [
                                .text("A")
                            ])).to(beFalse())
                        }
                    }

                    context("different nodes") {
                        it("should not be equal") {
                            expect(ASTNode.quote(nodes: [
                                .text("A")
                            ]) == ASTNode.quote(nodes: [
                                .text("B")
                            ])).to(beFalse())
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
                                ])).to(beFalse())
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
                                ])).to(beTrue())
                            }
                        }
                    }
                }

                describe("Text") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.text("") == ASTNode.text("")).to(beTrue())
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.text("A") == ASTNode.text("A")).to(beTrue())
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.text("A") == ASTNode.text("B")).to(beFalse())
                        }
                    }
                }

                describe("Bold") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.bold("") == ASTNode.bold("")).to(beTrue())
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.bold("A") == ASTNode.bold("A")).to(beTrue())
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.bold("A") == ASTNode.bold("B")).to(beFalse())
                        }
                    }
                }
                
                describe("Cursive") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursive("") == ASTNode.cursive("")).to(beTrue())
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.cursive("A") == ASTNode.cursive("A")).to(beTrue())
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.cursive("A") == ASTNode.cursive("B")).to(beFalse())
                        }
                    }
                }
                
                describe("Code") {
                    context("empty content strings") {
                        it("should be equal") {
                            expect(ASTNode.code("") == ASTNode.code("")).to(beTrue())
                        }
                    }

                    context("equal content strings") {
                        it("should be equal") {
                            expect(ASTNode.code("A") == ASTNode.code("A")).to(beTrue())
                        }
                    }

                    context("different content strings") {
                        it("should not be equal") {
                            expect(ASTNode.code("A") == ASTNode.code("B")).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
