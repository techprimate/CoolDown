import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDListBulletItemView: View {

    let index: CDIndexNode
    let node: BulletNode

    var body: some View {
        HStack(alignment: .top) {
            Text("·")
                .foregroundColor(Color.label)
            VStack(alignment: .leading) {
                CDNodesResolverView(parentIndex: index, nodes: node.nodes)
            }
        }
    }
}

struct CDListBulletItemView_Previews: PreviewProvider {
    static var previews: some View {
        CDListBulletItemView(index: .root, node: .init(nodes: [
            .text("Simple Bullet Item")
        ]))
    }
}
