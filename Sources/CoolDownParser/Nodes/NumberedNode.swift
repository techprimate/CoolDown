public class NumberedNode: ContainerNode {

    public let index: Int

    init(index: Int, nodes: [ASTNode]) {
        self.index = index
        super.init(nodes: nodes)
    }

    override public var description: String {
        String(describing: type(of: self)) + "(\(index)) {\n"
            + nodes.map(\.description).joined(separator: ", \n")
            + "\n}"
    }

    override public func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        index.hash(into: &hasher)
    }
}
