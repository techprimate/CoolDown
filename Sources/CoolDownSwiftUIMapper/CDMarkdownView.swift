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
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: .leading, spacing: 10) {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
            let transformed = CDSwiftUIMapper.transform(nodes: nodes)
            return try mapper.resolve(nodes: transformed)
        } catch {
            return AnyView(Text(error.localizedDescription))
        }
    }

    // MARK: - Configuration

    public func useCache(cache: CDMarkdownParserCache = .shared) -> some View {
        self.environment(\.markdownParserCache, cache)
    }
}

