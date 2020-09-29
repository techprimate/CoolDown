//
//  NodeMapper.swift
//  CoolDownUIMapper
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import CoolDownParser

public enum CDUIMapperError: Error {
    case missingResolver(node: ASTNode)
}
