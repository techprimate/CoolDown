import SwiftUI
import CoolDownParser
import Kingfisher

struct CDImageView: View {

    let node: ImageNode

    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                KFImage(URL(string: node.uri))
                    .resizable()
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("CDImageView is only available in iOS 14+")
            }
            if let title = node.title {
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct CDImageView_Previews: PreviewProvider {
    static var previews: some View {
        CDImageView(node: .image(uri: "https://via.placeholder.com/100",
                                 title: "Title",
                                 nodes: [
                                    .text("This is a caption with "),
                                    .bold("some bold text")
                                 ]))
    }
}
