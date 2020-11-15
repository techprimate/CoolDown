//
//  ASTNode.swift
//  CDASTParser
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Foundation

public class ASTNode {

    //case link(_ content: String) or case link(content: String, target: String)
    //case image(_ content: String) or case image(content: String, source: String)
    //custom cases e.g Map Element
}

extension ASTNode: Equatable {

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

    // Generators

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

extension ASTNode: CustomStringConvertible {

    @objc public var description: String {
        String(describing: type(of: self))
    }
}

public class ContainerNode: ASTNode {

    public internal(set) var nodes: [ASTNode]

    internal init(nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Custom String Convertible

    @objc public override var description: String {
        return String(describing: type(of: self)) + " {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }
}

public class HeaderNode: ContainerNode {

    public let depth: Int

    init(depth: Int, nodes: [ASTNode]) {
        self.depth = depth
        super.init(nodes: nodes)
    }

    @objc override public var description: String {
        return String(describing: type(of: self)) + "(\(depth)) {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }
}

public class ParagraphNode: ContainerNode {}

public class CodeBlockNode: ContainerNode {}

public class QuoteNode: ContainerNode {}

public class ListNode: ContainerNode {}

public class BulletNode: ContainerNode {}

public class NumberedNode: ContainerNode {

    public let index: Int

    init(index: Int, nodes: [ASTNode]) {
        self.index = index
        super.init(nodes: nodes)
    }

    @objc override public var description: String {
        return String(describing: type(of: self)) + "(\(index)) {\n"
            + nodes.map(\.description).joined(separator: ", \n")
            + "\n}"
    }
}

public class TextNode: ASTNode {

    public let content: String

    init(content: String) {
        self.content = content
    }

    @objc override public var description: String {
        String(describing: type(of: self)) + "(\"\(content)\")"
    }
}

public class CursiveNode: TextNode {}

public class BoldNode: TextNode {}

public class CursiveBoldNode: TextNode {}

public class CodeNode: TextNode {}
