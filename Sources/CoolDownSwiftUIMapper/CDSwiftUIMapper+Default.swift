import CoolDownParser
import SwiftUI
import Kingfisher

extension CDSwiftUIMapper {

    public static var `default`: CDSwiftUIMapper = {
        let mapper = CDSwiftUIMapper()
        mapper.addResolver(for: HeaderNode.self) { mapper, node in
            ForEach(node.nodes, id: \.self) { node in
                mapper.resolve(node: node)
            }
            .font({
                switch node.depth {
                case 1:
                    return Font.system(size: 22, weight: .semibold)
                default:
                    return Font.system(size: 18)
                }
            }())
        }
        mapper.addResolver(for: TextNode.self) { _, node in
            Text(node.content) // node has type TextNode
                .fixedSize(horizontal: false, vertical: true)
        }
        mapper.addResolver(for: BoldNode.self) { _, node  in
            Text(node.content)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
        }
        mapper.addResolver(for: CursiveNode.self) { _, node  in
            Text(node.content)
                .italic()
                .fixedSize(horizontal: false, vertical: true)
        }
        mapper.addResolver(for: CursiveBoldNode.self) { _, node  in
            Text(node.content)
                .italic()
                .bold()
                .fixedSize(horizontal: false, vertical: true)
        }
        mapper.addResolver(for: ListNode.self) { mapper, node  in
            VStack(alignment: .leading) {
                ForEach(node.nodes, id: \.self) { node in
                    mapper.resolve(node: node)
                }
            }
        }
        mapper.addResolver(for: BulletNode.self, resolver: { mapper, node in
            HStack(alignment: .top) {
                Text("·")
                VStack(alignment: .leading) {
                    ForEach(node.nodes, id: \.self) { node in
                        mapper.resolve(node: node)
                    }
                }
            }
        })
        mapper.addResolver(for: ParagraphNode.self, resolver: resolveParagraphNode)
        mapper.addResolver(for: TextNode.self) { _, node in
            HStack(spacing: 0) {
                Text(node.content)
                Spacer()
            }
        }
        mapper.addResolver(for: CodeBlockNode.self) { _, node in
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    ForEach(node.nodes, id: \.self) { node in
                        mapper.resolve(node: node)
                    }
                }
            }
            .padding(10)
            .background(Color(white: 0.85))
            .cornerRadius(10)
        }
        mapper.addResolver(for: CodeNode.self) { _, node in
            Text(node.content)
                .padding(2)
                .background(Color(white: 0.85))
        }
        mapper.addResolver(for: TextNodesBox.self) { _, node in
            node.nodes.compactMap { node -> Text? in
                if let boldNode = node as? BoldNode {
                    return Text(boldNode.content).bold()
                } else if let cursiveNode = node as? CursiveNode {
                    return Text(cursiveNode.content).italic()
                } else if let boldCursiveNode = node as? CursiveBoldNode {
                    return Text(boldCursiveNode.content).bold().italic()
                } else if let codeNode = node as? CodeNode {
                    return Text(codeNode.content).foregroundColor(Color.gray)
                } else if let textNode = node as? TextNode {
                    return Text(textNode.content)
                }
                return nil
            }.reduce(Text(""), +)
        }
        mapper.addResolver(for: QuoteNode.self) { mapper, node in
            HStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 5)
                VStack(alignment: .leading) {
                    ForEach(node.nodes, id: \.self) { node in
                        mapper.resolve(node: node)
                    }
                }
            }
        }
        mapper.addResolver(for: NumberedNode.self) { mapper, node in
            HStack(alignment: .top) {
                Text("\(node.index).")
                VStack(alignment: .leading) {
                    ForEach(node.nodes, id: \.self) { node in
                        mapper.resolve(node: node)
                    }
                }
            }
        }
        mapper.addResolver(for: LinkNode.self) { mapper, node in
            Button(action: {}) {
                ForEach(node.nodes, id: \.self) { node in
                    mapper.resolve(node: node)
                }
            }
        }
        mapper.addResolver(for: ImageNode.self) { mapper, node in
            VStack {
                KFImage(URL(string: node.uri))
                    .resizable()
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fit)
                if let title = node.title {
                    Text(title)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
        }
        return mapper
    }()

    @ViewBuilder
    static func resolveParagraphNode(mapper: CDSwiftUIMapper, node: ParagraphNode) -> some View {
        ForEach(node.nodes, id: \.self) { node in
            HStack(spacing: 0) {
                mapper.resolve(node: node)
                Spacer()
            }
        }
    }

    static func transform(nodes: [ASTNode]) -> [ASTNode] {
        var transformedNodes: [ASTNode] = []
        for node in nodes {
            if let textNode = node as? TextNode {
                if let prev = transformedNodes.last as? TextNodesBox {
                    transformedNodes[transformedNodes.count - 1] = TextNodesBox(nodes: prev.nodes + [textNode])
                } else {
                    transformedNodes.append(TextNodesBox(nodes: [textNode]))
                }
            } else if let container = node as? ContainerNode {
                container.nodes = transform(nodes: container.nodes)
                transformedNodes.append(container)
            } else {
                transformedNodes.append(node)
            }
        }
        return transformedNodes
    }
}

struct CDSwiftUIMapperDefault_PreviewProvider: PreviewProvider {

    static let text = """
    Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

    This article will show you these 3 ways of styling a `SwiftUI.View`:

    1. Initializer-based configuration
    2. Method chaining using return-self
    3. Styles in the Environment
    """

    static var previews: some View {
        ScrollView {
            CDMarkdownView(text: text, mapper: .default)
                .useCache()
                .padding()
        }
    }
}
