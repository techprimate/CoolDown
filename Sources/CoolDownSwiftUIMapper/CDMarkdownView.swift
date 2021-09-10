import CoolDownParser
import SwiftUI

@available(iOS 13.0, *)
public struct CDMarkdownView<Content: View>: View {

    @Environment(\.markdownParserCache) var cache

    let text: String
    let content: ([IndexASTNode]) -> Content

    public init(text: String, @ViewBuilder content: @escaping ([IndexASTNode]) -> Content) {
        self.text = text
        self.content = content
    }

    public var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: .leading, spacing: 10) {
                content(transformedNodes)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                content(transformedNodes)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            IndexASTNode(index: index, node: node)
        }
    }

    // MARK: - Configuration

    public func useCache(cache: CDMarkdownParserCache = .shared) -> some View {
        self.environment(\.markdownParserCache, cache)
    }
}

public struct IndexASTNode: Hashable, Identifiable {

    public let index: Int
    public let node: ASTNode

    public var id: String {
        index.description + "-" + node.description
    }
}
