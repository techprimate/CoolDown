//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 10.09.21.
//

import SwiftUI
import CoolDownParser
import Kingfisher

public struct CDMarkdownDefaultView: View {

    public let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        CDMarkdownView(text: text, content: resolve(indexNodes:))
    }

    private func resolve(nodes: [ASTNode]) -> some View {
        resolve(indexNodes: CDSwiftUIMapper.transformToIndex(nodes: nodes))
    }

    private func resolve(indexNodes: [IndexASTNode]) -> some View {
        ForEach(indexNodes, content: resolve(node:))
    }

    @ViewBuilder
    private func resolve(node: IndexASTNode) -> some View {
        switch node.node {
        case let node as ParagraphNode:
            resolveParagraph(node: node)
        case let node as HeaderNode:
            resolveHeader(node: node)
        case let node as TextNode:
            resolveText(node: node)
        case let node as BoldNode:
            resolveBold(node: node)
        case let node as CursiveNode:
            resolveCursive(node: node)
        case let node as CursiveBoldNode:
            resolveCursiveBold(node: node)
        case let node as ListNode:
            resolveList(node: node)
        case let node as BulletNode:
            resolveBullet(node: node)
        default:
            resolve2(node: node)
        }
    }

    @ViewBuilder
    private func resolve2(node: IndexASTNode) -> some View {
        switch node.node {
        case let node as CodeBlockNode:
            resolveCodeBlock(node: node)
        case let node as CodeNode:
            resolveCode(node: node)
        case let node as TextNodesBox:
            resolveTextBox(node: node)
        case let node as QuoteNode:
            resolveQuote(node: node)
        case let node as NumberedNode:
            resolveNumbered(node: node)
        case let node as LinkNode:
            resolveLink(node: node)
        case let node as ImageNode:
            resolveImage(node: node)
        default:
            Text("Missing resolver for node at position \(node.index): " + node.node.description)
        }
    }

    private func resolveParagraph(node: ParagraphNode) -> some View {
        ForEach(CDSwiftUIMapper.transformToIndex(nodes: node.nodes)) { node in
            HStack(spacing: 0) {
                resolve(node: node)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func resolveHeader(node: HeaderNode) -> some View {
        resolve(nodes: node.nodes)
            .font({
                switch node.depth {
                case 1:
                    return Font.system(size: 32, weight: .semibold)
                case 2:
                    return Font.system(size: 24, weight: .semibold)
                case 3:
                    return Font.system(size: 20, weight: .semibold)
                case 4:
                    return Font.system(size: 16, weight: .semibold)
                case 5:
                    return Font.system(size: 14, weight: .semibold)
                case 6:
                    return Font.system(size: 13.6, weight: .semibold)
                default:
                    return Font.system(size: 13.6)
                }
            }())
    }

    private func resolveText(node: TextNode) -> some View {
        Text(node.content)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveBold(node: BoldNode) -> some View {
        Text(node.content)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursive(node: CursiveNode) -> some View {
        Text(node.content)
            .italic()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursiveBold(node: CursiveBoldNode) -> some View {
        Text(node.content)
            .italic()
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveList(node: ListNode) -> some View {
        VStack(alignment: .leading) {
            resolve(nodes: node.nodes)
        }
    }

    private func resolveBullet(node: BulletNode) -> some View {
        HStack(alignment: .top) {
            Text("·")
            VStack(alignment: .leading) {
                resolve(nodes: node.nodes)
            }
        }
    }

    private func resolveCodeBlock(node: CodeBlockNode) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                resolve(nodes: node.nodes)
            }
        }
        .padding(10)
        .background(Color(white: 0.85))
        .cornerRadius(10)
    }

    private func resolveCode(node: CodeNode) -> some View {
        Text(node.content)
            .padding(2)
            .background(Color(white: 0.85))
    }

    private func resolveTextBox(node: TextNodesBox) -> some View {
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

    private func resolveQuote(node: QuoteNode) -> some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 5)
            VStack(alignment: .leading) {
                resolve(nodes: node.nodes)
            }
        }
    }

    private func resolveNumbered(node: NumberedNode) -> some View {
        HStack(alignment: .top) {
            Text("\(node.index).")
            VStack(alignment: .leading) {
                resolve(nodes: node.nodes)
            }
        }
    }

    private func resolveLink(node: LinkNode) -> some View {
        Button(action: {}) {
            resolve(nodes: node.nodes)
        }
    }

    private func resolveImage(node: ImageNode) -> some View {
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

}

struct CDMarkdownDefaultView_Previews: PreviewProvider {

    static let text = """
    Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

    This article will show you these 3 ways of styling a `SwiftUI.View`:

    1. Initializer-based configuration
    2. Method chaining using return-self
    3. Styles in the Environment
    """

    static var previews: some View {
        ScrollView {
            CDMarkdownDefaultView(text: text)
                .padding()
        }
    }
}
