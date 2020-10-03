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

    static func map(node: ASTNode, modifiers: [String: Modifier<Any>]) -> NSAttributedString {
        let modifier = modifiers[String(describing: type(of: node))]
        if let textNode = node as? TextNode {
            return NSAttributedString(string: textNode.content, attributes: modifier?(textNode))
        } else if let containerNode = node as? ContainerNode {
            let mappedAttributedStrings = containerNode.nodes.map { NodeMapper.map(node: $0, modifiers: modifiers) }
            let result = NSMutableAttributedString()
            for attributedString in mappedAttributedStrings {
                result.append(attributedString)
                if containerNode is ParagraphNode {
                    result.append(NSAttributedString(string: "\n\r"))
                } else if containerNode is ListNode {
                    result.append(NSAttributedString(string: "\n"))
                } else {
                    result.append(NSAttributedString(string: " "))
                }
            }
            if let attributes = modifier?(containerNode) {
                result.addAttributes(attributes, range: NSRange(location: 0, length: result.length))
            }
            return result
        } else {
            return NSAttributedString()
        }
    }
}
