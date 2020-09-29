//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public typealias Modifier = () -> [NSAttributedString.Key : Any]

public class CDAttributedString {

    // MARK: - Properties

    private let nodes: [ASTNode]
    private var modifiers: [NodeKind: Modifier] = [:]

    // MARK: - Initializer

    public init(from nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Accessors

    var attributedString: NSAttributedString {
        return nodes
            .map { NodeMapper.map(node: $0, modifiers: modifiers) }
            .reduce(NSAttributedString(), +)
    }

    // MARK: - Modifiers

    func addModifier(for kind: NodeKind, modifier: @escaping Modifier) {
        modifiers[kind] = modifier
    }
}

public enum NodeKind {
    case header
    case paragraph
    case list
    case bullet
    case numbered
    case quote
    case codeBlock

    case bold
    case cursive
    case cursiveBold

    case code
    case text
}

class NodeMapper {

    static func map(node: ASTNode, modifiers: [NodeKind: Modifier]) -> NSAttributedString {
        switch node {
        case .text(let content):
            return NSAttributedString(string: content, attributes: modifiers[.text]?())
        default:
            return NSAttributedString()
        }
    }
}
