//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
import CoolDownParser

struct CDLinkView: View {

    let index: CDIndexNode
    let node: LinkNode

    var body: some View {
        Button(action: {}) {
            CDNodesResolverView(parentIndex: index, nodes: node.nodes)
        }
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
