import SwiftUI
import CoolDownParser

struct CDLinkView: View {

    @Environment(\.cooldownLinkAction) var action

    let index: CDIndexNode
    let node: LinkNode

    var body: some View {
        Button(action: didTapLinkAction) {
            CDNodesResolverView(parentIndex: index, nodes: node.nodes)
        }
    }

    private func didTapLinkAction() {
        guard let action = action else {
            return
        }
        action(node)
    }
}

struct CDLinkView_Previews: PreviewProvider {
    static var previews: some View {
        CDLinkView(index: .root,
                   node: .init(
                    uri: "https://example.org",
                    title: "Example Link",
                    nodes: [
                        .bold("This"),
                        .text("is"),
                        .cursive("some content")
                    ]))
    }
}
