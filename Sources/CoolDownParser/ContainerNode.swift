public class ContainerNode: ASTNode {

    public internal(set) var nodes: [ASTNode]

    internal init(nodes: [ASTNode]) {
        self.nodes = nodes
    }

    // MARK: - Custom String Convertible

    public override var description: String {
        return String(describing: type(of: self)) + " {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        nodes.hash(into: &hasher)
    }
}
