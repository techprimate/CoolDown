import SwiftUI

struct MarkdownParserCacheKey: EnvironmentKey {

    public static var defaultValue: CDMarkdownParserCache? = nil

}

@available(iOS 13.0, *)
extension EnvironmentValues {

    var markdownParserCache: CDMarkdownParserCache? {
        get { self[MarkdownParserCacheKey.self] }
        set { self[MarkdownParserCacheKey.self] = newValue }
    }
}

