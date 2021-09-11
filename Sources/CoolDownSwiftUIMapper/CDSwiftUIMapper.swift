//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import SwiftUI

public class CDSwiftUIMapper {

    static func transform(nodes: [ASTNode]) -> [ASTNode] {
        var transformedNodes: [ASTNode] = []
        for node in nodes {
            if let textNode = node as? TextNode {
                if let prev = transformedNodes.last as? TextNodesBox {
                    transformedNodes[transformedNodes.count - 1] = TextNodesBox(nodes: prev.nodes + [textNode])
                } else {
                    transformedNodes.append(TextNodesBox(nodes: [textNode]))
                }
            } else if let container = node as? ContainerNode {
                container.nodes = transform(nodes: container.nodes)
                transformedNodes.append(container)
            } else {
                transformedNodes.append(node)
            }
        }
        return transformedNodes
    }

    static func transformToIndex(parentIndex: CDIndexNode, nodes: [ASTNode]) -> [IndexASTNode] {
        Array(nodes.enumerated().map { index, node in
            IndexASTNode(index: .nested(parent: parentIndex, index: index), node: node)
        })
    }
}
