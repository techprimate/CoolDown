import SwiftUI
import CoolDownParser

struct CDListView: View {

    let index: CDIndexNode
    let node: ListNode

    var body: some View {
        VStack(alignment: .leading) {
            CDNodesResolverView(parentIndex: index, nodes: node.nodes)
        }
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        CDListView(index: .root, node: .list(nodes: [
            .bullet(nodes: [
                .text("Bullet Item")
            ]),
            .numbered(index: 1, nodes: [
                .text("Numbered Item")
            ])
        ]))
    }
}
