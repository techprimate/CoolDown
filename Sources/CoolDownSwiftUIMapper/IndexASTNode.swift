import Foundation
import CoolDownParser

public struct IndexASTNode: Hashable, Identifiable {

    public let index: CDIndexNode
    public let node: ASTNode

    public var id: String {
        index.id.map(\.description).joined(separator: "-") + "|" + node.description
    }
}
