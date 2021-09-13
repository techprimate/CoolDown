//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 10.09.21.
//

import SwiftUI
import CoolDownParser
import RainbowSwiftUI

public struct CDMarkdownDefaultView: View {

    public let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        CDMarkdownView(text: text) { nodes in
            CDNodesResolverView(nodes: nodes)
        }
    }
}

struct CDMarkdownDefaultView_Previews: PreviewProvider {

    static let text = """
    Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

    This article will show you these 3 ways of styling a `SwiftUI.View`:

    1. Initializer-based configuration
    2. Method chaining using return-self
    3. Styles in the Environment
    """

    static var previews: some View {
        Group {
            preview
                .colorScheme(.light)
            preview
                .colorScheme(.dark)
        }
    }

    static var preview: some View {
        ScrollView {
            CDMarkdownDefaultView(text: text)
        }
        .background(Color.systemBackground)
    }
}
