public class NumberedNode: ContainerNode {

    public let index: Int

    init(index: Int, nodes: [ASTNode]) {
        self.index = index
        super.init(nodes: nodes)
    }

    // MARK: - CustomStringConvertible

    override public var description: String {
        String(describing: type(of: self)) + "(\(index)) {\n"
            + nodes.map(\.description).joined(separator: ", \n")
            + "\n}"
    }

    // MARK: - Hashable

    override public func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        index.hash(into: &hasher)
    }

    // MARK: - Equatable

    public override func equals(other: AnyObject) -> Bool {
        guard super.equals(other: other) else { return false }
        guard let other = other as? Self else { return false }
        return self.index == other.index
    }
}
