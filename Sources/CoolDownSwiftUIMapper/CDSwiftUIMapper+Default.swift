import CoolDownParser
import SwiftUI
import Kingfisher

extension CDSwiftUIMapper {

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

    static func transformToIndex(nodes: [ASTNode]) -> [IndexASTNode] {
        Array(nodes.enumerated().map { index, node in
            IndexASTNode(index: index, node: node)
        })
    }
}
