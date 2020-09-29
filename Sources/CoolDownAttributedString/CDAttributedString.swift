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
    private var modifiers: [String: Modifier] = [:]

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

    func addModifier<Node: ASTNode>(for kind: Node.Type, modifier: @escaping Modifier) {
        modifiers[String(describing: kind)] = modifier
    }
}
