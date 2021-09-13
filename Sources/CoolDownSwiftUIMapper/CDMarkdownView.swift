import CoolDownParser
import SwiftUI
import RainbowSwiftUI

public struct CDMarkdownView<Content: View>: View {

    @Environment(\.cooldownParserCache) var cache

    let text: String
    let content: ([IndexASTNode]) -> Content

    public init(text: String, @ViewBuilder content: @escaping ([IndexASTNode]) -> Content) {
        self.text = text
        self.content = content
    }

    public var body: some View {
        if #available(iOS 14.0, macOS 11.0, *) {
            LazyVStack(alignment: .leading, spacing: 10) {
                content(transformedNodes)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.systemBackground)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                content(transformedNodes)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.systemBackground)
        }
    }

    var transformedNodes: [IndexASTNode] {
        let nodes: [ASTNode]
        if let cache = cache, let cachedNodes = cache.get(for: text) {
            nodes = cachedNodes
        } else {
            let parser = CDParser(text)
            cache?.set(parser.nodes, forText: text)
            nodes = parser.nodes
        }
        return CDSwiftUIMapper.transform(nodes: nodes).enumerated().map { index, node in
            IndexASTNode(index: .leaf(index), node: node)
        }
    }

    // MARK: - Configuration

    public func useCache(cache: CDMarkdownParserCache = .shared) -> some View {
        self.environment(\.cooldownParserCache, cache)
    }
}
