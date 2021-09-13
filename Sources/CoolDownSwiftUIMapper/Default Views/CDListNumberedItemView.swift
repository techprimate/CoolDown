import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDListNumberedItemView: View {

    let index: CDIndexNode
    let node: NumberedNode

    var body: some View {
        HStack(alignment: .top) {
            Text("\(node.index).")
                .foregroundColor(Color.label)
            VStack(alignment: .leading) {
                CDNodesResolverView(parentIndex: index, nodes: node.nodes)
            }
        }
    }
}

struct CDListNumberedItemView_Previews: PreviewProvider {
    static var previews: some View {
        CDListNumberedItemView(index: .root, node: .numbered(index: 1, nodes: [
            .text("My First Item")
        ]))
    }
}
