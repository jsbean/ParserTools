//
//  ParserTests.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

import XCTest
import ArrayTools
@testable import ParserTools

class ParserTests: XCTestCase {

    private func testParser<A>(parser: Parser<Character, A>, _ input: String) -> String {
        return parser.parse(ArraySlice(input.characters)).reduce([]) { accum, cur in
            accum + ["Found: \(cur.0), remainder: \(Array(cur.1))"]
        }.joinWithSeparator("\n")
    }
    
    private func testParser<Token, Result>(parser: Parser<Token, Result>, _ input: [Token])
        -> String
    {
        return parser.parse(ArraySlice(input)).reduce([]) { accum, cur in
            accum + ["Found: \(cur.0), remainder: \(Array(cur.1))"]
        }.joinWithSeparator("\n")
    }
    
    func testParseA() {
        let a: Character = "a"
        print("result: \(testParser(token(a), "a"))")
    }
    
    func testSatisfy() {
        let a: Character = "a"
        print("result: \(testParser(satisfy { $0 == a }, "a"))")
    }
    
    func testTokenKind() {
        let tokenKinds: [TokenKind] = [.identifier("ID")]
        let tokenKind: TokenKind = .identifier("ID")
        let parser = satisfy { $0 == tokenKind }
        print(testParser(parser, tokenKinds))
    }
    
    func testToken() {
        let tokens: [Token] = [Token(.identifier("ID"))]
        let tokenKind = TokenKind.identifier("ID")
        let parser = satisfy { (token: Token) in token.kind == tokenKind }
        print(testParser(parser, tokens))
    }
    
    func tokenKind(tokenKind: TokenKind) -> Parser<Token, Token> {
        return satisfy { (token: Token) in token.kind == tokenKind }
    }
    
    // unwrapIdentifier, unwrapInt, unwrapFloat, etc. => Token -> SyntaxNode
    
    func int(token: Token) -> Int? {
        switch token.kind {
        case .int(let value): return value
        default: return nil
        }
    }
    
    func identifier(token: Token) -> String? {
        guard case let .identifier(value) = token.kind else { return nil }
        return value
    }
    
    func float(token: Token) -> Float? {
        guard case let .float(value, _) = token.kind else { return nil }
        return value
    }
    
    func testIntFromTokenNil() {
        let token = Token(.identifier(""))
        XCTAssertNil(int(token))
    }
    
    func testIntFromTokenNotNil() {
        let token = Token(.int(42))
        XCTAssertEqual(int(token), 42)
    }
    
    func testOneOrMore() {
        let tokens: [Token] = [
            Token(.identifier("ID")),
            Token(.identifier("ID")),
            Token(.identifier("ID")),
            Token(.identifier("ID")),
            Token(.identifier("ID")),
            Token(.identifier("ID"))
        ]
        let tokenKind = TokenKind.identifier("ID")
        let satisfaction = satisfy { (token: Token) in token.kind == tokenKind }
        let parser = oneOrMore(satisfaction)
        print(testParser(parser, tokens))
    }
    
    func testTokens() {
        let tokens: [Token] = [Token(.identifier("ID")), Token(.space), Token(.int(42))]
        let possibleTokenKind1 = tokenKind(.identifier("ID"))
        let possibleTokenKind2 = tokenKind(.int(21))
        let parser = possibleTokenKind1 <|> possibleTokenKind2
        print(testParser(parser, tokens))
    }
    
    func testZeroOrMoreEmptySucceeds() {
        let tokens: [Token] = []
        
    }
    
    // Maybe return AnySequence<Token>
    private func tokens(from source: String) throws -> [Token] {
        let tokenizer = Tokenizer(source: source)
        return try tokenizer.tokenize()
    }
}
