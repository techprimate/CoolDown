//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CDASTParser
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public typealias Modifier = () -> [NSAttributedString.Key : Any]

public class CDAttributedString {

    // MARK: - Properties

    private let nodes: [ASTNode]
    private var modifiers: [String: Modifier] = [:]

    // MARK: - Initializer

    public init(from nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Accessors

    var attributedString: NSAttributedString {
        NodeMapper.map(node: nodes[0], modifiers: modifiers)
    }

    // MARK: - Modifiers

    func addModifier(for nodeType: String, modifier: @escaping Modifier) {
        modifiers[nodeType] = modifier
    }
}

class NodeMapper {

    static func map(node: ASTNode, modifiers: [String: Modifier]) -> NSAttributedString {
        switch node {
        case .text(let content):
            return NSAttributedString(string: content, attributes: modifiers["text"]?())
        default:
            return NSAttributedString()
        }
    }
}
