//
//  NodeMapper.swift
//  CoolDownAttributedString
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class NodeMapper {

    static func map(node: ASTNode, modifiers: [String: Modifier]) -> NSAttributedString {
        let modifier = modifiers[String(describing: type(of: node))]
        if let textNode = node as? TextNode {
            return NSAttributedString(string: textNode.content, attributes: modifier?())
        } else {
            return NSAttributedString()
        }
    }
}
