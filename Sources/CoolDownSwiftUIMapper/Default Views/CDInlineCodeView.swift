//
//  CDInlineCodeView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
import CoolDownParser

struct CDInlineCodeView: View {

    let node: CodeNode

    var body: some View {
        Text(node.content)
            .foregroundColor(Color.black)
            .padding(2)
            .background(Color(white: 0.85))
    }
}

struct CDInlineCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CDInlineCodeView(node: .code("int main() { return 0; }"))
    }
}
