import CoolDownParser
import Foundation

public struct CDMarkdownParserCache {

    let cache = NSCache<NSString, NSArray>()

    func get(for text: String) -> [ASTNode]? {
        guard let array = cache.object(forKey: text as NSString) else {
            return nil
        }
        return array as? [ASTNode]
    }

    func set(_ nodes: [ASTNode], forText text: String) {
        cache.setObject(nodes as NSArray, forKey: text as NSString)
    }
}

// MARK: - Shared Cache

extension CDMarkdownParserCache {

    public static let shared = CDMarkdownParserCache()

}
