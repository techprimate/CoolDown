//
//  NodeMapper.swift
//  CoolDownUIMapper
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser
import Foundation

public enum CDSwiftUIMapperError: LocalizedError {

    case missingResolver(node: ASTNode)

    public var errorDescription: String? {
        switch self {
        case .missingResolver(let node):
            return "Missing resolve for node: " + node.description
        }
    }
}
