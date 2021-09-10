import SwiftUI

struct MarkdownParserCacheKey: EnvironmentKey {

    public static var defaultValue: CDMarkdownParserCache?

}

@available(iOS 13.0, *)
extension EnvironmentValues {

    public var markdownParserCache: CDMarkdownParserCache? {
        get { self[MarkdownParserCacheKey.self] }
        set { self[MarkdownParserCacheKey.self] = newValue }
    }
}
