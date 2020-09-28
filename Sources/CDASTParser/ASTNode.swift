//
//  ASTNode.swift
//  CDASTParser
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

public enum ASTNode: Equatable {

    case header(depth: Int, nodes: [ASTNode])
    case paragraph(nodes: [ASTNode])
    case list(nodes: [ASTNode])
    case bullet(nodes: [ASTNode])
    case numbered(index: Int, nodes: [ASTNode])
    case quote(nodes: [ASTNode])
    case codeBlock(nodes: [ASTNode])

    case bold(_ content: String)
    case cursive(_ content: String)
    case cursiveBold(_ content: String)

    case code(_ content: String)
    case text(_ content: String)

    //case link(_ content: String) or case link(content: String, target: String)
    //case image(_ content: String) or case image(content: String, source: String)
    //custom cases e.g Map Element

    public static func == (lhs: ASTNode, rhs: ASTNode) -> Bool {
        switch (lhs, rhs) {
        case let (.header(lhsInt, lhsNodes), .header(rhsInt, rhsNodes)),
             let (.numbered(lhsInt, lhsNodes), .numbered(rhsInt, rhsNodes)):
            return lhsInt == rhsInt && lhsNodes == rhsNodes
        case let (.paragraph(lhsNodes), .paragraph(rhsNodes)),
             let (.bullet(lhsNodes), .bullet(rhsNodes)),
             let (.list(lhsNodes), .list(rhsNodes)),
             let (.quote(lhsNodes), .quote(rhsNodes)),
             let (.codeBlock(lhsNodes), .codeBlock(rhsNodes)):
            return lhsNodes == rhsNodes
        case let (.text(lhsContent), .text(rhsContent)),
             let (.code(lhsContent), .code(rhsContent)),
            let (.bold(lhsContent), .bold(rhsContent)),
            let (.cursive(lhsContent), .cursive(rhsContent)),
            let (.cursiveBold(lhsContent), .cursiveBold(rhsContent)):
            return lhsContent == rhsContent
        default:
            return false
        }
    }
}
