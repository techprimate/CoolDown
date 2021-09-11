//
//  CDHeaderView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
import CoolDownParser

struct CDHeaderView: View {

    let index: CDIndexNode
    let node: HeaderNode

    var body: some View {
        CDNodesResolverView(parentIndex: index, nodes: node.nodes)
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
}

struct CDHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(1..<8) { depth in
                CDHeaderView(index: .leaf(depth), node: .header(depth: depth, nodes: [
                    .text("Header")
                ]))
            }
        }
    }
}
