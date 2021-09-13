import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDNodeResolverView: View {

    let node: IndexASTNode

    var body: some View {
        content
            .id(node.id)
    }

    @ViewBuilder
    var content: some View {
        switch node.node {
        // Simple Nodes
        case let node as TextNode:
            resolveText(node: node)
        case let node as BoldNode:
            resolveBold(node: node)
        case let node as CursiveNode:
            resolveCursive(node: node)
        case let node as CursiveBoldNode:
            resolveCursiveBold(node: node)
        // List Nodes
        case let node as ListNode:
            CDListView(index: self.node.index, node: node)
        case let node as BulletNode:
            CDListBulletItemView(index: self.node.index, node: node)
        case let node as NumberedNode:
            CDListNumberedItemView(index: self.node.index, node: node)
        // Container Nodes
        case let node as ParagraphNode:
            CDParagraphView(index: self.node.index, node: node)
        case let node as HeaderNode:
            CDHeaderView(index: self.node.index, node: node)
        case let node as TextNodesBox:
            CDTextBoxView(node: node)
        case let node as CodeBlockNode:
            CDCodeBlockView(index: self.node.index, node: node)
        case let node as CodeNode:
            CDInlineCodeView(node: node)
        case let node as QuoteNode:
            CDQuoteView(node: node)
        case let node as LinkNode:
            CDLinkView(index: self.node.index, node: node)
        case let node as ImageNode:
            CDImageView(node: node)
        default:
            Text("Missing resolver for node at position \(node.index): " + node.node.description)
        }
    }

    private func resolveText(node: TextNode) -> some View {
        Text(node.content)
            .foregroundColor(Color.label)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveBold(node: BoldNode) -> some View {
        Text(node.content)
            .foregroundColor(Color.label)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursive(node: CursiveNode) -> some View {
        Text(node.content)
            .foregroundColor(Color.label)
            .italic()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursiveBold(node: CursiveBoldNode) -> some View {
        Text(node.content)
            .foregroundColor(Color.label)
            .italic()
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }
}

//struct CDNodeResolverView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDNodeResolverView()
//    }
//}
