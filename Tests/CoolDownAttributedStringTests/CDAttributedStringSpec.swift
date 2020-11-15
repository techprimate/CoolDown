//
//  CDAttributedStringSpec.swift
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Quick
import Nimble
#if canImport(UIKit)
import UIKit

typealias Color = UIColor
#elseif canImport(AppKit)
import AppKit

typealias Color = NSColor
#endif
import CoolDownParser
@testable import CoolDownAttributedString

class CDAttributedStringSpec: QuickSpec {

    override func spec() {
        context("no custom styling") {
            it("should convert a text node to an attributed string") {
                let nodes: [ASTNode] = [
                    .text("foo")
                ]
                let cdAttr = CDAttributedString(from: nodes)

                let expected = NSAttributedString(string: "foo")
                expect(cdAttr.attributedString) == expected
            }
        }

        context("custom text node styling") {
            it("should convert a text node to an attributed string") {
                let nodes: [ASTNode] = [
                    .text("foo")
                ]
                let cdAttr = CDAttributedString(from: nodes)
                cdAttr.addModifier(for: TextNode.self) { node in
                    expect(node) == .text("foo")
                    return [
                        .foregroundColor: Color.green
                    ]
                }

                let expected = NSAttributedString(string: "foo", attributes: [
                    .foregroundColor: Color.green
                ])
                expect(cdAttr.attributedString) == expected
            }
        }
    }
}
