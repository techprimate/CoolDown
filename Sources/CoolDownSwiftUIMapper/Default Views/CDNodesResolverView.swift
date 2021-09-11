//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
import CoolDownParser

struct CDNodesResolverView: View {

    let indexNodes: [IndexASTNode]

    init(parentIndex index: CDIndexNode, nodes: [ASTNode]) {
        self.indexNodes = CDSwiftUIMapper.transformToIndex(parentIndex: index, nodes: nodes)
    }

    init(nodes: [IndexASTNode]) {
        self.indexNodes = nodes
    }

    var body: some View {
        ForEach(indexNodes) { node in
            CDNodeResolverView(node: node)
        }
    }
}
