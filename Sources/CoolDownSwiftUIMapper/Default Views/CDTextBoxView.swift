import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDTextBoxView: View {

    let node: TextNodesBox

    var body: some View {
        node.nodes.compactMap { node -> Text? in
            if let boldNode = node as? BoldNode {
                return Text(boldNode.content).bold()
            } else if let cursiveNode = node as? CursiveNode {
                return Text(cursiveNode.content).italic()
            } else if let boldCursiveNode = node as? CursiveBoldNode {
                return Text(boldCursiveNode.content).bold().italic()
            } else if let codeNode = node as? CodeNode {
                return Text(codeNode.content).foregroundColor(Color.gray)
            } else if let textNode = node as? TextNode {
                return Text(textNode.content)
            }
            return nil
        }.reduce(Text(""), +)
        .foregroundColor(Color.label)
    }
}

struct CDTextBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CDTextBoxView(node: TextNodesBox(nodes: [
            .text("Some plain text and "),
            .bold("some bold text and "),
            .cursive("some cursive text and "),
            .cursiveBold("some with both, coded as "),
            .code("inline code")
        ]))
    }
}
