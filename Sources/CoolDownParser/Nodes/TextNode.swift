public class TextNode: ASTNode {

    public let content: String

    init(content: String) {
        self.content = content
    }

    override public var description: String {
        String(describing: type(of: self)) + "(\"\(content)\")"
    }

    override public func hash(into hasher: inout Hasher) {
        content.hash(into: &hasher)
    }
}
