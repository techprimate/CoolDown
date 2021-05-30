//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import SwiftUI

@available(iOS 13.0, *)
public typealias Resolver<Node: ASTNode, Result> = (Node) -> Result

@available(iOS 13.0, *)
public class CDSwiftUIMapper {

    // MARK: - Properties

    private var resolvers: [String: Resolver<ASTNode, AnyView>] = [:]

    // MARK: - Initializer

    public init() {}

    // MARK: - Accessors

    public func resolve(nodes: [ASTNode]) throws -> AnyView {
        AnyView(
            ForEach(nodes, id: \.self) { node in
                self.resolve(node: node)
            }
        )
    }

    public func resolve(node: ASTNode) -> AnyView {
        do {
            return try NodeMapper.map(node: node, resolvers: self.resolvers)
        } catch {
            return AnyView(Text(error.localizedDescription))
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
