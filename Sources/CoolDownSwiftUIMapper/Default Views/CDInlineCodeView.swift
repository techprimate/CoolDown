import SwiftUI
import CoolDownParser
import RainbowSwiftUI

struct CDInlineCodeView: View {

    let node: CodeNode

    var body: some View {
        Text(node.content)
            .foregroundColor(Color.label)
            .padding(2)
            .background(Color(white: 0.85))
    }
}

struct CDInlineCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CDInlineCodeView(node: .code("int main() { return 0; }"))
    }
}
