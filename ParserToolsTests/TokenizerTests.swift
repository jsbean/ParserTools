//
//  TokenizerTests.swift
//  ParserTools
//
//  Created by James Bean on 8/3/16.
//
//

import XCTest
@testable import ParserTools

class TokenizerTests: XCTestCase {
    
    func testInit() {
        let _ = Tokenizer(source: "")
    }
    
    func testMakeIdentifierTokenSingleLetterSucceeds() throws {
        let tokenizer = Tokenizer(source: "a")
        XCTAssertEqual(try tokenizer.tokenize().count, 1)
    }
    
    func testMakeIdentifierMultipleLettersSucceeds() throws {
        let tokenizer = Tokenizer(source: "abcd")
        do {
            let tokens = try tokenizer.tokenize()
            let firstToken = tokens.first!
            
            switch firstToken.kind {
            case .identifier(let value):
                XCTAssertEqual(value, "abcd")
                XCTAssertEqual(firstToken.sourcePosition.range, 0...3)
            default: XCTFail()
            }
        }
    }
    
    func testMakeIdentifierTokenSingleLetterMultipleSucceeds() throws {
        let tokenizer = Tokenizer(source: "a b c d e f")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 11)
        
        let expected: [(String, Range<Int>)?] = [
            ("a", 0...0),
            nil,
            ("b", 2...2),
            nil,
            ("c", 4...4),
            nil,
            ("d", 6...6),
            nil,
            ("e", 8...8),
            nil,
            ("f", 10...10)
        ]
        
        for (t, token) in tokens.enumerate() {
            switch token.kind {
            case .space: continue
            case .identifier(let value):
                XCTAssertEqual(value, expected[t]?.0)
                XCTAssertEqual(token.sourcePosition.range, expected[t]?.1)
            default: XCTFail()
            }
        }
    }
    
    func testMakeIdentifierTokenNumberTailSucceeds() throws {
        let tokenizer = Tokenizer(source: "abc1")
        try tokenizer.tokenize()
    }
    
    func testMakeSpaceToken() throws {
        let tokenizer = Tokenizer(source: " ")
        XCTAssertEqual(try tokenizer.tokenize().count, 1)
    }
    
    func testMakeWhitespaceTokens() throws {
        let tokenizer = Tokenizer(source: " \t\n\t ")
        let tokens = try tokenizer.tokenize()
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, 5)
    }
    
    func testMakeTabToken() throws {
        let tokenizer = Tokenizer(source: "\t")
        XCTAssertEqual(try tokenizer.tokenize().count, 1)
    }
    
    func testMakeTabAndSpaceTokens() throws {
        let tokenizer = Tokenizer(source: "\t ")
        XCTAssertEqual(try tokenizer.tokenize().count, 2)
    }
    
    func testMatchFloat() {
        let tokenizer = Tokenizer(source: "12.34")
        guard let firstToken = try! tokenizer.tokenize().first else { XCTFail(); return }
        switch firstToken.kind {
        case .float(let number, let original):
            XCTAssertEqual(number, 12.34)
            XCTAssertEqual(original, "12.34")
            XCTAssertEqual(firstToken.sourcePosition.range, 0...4)
        default: XCTFail()
        }
    }
    
    func testMatchFloatSucceedsAtEndOfLine() throws {
        let tokenizer = Tokenizer(source: "12.34\np")
        try tokenizer.tokenize()
    }
    
    func testMatchFloatSucceedsWhitespace() throws {
        let tokenizer = Tokenizer(source: "12.34\t \t\np")
        let tokens = try tokenizer.tokenize()
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, 6)
    }
    
    func testSingleLineComment() throws {
        let tokenizer = Tokenizer(source: "//")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testMultilineCommentStart() throws {
        let tokenizer = Tokenizer(source: "/*")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testMultilineCommentStop() throws {
        let tokenizer = Tokenizer(source: "*/")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testScanMultipleFloatsrange() throws {
        let source = "1.25 4.56 7.89 0.1234"
        let tokenizer = Tokenizer(source: source)
        let tokens = try tokenizer.tokenize()
        let expectedValues: [(Float, String, Range<Int>)?] = [
            (1.25, "1.25", 0...3),
            nil,
            (4.56, "4.56", 5...8),
            nil,
            (7.89, "7.89", 10...13),
            nil,
            (0.1234, "0.1234", 15...20)
        ]
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, 7)
        
        for (t, token) in tokens.enumerate() {
            switch token.kind {
            case .space: continue
            case .float(let value, let original):
                XCTAssertEqual(value, expectedValues[t]?.0)
                XCTAssertEqual(original, expectedValues[t]?.1)
                XCTAssertEqual(token.sourcePosition.range, expectedValues[t]?.2)
            default: XCTFail()
            }
        }
    }
    
    func testMatchSymbolToken() throws {
        let tokenizer = Tokenizer(source: "$#")
        XCTAssertEqual(try tokenizer.tokenize().count, 1)
    }
    
    func testSmallExample() throws {
        let source = "a bcd efg 1.24\n\t\t$ -> ~> <> [ d fff ** 0.2"
        let tokenizer = Tokenizer(source: source)
        let tokens = try tokenizer.tokenize()
        tokens.forEach { print($0) }
    }
    
    func testOpenParenthesis() throws {
        let tokenizer = Tokenizer(source: "(")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testCloseParenthesis() throws {
        let tokenizer = Tokenizer(source: ")")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testOpenBracket() throws {
        let tokenizer = Tokenizer(source: "[")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testCloseBracket() throws {
        let tokenizer = Tokenizer(source: "]")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testOpenBrace() throws {
        let tokenizer = Tokenizer(source: "{")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testCloseBrace() throws {
        let tokenizer = Tokenizer(source: "}")
        let tokens = try tokenizer.tokenize()
        XCTAssertEqual(tokens.count, 1)
    }
    
    func testInt() throws {
        let tokenizer = Tokenizer(source: "1")
        let tokens = try tokenizer.tokenize()
        guard let firstToken = tokens.first else { XCTFail(); return }
        switch firstToken.kind {
        case .int(let value):
            XCTAssertEqual(value, 1)
        default: XCTFail()
        }
    }
    
    func testLine() throws {
        let tokenizer = Tokenizer(source: "\n1")
        let tokens = try tokenizer.tokenize()
        let token_1 = tokens[1]
        XCTAssertEqual(token_1.sourcePosition.range, 1...1)
        XCTAssertEqual(token_1.sourcePosition.line, 1)
        XCTAssertEqual(token_1.sourcePosition.columns, 0...0)
    }
    
    func testColumnRange() throws {
        let tokenizer = Tokenizer(source: "123\nabc")
        let tokens = try tokenizer.tokenize()
        let token_123 = tokens[0]
        let token_abc = tokens[2]
        XCTAssertEqual(token_123.sourcePosition.line, 0)
        XCTAssertEqual(token_123.sourcePosition.columns, 0...2)
        
        XCTAssertEqual(token_abc.sourcePosition.line, 1)
        XCTAssertEqual(token_abc.sourcePosition.columns, 0...2)
    }
    
    func testTokenCustomDebugStringConvertible() throws {
        let source = "abc 123\n\t12.123 123 abc ~> <> ok"
        let tokens = try Tokenizer(source: source).tokenize()
        tokens.forEach { debugPrint($0) }
    }
    
    //    func testPerformanceManySimpleIdentifiers() throws {
    //        let string = (0..<10000).map { _ in "a" }.joinWithSeparator(" ")
    //        let tokenizer = Tokenizer(source: string)
    //        self.measureBlock {
    //            let _ = try! tokenizer.tokenize()
    //        }
    //    }
}
