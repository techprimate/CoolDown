public class HeaderNode: ContainerNode {

    public let depth: Int

    init(depth: Int, nodes: [ASTNode]) {
        self.depth = depth
        super.init(nodes: nodes)
    }

    override public var description: String {
        String(describing: type(of: self)) + "(\(depth)) {\n"
            + nodes.map(\.description).joined(separator: "\n")
            + "\n}"
    }

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        depth.hash(into: &hasher)
    }
}
