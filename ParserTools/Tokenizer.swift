//
//  Tokenizer.swift
//  ParserTools
//
//  Created by James Bean on 8/3/16.
//
//

import Foundation

/**
 Creates `Token` values from a source file.
 
 - note: Consider using the parser combinator for this tokenizing phase.
 - warning: This is currently quite unoptimized, and is running slow.
 */
public final class Tokenizer {
    
    // MARK: - Error
    
    /**
     Things that can go wrong while tokenizing.
     */
    public enum Error: ErrorType {
        
        /// Unknown item found in source file.
        case unknownItem
    }
    
    private let tokenKindByCharacter: [String: TokenKind] = [
        " ": .space,
        "\t": .tab,
        "    ": .tab,
        "\n": .newline,
        "//": .lineComment,
        "/*": .multilineCommentStart,
        "*/": .multilineCommentEnd,
        "(": .openParenthesis,
        ")": .closeParenthesis,
        "[": .openBracket,
        "]": .closeBracket,
        "{": .openBrace,
        "}": .closeBrace
    ]
    
    // MARK: - Character sets
    
    private static let letterCharacterSet: NSCharacterSet = .letterCharacterSet()
    
    private static let alphanumericCharacterSet: NSCharacterSet = .alphanumericCharacterSet()
    
    private static let symbolCharacterSet: NSCharacterSet =
        NSCharacterSet(charactersInString: "()[]{}<>.,:;-!@#$%^&*~")
    
    private static let whitespaceAndNewlineCharacterSet: NSCharacterSet =
        .whitespaceAndNewlineCharacterSet()
    
    private lazy var tokenMatching: [() -> TokenKind?] = {
        [
            self.matchTerminal,
            self.matchIdentifier,
            self.matchSymbol,
            self.matchInt,
            self.matchFloat,
            ]
    }()
    
    // MARK: - Scanning apparatus
    
    private var resultString: NSString?
    private let scanner: NSScanner
    
    // MARK: - Source position
    
    private var columnStart: Int = 0
    private var line: Int = 0
    
    // MARK: - Source
    
    private let source: String
    
    // MARK: - Initializers
    
    /**
     Create a `Tokenizer` with a source string.
     */
    public init(source: String) {
        self.source = source
        self.scanner = NSScanner(string: source)
        scanner.charactersToBeSkipped = nil
    }
    
    /**
     Make an array of `Token` values.
     
     - TODO: indentation
     */
    public func tokenize() throws -> [Token] {
        var tokens: [Token] = []
        prepareScanner()
        while !scanner.atEnd {
            let startIndex = scanner.scanLocation
            if let kind = makeTokenKind() {
                let endIndex = scanner.scanLocation
                let range = startIndex ..< endIndex
                let token = Token(kind, sourcePosition: sourcePosition(from: range))
                tokens.append(token)
                if case .newline = kind { configureSourcePositionForNewLine() }
            } else {
                throw Error.unknownItem
            }
        }
        return tokens
    }
    
    private func prepareScanner() {
        scanner.scanLocation = 0
    }
    
    private func sourcePosition(from range: Range<Int>) -> SourcePosition {
        return SourcePosition(range: range, line: line, columns: columns(from: range))
    }
    
    private func columns(from sourceRange: Range<Int>) -> Range<Int> {
        return (sourceRange.startIndex - columnStart) ..< (sourceRange.endIndex - columnStart)
    }
    
    private func configureSourcePositionForNewLine() {
        resetColumnStart()
        incrementLine()
    }
    
    // MARK: - Token matching
    
    private func makeTokenKind() -> TokenKind? {
        for matchToken in tokenMatching {
            if let tokenKind = matchToken() {
                return tokenKind
            }
        }
        return nil
    }
    
    private func matchTerminal() -> TokenKind? {
        for (character, kind) in tokenKindByCharacter {
            if scan(character) {
                return kind
            }
        }
        return nil
    }
    
    // FIXME: grammar should be: identifier = letter, { letter | digit } ;
    private func matchIdentifier() -> TokenKind? {
        if let identifier = charactersScanned(from: Tokenizer.letterCharacterSet) {
            return .identifier(identifier)
        }
        return nil
    }
    
    private func matchSymbol() -> TokenKind? {
        if let characters = charactersScanned(from: Tokenizer.symbolCharacterSet) {
            return .symbol(characters)
        }
        return nil
    }
    
    private func matchInt() -> TokenKind? {
        let startLocation = scanner.scanLocation
        var intValue: Int32 = 0
        if scanner.scanInt(&intValue) {
            
            // ensure this isn't actually a float!
            guard !lookahead(for: ".") || scanner.atEnd else {
                
                // unwind
                scanner.scanLocation = startLocation
                return nil
            }
            
            return .int(Int(intValue))
        }
        return nil
    }
    
    private func matchFloat() -> TokenKind? {
        let startIndex = scanner.scanLocation
        var floatValue: Float = 0
        if scanner.scanFloat(&floatValue) {
            let endIndex = scanner.scanLocation - 1
            let original = originalFloatRepresentation(in: startIndex..<endIndex)
            return .float(value: floatValue, original: original)
        }
        return nil
    }
    
    // captures the original string representation for floating point number for code gen
    private func originalFloatRepresentation(in range: Range<Int>) -> String {
        let start = scanner.string.startIndex.advancedBy(range.startIndex)
        let end = scanner.string.startIndex.advancedBy(range.endIndex)
        return String(scanner.string.characters[start...end])
    }
    
    private func charactersScanned(from characterSet: NSCharacterSet) -> String? {
        if scan(characterSet) {
            return resultString as? String
        }
        return nil
    }
    
    private func scan(string: String) -> Bool {
        return scanner.scanString(string, intoString: &resultString)
    }
    
    private func scan(characterSet: NSCharacterSet) -> Bool {
        return scanner.scanCharactersFromSet(characterSet, intoString: &resultString)
    }
    
    private func lookahead(for character: String) -> Bool {
        let startLocation = scanner.scanLocation
        if scan(character) {
            scanner.scanLocation = startLocation
            return true
        }
        return false
    }
    
    // MARK: - Source position
    
    private func incrementLine() {
        line += 1
    }
    
    private func resetColumnStart() {
        columnStart = scanner.scanLocation
    }
}
