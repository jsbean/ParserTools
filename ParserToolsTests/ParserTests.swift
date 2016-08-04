//
//  ParserTests.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

import XCTest
@testable import ParserTools

class ParserTests: XCTestCase {

    private func testParser<A>(parser: Parser<Character, A>, _ input: String) -> String {
        return parser.parse(ArraySlice(input.characters)).reduce([]) { accum, cur in
            accum + ["Found: \(cur.0), remainder: \(Array(cur.1))"]
        }.joinWithSeparator("\n")
    }
    
    // Maybe return AnySequence<Token>
    private func tokens(from source: String) throws -> [Token] {
        let tokenizer = Tokenizer(source: source)
        return try tokenizer.tokenize()
    }
}
