public class HeaderNode: ContainerNode {

    public let depth: Int

    init(depth: Int, nodes: [ASTNode]) {
        self.depth = depth
        super.init(nodes: nodes)
    }

    // MARK: - CustomStringConvertible

    override public var description: String {
        String(describing: type(of: self)) + "(\(depth)) {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }

    // MARK: - Hashable

    override public func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        depth.hash(into: &hasher)
    }

    // MARK: - Equatable

    public override func equals(other: AnyObject) -> Bool {
        guard super.equals(other: other) else { return false }
        guard let other = other as? Self else { return false }
        return self.depth == other.depth
    }
}
