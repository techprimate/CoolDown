/// Parses a single text block into an abstract syntax tree
///
/// A block is parsed by first spliting it into lines, which are called *Fragments*.
/// These fragments are then iterated and parsed sequentially, using a `FragmentParser`.
internal class BlockParser {

    /// Text block to parse
    private let block: String

    /// Tree-like structure of parsed nodes
    internal var nodes: [ASTNode] = []

    /// Creates a new parser for the given block
    ///
    /// - Parameter block: Text blockt to be parsed
    internal init(block: String) {
        self.block = block
    }

    /// Parses the given text block into the nodes array
    ///
    /// - Parameter block: Text to parse
    internal func parse() {
        // Split block into fragments using the newline-character as the separator
        guard let lexer = Lexer(raw: block, separator: "\n") else {
            // if the lexer is nil, no lexems were found
            return
        }
        // Iterate each lexem
        while let fragment = lexer.next() {
            // Create a parser for each lexem individually
            let parser = FragmentParser(fragment: fragment)
            // Parse the fragment into the result.
            // It needs a reference to previous nodes, as the parser also performs flattening
            // (e.g. a sequence of lists are merged into a single one)
            parser.parse(into: &nodes)
        }
    }
}
