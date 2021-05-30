public class TextNode: ASTNode {

    public let content: String

    init(content: String) {
        self.content = content
    }

    // MARK: - CustomStringConvertible

    override public var description: String {
        String(describing: type(of: self)) + "(\"\(content)\")"
    }

    // MARK: - Hashable

    override public func hash(into hasher: inout Hasher) {
        content.hash(into: &hasher)
    }

    // MARK: - Equatable

    public override func equals(other: AnyObject) -> Bool {
        guard super.equals(other: other) else { return false }
        guard let other = other as? Self else { return false }
        return self.content == other.content
    }
}
