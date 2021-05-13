//
//  Lexer.swift
//  CoolDownParserTests
//
//  Created by Philip Niedertscheider on 25.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

import Foundation

/// A Lexer is used to iterate the so/called lexems, tokens in a string, basically an iterator.
class Lexer<Lexem>: IteratorProtocol {

    /// Lexems to iterate
    private let lexems: [Lexem]

    /// Current iterator position
    private var index = 0

    /// Creates a new Lexer for iterating the given lexems.
    /// - Parameter lexems: Tokens to iterate
    private init(lexems: [Lexem]) {
        assert(!lexems.isEmpty, "Lexer should have at least one value")
        self.lexems = lexems
    }

    /// Returns the currently selected lexem, does not modify the cursor position.
    var token: Lexem {
        lexems[index]
    }

    /// Returns the currently selected lexem and moves the cursor to the nex position.
    func next() -> Lexem? {
        guard !isAtEnd else {
            return nil
        }
        let token = lexems[index]
        index += 1
        return token
    }

    /// Returns truthy value if the end is reached, therefore all elements were iterated.
    var isAtEnd: Bool {
        index >= lexems.count
    }
}

extension Lexer where Lexem == String {

    /// Creates a new Lexer by tokenizing the given expression string.
    ///
    /// If the given expression is empty, or contains only empty characters (such as spaces),
    /// `nil` is returned, indicating no further parsing is necessary
    ///
    /// - Parameter expression: Expression used to tokenize and lex
    convenience init?(raw expression: String, separatedBy separator: String) {
        let lexems = expression.components(separatedBy: separator)
        guard !lexems.isEmpty else {
            return nil
        }
        self.init(lexems: lexems)
    }
}

extension Lexer where Lexem == Substring {

    /// Creates a new Lexer by tokenizing the given expression string.
    ///
    /// If the given expression is empty, or contains only empty characters (such as spaces),
    /// `nil` is returned, indicating no further parsing is necessary
    ///
    /// - Parameter expression: Expression used to tokenize and lex
    convenience init?(raw expression: String, separator: Character) {
        let lexems = expression.split(separator: separator)
        guard !lexems.isEmpty else {
            return nil
        }
        self.init(lexems: lexems)
    }
}
