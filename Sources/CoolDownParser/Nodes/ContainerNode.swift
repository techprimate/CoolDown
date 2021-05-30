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

    override public func hash(into hasher: inout Hasher) {
        nodes.hash(into: &hasher)
    }
}
