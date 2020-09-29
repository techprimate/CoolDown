//
//  CDUIMapperSpec.swift
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import CoolDownParser
@testable import CoolDownUIMapper

class CDUIMapperSpec: QuickSpec {

    override func spec() {
        describe("CDUIMapper") {
            context("no resolvers given") {
                it("should fail") {
                    let nodes: [ASTNode] = [
                        .text("foo")
                    ]
                    let mapper = CDUIMapper(from: nodes)
                    do {
                        _ = try mapper.resolve()
                        fail("Should have thrown error")
                    } catch CDUIMapperError.missingResolver(let node) {
                        expect(node) == nodes[0]
                    } catch {
                        fail("Should have thrown other error")
                    }
                }
            }

            context("has text resolver") {
                it("should convert a text node to an attributed string") {
                    let nodes: [ASTNode] = [
                        .text("foo")
                    ]

                    let view = View()
                    let mapper = CDUIMapper(from: nodes)
                    mapper.addResolver(for: TextNode.self) { node -> View in
                        view
                    }
                    do {
                        let resolved = try mapper.resolve()
                        expect(resolved[0]) === view
                    } catch {
                        fail("Should not throw error")
                    }
                }
            }
        }
    }
}
