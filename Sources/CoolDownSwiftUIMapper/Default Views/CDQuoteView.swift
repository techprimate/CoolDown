import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDQuoteView: View {

    let node: QuoteNode

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.label)
                .frame(width: 5)
            VStack(alignment: .leading) {
                CDNodesResolverView(parentIndex: .root, nodes: node.nodes)
            }
        }
    }
}

struct CDQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        CDQuoteView(node: .quote(nodes: [
            .text("A very inspirational quote")
        ]))
    }
}
