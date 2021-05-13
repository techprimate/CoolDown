//
//  ASTNode.swift
//  CDASTParser
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Foundation

public class ASTNode: Hashable, CustomStringConvertible, Equatable {

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        preconditionFailure("Subclass of ASTNode must implement hashing function")
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        String(describing: type(of: self))
    }

    // MARK: - Equatable

    public static func == (lhs: ASTNode, rhs: ASTNode) -> Bool {
        if type(of: lhs) == type(of: rhs), let lhsNode = lhs as? ContainerNode, let rhsNode = rhs as? ContainerNode {
            return lhsNode.nodes == rhsNode.nodes
        }
        if type(of: lhs) == type(of: rhs), let lhsNode = lhs as? TextNode, let rhsNode = rhs as? TextNode {
            return lhsNode.content == rhsNode.content
        }
        if let lhsNode = lhs as? HeaderNode, let rhsNode = rhs as? HeaderNode {
            return lhsNode.depth == rhsNode.depth && lhsNode.nodes == rhsNode.nodes
        }
        return false
    }

    // MARK: - Generators

    public static func paragraph(nodes: [ASTNode]) -> ParagraphNode {
        ParagraphNode(nodes: nodes)
    }

    public static func header(depth: Int, nodes: [ASTNode]) -> HeaderNode {
        HeaderNode(depth: depth, nodes: nodes)
    }

    public static func cursive(_ content: String) -> CursiveNode {
        CursiveNode(content: content)
    }

    public static func bold(_ content: String) -> BoldNode {
        BoldNode(content: content)
    }

    public static func cursiveBold(_ content: String) -> CursiveBoldNode {
        CursiveBoldNode(content: content)
    }

    public static func text(_ content: String) -> TextNode {
        TextNode(content: content)
    }

    public static func code(_ content: String) -> CodeNode {
        CodeNode(content: content)
    }

    public static func list(nodes: [ASTNode]) -> ListNode {
        ListNode(nodes: nodes)
    }

    public static func bullet(nodes: [ASTNode]) -> BulletNode {
        BulletNode(nodes: nodes)
    }

    public static func numbered(index: Int, nodes: [ASTNode]) -> NumberedNode {
        NumberedNode(index: index, nodes: nodes)
    }

    public static func quote(nodes: [ASTNode]) -> QuoteNode {
        QuoteNode(nodes: nodes)
    }

    public static func codeBlock(nodes: [ASTNode]) -> CodeBlockNode {
        CodeBlockNode(nodes: nodes)
    }
}
