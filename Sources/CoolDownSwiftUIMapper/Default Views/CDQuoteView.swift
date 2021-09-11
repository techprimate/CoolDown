//
//  CDQuoteView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
import CoolDownParser

struct CDQuoteView: View {

    let node: QuoteNode

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
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
