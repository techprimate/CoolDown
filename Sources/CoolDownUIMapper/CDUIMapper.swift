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

public typealias View = UIView

#elseif canImport(AppKit)
import AppKit

public typealias View = NSView
#endif

public typealias Resolver = (ASTNode) -> View

public class CDUIMapper {

    // MARK: - Properties

    private let nodes: [ASTNode]
    private var resolvers: [String: Resolver] = [:]

    // MARK: - Initializer

    public init(from nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Accessors

    func resolve() throws -> [View] {
        try nodes.map { node in
            try NodeMapper.map(node: node, resolvers: resolvers)
        }
    }

    // MARK: - Modifiers

    func addResolver<Node: ASTNode>(for nodeType: Node.Type, resolver: @escaping Resolver) {
        resolvers[String(describing: nodeType)] = resolver
    }
}
