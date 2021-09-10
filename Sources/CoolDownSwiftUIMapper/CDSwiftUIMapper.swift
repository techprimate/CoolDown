//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import SwiftUI

public typealias Resolver<Node: ASTNode, Result> = (Node) -> Result

public class CDSwiftUIMapper {

    // MARK: - Properties

    private var resolvers: [String: Resolver<ASTNode, AnyView>] = [:]

    // MARK: - Initializer

    public init() {}

    // MARK: - Accessors

    public func resolve(nodes: [ASTNode]) -> some View {
        ForEach(nodes, id: \.self) { node in
            self.resolve(node: node)
        }
    }

    @ViewBuilder
    public func resolve(node: ASTNode) -> some View {
        if let resolver = resolvers[String(describing: type(of: node))] {
            resolver(node)
        } else {
            Text("Missing resolver for node: \(node.description)")
        }
    }

    // MARK: - Modifiers

    public func addResolver<Node: ASTNode, ElementView: View>(for nodeType: Node.Type, resolver: @escaping (CDSwiftUIMapper, Node) -> ElementView) {
        resolvers[String(describing: nodeType)] = { node in
            guard let node = node as? Node else {
                fatalError("Internal resolver mismatch, expected node type does not match modifier type")
            }
            return AnyView(resolver(self, node))
        }
    }
}
