import CoolDownParser
import SwiftUI

@available(iOS 13.0, *)
public struct CDMarkdownView: View {

    @Environment(\.markdownParserCache) var cache

    let text: String
    let mapper: CDSwiftUIMapper

    public init(text: String, mapper: CDSwiftUIMapper) {
        self.text = text
        self.mapper = mapper
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var content: some View {
        do {
            let nodes: [ASTNode]
            if let cache = cache, let cachedNodes = cache.get(for: text) {
                nodes = cachedNodes
            } else {
                let parser = CDParser(text)
                cache?.set(parser.nodes, forText: text)
                nodes = parser.nodes
            }
            return try mapper.resolve(nodes: nodes)
        } catch {
            return AnyView(Text(error.localizedDescription))
        }
    }

    // MARK: - Configuration

    public func useCache(cache: CDMarkdownParserCache = .shared) -> some View {
        self.environment(\.markdownParserCache, cache)
    }
}
