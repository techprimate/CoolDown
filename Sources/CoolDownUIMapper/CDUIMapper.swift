//
//  CDAttributedString.swift
//  CDAtributedString
//
//  Created by Philip Niedertscheider on 28.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CDASTParser
#if canImport(UIKit)
import UIKit

public typealias View = UIView

#elseif canImport(AppKit)
import AppKit

public typealias View = NSView
#endif

public typealias Resolver = (ASTNode) -> View

public enum CDUIMapperError: Error {
    case missingResolver(node: ASTNode)
}

public class CDUIMapper {

    // MARK: - Properties

    private let nodes: [ASTNode]
    private var resolvers: [String: Resolver] = [:]

    // MARK: - Initializer

    public init(from nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Accessors

    func resolve() throws -> [UIView] {
        try nodes.map { node in
            try NodeMapper.map(node: node, resolvers: resolvers)
        }
    }

    // MARK: - Modifiers

    func addResolver(for nodeType: String, resolver: @escaping Resolver) {
        resolvers[nodeType] = resolver
    }
}

class NodeMapper {

    static func map(node: ASTNode, resolvers: [String: Resolver]) throws -> View {
        let resolver: Resolver?
        switch node {
        case .text:
            resolver = resolvers["text"]
        default:
            resolver = nil
        }
        guard let res = resolver else {
            throw CDUIMapperError.missingResolver(node: node)
        }
        return res(node)
    }
}
