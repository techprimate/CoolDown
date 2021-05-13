import Foundation

/// Used to parse a string-based Markdown document into a strongly typed tree structure
public class CoolDown {

    /// List of parsed nodes, representing the abstract syntax tree of a Markdown document
    public private(set) var nodes: [ASTNode] = []

    /// Parses the given text and sets the resulting nodes in the instance property `nodes`
    ///
    /// - Parameter text: String to parse
    public init(_ text: String) {
        // A Markdown document needs to split into blocks with empty lines as the separator
        guard let lexer = Lexer(raw: text, separatedBy: "\n\n") else {
            return
        }
        // Iterate each block
        while let block = lexer.next() {
            let parser = BlockParser(block: block)
            // Parse each block individually
            parser.parse()
            // Append result to node list
            nodes += parser.nodes
        }
    }

    /// Read contents of file at the `url` and parses it
    ///
    /// - Parameters:
    ///   - url: URL of the file to read
    ///   - encoding: Data encoding of the file content
    /// - Throws: if the file could not be read
    public convenience init(url: URL, encoding: String.Encoding = .utf8) throws {
        self.init(try String(contentsOf: url, encoding: encoding))
    }
}
