import SwiftUI
import CoolDownParser

struct CDParagraphView: View {

    let index: CDIndexNode
    let node: ParagraphNode

    var body: some View {
        ForEach(indexNodes) { node in
            HStack(spacing: 0) {
                CDNodeResolverView(node: node)
                Spacer()
            }
        }
    }

    var indexNodes: [IndexASTNode] {
        CDSwiftUIMapper.transformToIndex(parentIndex: index, nodes: node.nodes)
    }
}

struct CDParagraphView_Previews: PreviewProvider {
    static var previews: some View {
        CDParagraphView(index: .root, node: .paragraph(nodes: [
            .text("Segment 1"),
            .text("Segment 2"),
            .text("Segment 3")
        ]))
    }
}
