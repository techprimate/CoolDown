//
//  NodeMapper.swift
//  CoolDownUIMapper
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import SwiftUI

@available(iOS 13.0, *)
class NodeMapper {

    static func map<Node: ASTNode, Result>(node: Node, resolvers: [String: Resolver<Node, Result>]) throws -> Result {
        guard let resolver = resolvers[String(describing: type(of: node))] else {
            throw CDSwiftUIMapperError.missingResolver(node: node)
        }
        return resolver(node)
    }
}
