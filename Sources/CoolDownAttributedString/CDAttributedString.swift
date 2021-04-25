//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public typealias Modifier<Node> = (Node) -> [NSAttributedString.Key: Any]

public class CDAttributedString {

    // MARK: - Properties

    private let nodes: [ASTNode]
    private var modifiers: [String: Modifier<Any>] = [:]

    // MARK: - Initializer

    public init(from nodes: [ASTNode]) {
        self.nodes = nodes
    }

    public convenience init(text: String) {
        self.init(from: CoolDown(text).nodes)
    }

    public convenience init(url: URL) throws {
        self.init(from: try CoolDown(url: url).nodes)
    }

    // MARK: - Accessors

    public var attributedString: NSAttributedString {
        return nodes
            .map { NodeMapper.map(node: $0, modifiers: modifiers) }
            .reduce(NSAttributedString(), +)
    }

    // MARK: - Modifiers

    public func addModifier<Node: ASTNode>(for kind: Node.Type, modifier: @escaping Modifier<Node>) {
        modifiers[String(describing: kind)] = { node in
            modifier(node as! Node)
        }
    }
}
