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

// TODO: CLEAN UP
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
    
    func testSequence() throws {
        let x: Character = "x"
        let y: Character = "y"
        let z: Character = "z"
        let p2 = sequence(sequence(token(x), token(y)), token(z))
        print(testParser(p2, "xyz"))
    }
    
    // temporary
    func sequence3<Token, A, B, C>(
        p1: Parser<Token, A>,
        _ p2: Parser<Token, B>,
        _ p3: Parser<Token, C>
    ) -> Parser<Token, (A, B, C)>
    {
        return Parser { input in
            let p1Results = p1.parse(input)
            return flatMap(p1Results) { a, p1Rest in
                let p2Results = p2.parse(p1Rest)
                return flatMap(p2Results) { b, p2Rest in
                    let p3Results = p3.parse(p2Rest)
                    return map(p3Results, { c, p3Rest in
                        ((a,b,c), p3Rest)
                    })
                }
            }
        }
    }
    
    func testSequence3() throws {
        let x: Character = "x"
        let y: Character = "y"
        let z: Character = "z"
        let s = sequence3(token(x), token(y), token(z))
        print(testParser(s, "xyz"))
    }
    
    func integerParser<Token>() -> Parser<Token, Character -> Int> {
        return Parser { input in
            return one(({ x in Int(String(x))! }, input))
        }
    }
    
    func integerParser2() -> Parser<Token, Token -> Int> {
        return Parser { input in
            return one(
                (
                    { token in
                        if case let .int(value) = token.kind { return value }
                        fatalError()
                    },
                    input
                )
            )
        }
    }
    
    func testIntegerParser2() throws {
        let stream = try tokens(from: "123.25")
        let parser = integerParser2() <*> satisfy { (token: Token) in
            if case .int = token.kind { return true }
            return false
        }
    }
    
    func testCombinator() throws {
        let three: Character = "3"
        print(testParser(combinator(integerParser(), token(three)), "3"))
    }
    
    func toInteger(c: Character) -> Int {
        return Int(String(c))!
    }
    
    func testPure() {
        let three: Character = "3"
        print(
            testParser(
                combinator(
                    pure(toInteger),
                    token(three)
                ),
                "3"
            )
        )
    }
    
    func toInteger2(c1: Character) -> (Character) -> Int {
        return { c2 in
            return Int(String(c1) + String(c2))!
        }
    }
    
    func testToInteger2() {
        let three: Character = "3"
        print(
            testParser(
                combinator(
                    combinator(
                        pure(toInteger2),
                        token(three)
                    ),
                    token(three)
                ),
                "33"
            )
        )
    }
    
    func testCombinatorOperator() {
        let three: Character = "3"
        print(
            testParser(
                pure(toInteger2) <*> token(three) <*> token(three),
                "33"
            )
        )
    }
    
    func combine(a: Character) -> (Character) -> (Character) -> String {
        return { b in
            return { c in
                return String([a,b,c])
            }
        }
    }
    
    func testCombine() {
        let a: Character = "a"
        let b: Character = "b"
        let aOrB = token(a) <|> token(b)
        let parser = pure(combine) <*> aOrB <*> aOrB <*> token(b)
        print(testParser(parser, "abb"))
    }
    
    func testCurry() {
        let a: Character = "a"
        let b: Character = "b"
        let aOrB = token(a) <|> token(b)
        let parser = pure(curry { String([$0, $1, $2]) }) <*> aOrB <*> aOrB <*> token(b)
        print(testParser(parser, "abb"))
    }
    
    struct SyntaxNode {
        let value: String
    }
    
    let id: Parser<Token, Token -> SyntaxNode> = pure { (token: Token) in
        if case let .identifier(value) = token.kind {
            return SyntaxNode(value: value)
        }
        fatalError()
    }
    
    let identifier: Parser<Token, Token> = satisfy { (token: Token) in
        if case .identifier = token.kind { return true }
        return false
    }

    let whitespace: Parser<Token, Token> = satisfy { (token: Token) in token.isWhitespace }
    let openParen = satisfy { (token: Token) in token.kind == .openParenthesis }
    let closeParen = satisfy { (token: Token) in token.kind == .closeParenthesis }
    
    func symbol(string: String) -> Parser<Token, Token> {
        return satisfy { (token: Token) in
            guard case let .symbol(value) = token.kind else { return false }
            return string == value
        }
    }
    
    func testPureToken() throws {
        let stream = try tokens(from: "abc def ghi")
        let parser: Parser<Token, [SyntaxNode]> = oneOrMore (id <*> (identifier <* whitespace))
        print(testParser(parser, stream))
    }
    
    func testBetweenParens() throws {
        let stream = try tokens(from: "(a)")
        let parser = id <*> (openParen *> identifier <* closeParen)
        print(testParser(parser, stream))
    }
    
    func testIdentifierDeclaration() throws {
        let stream = try tokens(from: ": abc")
        let parser = id <*> (symbol(":") *> whitespace *> identifier)
        print(testParser(parser, stream))
    }
    
    func testMetricalDuration() throws {
        
        let stream = try tokens(from: "1,8")
        let integer = satisfy { (token: Token) in
            if case .int = token.kind { return true }
            return false
        }
        
        let parser = integer
        print(testParser(parser, stream))
    }
    
    func testAddParsers() throws {
        let stream = ArraySlice(try tokens(from: "abc 12.3"))
        let p1 = satisfy { (token: Token) in token.kind == .identifier("abc") }
        let p2 = satisfy { (token: Token) in
            if case .float = token.kind { return true }
            return false
        }
        let _ = p1.parse(stream) + p2.parse(stream)
    }

    // Maybe return AnySequence<Token>
    private func tokens(from source: String) throws -> [Token] {
        let tokenizer = Tokenizer(source: source)
        return try tokenizer.tokenize()
    }
}
