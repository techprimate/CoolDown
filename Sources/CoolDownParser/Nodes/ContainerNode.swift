public class ContainerNode: ASTNode {

    public internal(set) var nodes: [ASTNode]

    internal init(nodes: [ASTNode]) {
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
