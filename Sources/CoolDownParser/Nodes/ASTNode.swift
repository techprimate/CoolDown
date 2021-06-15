//
//  ASTNode.swift
//  CDASTParser
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Foundation

open class ASTNode: CustomStringConvertible, Equatable, Hashable {

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
        switch (lhs, rhs) {
        case let (lhs as TextNode, rhs as TextNode):
            return lhs.equals(other: rhs)
        case let (lhs as NumberedNode, rhs as NumberedNode):
            return lhs.equals(other: rhs)
        case let (lhs as LinkNode, rhs as LinkNode):
            return lhs.equals(other: rhs)
        case let (lhs as HeaderNode, rhs as HeaderNode):
            return lhs.equals(other: rhs)
        case let (lhs as ContainerNode, rhs as ContainerNode):
            return lhs.equals(other: rhs)
        default:
            return false
        }
    }

    open func equals(other: AnyObject) -> Bool {
        type(of: self).self === type(of: other).self
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

    public static func link(uri: String, title: String? = nil, nodes: [ASTNode]) -> LinkNode {
        LinkNode(uri: uri, title: title, nodes: nodes)
    }

    public static func image(uri: String, title: String? = nil, nodes: [ASTNode]) -> ImageNode {
        ImageNode(uri: uri, title: title, nodes: nodes)
    }
}

public protocol AnyEquatable {
    func equals(other: AnyEquatable) -> Bool
    func canEqualReverseDispatch(other: AnyEquatable) -> Bool
}

public func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    lhs.equals(other: rhs)
}

public func != (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    !lhs.equals(other: rhs)
}
