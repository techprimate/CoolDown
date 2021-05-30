open class ContainerNode: ASTNode {

    public var nodes: [ASTNode]

    public init(nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Custom String Convertible

    override public var description: String {
        String(describing: type(of: self)) + " {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }

    // MARK: - Hashable

    public override func hash(into hasher: inout Hasher) {
        nodes.hash(into: &hasher)
    }

    // MARK: - Equatable

    public override func equals(other: AnyObject) -> Bool {
        guard super.equals(other: other) else { return false }
        guard let other = other as? Self else { return false }
        return self.nodes == other.nodes
    }
}
