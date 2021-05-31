public class LinkNode: ContainerNode {

    public let uri: String
    public let title: String?

    public init(uri: String, title: String?, nodes: [ASTNode]) {
        self.uri = uri
        self.title = title
        super.init(nodes: nodes)
    }

    // MARK: - Custom String Convertible

    override public var description: String {
        let className = String(describing: type(of: self))
        let params = "(uri: " + uri + ", title: " + (title ?? "nil") + ")"
        let content = " {\n"
            + nodes.map(\.description).joined(separator: "\n")
        + "\n}"
        return className + params + content
    }

    // MARK: - Hashable

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(uri)
        hasher.combine(title)
    }

    // MARK: - Equatable

    public override func equals(other: AnyObject) -> Bool {
        guard super.equals(other: other) else { return false }
        guard let other = other as? Self else { return false }
        return self.uri == other.uri && self.title == other.title
    }
}
