//
//  ASTNode.swift
//  CDASTParser
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

public enum ASTNode: Equatable {

    case header(nodes: [ASTNode])
    case paragraph(nodes: [ASTNode])
    case text(_ content: String)
    case bold(_ content: String)

    public static func == (lhs: ASTNode, rhs: ASTNode) -> Bool {
        switch (lhs, rhs) {
        case let (.header(lhsNodes), .header(rhsNodes)),
             let (.paragraph(lhsNodes), .paragraph(rhsNodes)):
            return lhsNodes == rhsNodes
        case let (.text(lhsContent), .text(rhsContent)),
             let (.bold(lhsContent), .bold(rhsContent)):
            return lhsContent == rhsContent
        default:
            return false
        }
    }
}
