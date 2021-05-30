public class LinkNode: ContainerNode {

    let uri: String
    let title: String?

    init(uri: String, title: String?, nodes: [ASTNode]) {
        self.uri = uri
        self.title = title
        super.init(nodes: nodes)
    }
}
