//
//  NodeMapper.swift
//  CoolDownUIMapper
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser

class NodeMapper {

    static func map(node: ASTNode, resolvers: [String: Resolver]) throws -> View {
        guard let resolver = resolvers[String(describing: type(of: node))] else {
            throw CDUIMapperError.missingResolver(node: node)
        }
        return resolver(node)
    }
}
