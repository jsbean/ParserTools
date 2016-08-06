//
//  Token.swift
//  ParserTools
//
//  Created by James Bean on 8/3/16.
//
//

/**
 Token.
 */
public struct Token {
    
    // MARK: - Instance Properties
    
    /// `TokenKind` of `Token`.
    public let kind: TokenKind
    
    /// `SourcePosition` of `Token`.
    public let sourcePosition: SourcePosition
    
    /// `true` if token models whitespace. Otherwise, `false`.
    public var isWhitespace: Bool {
        switch kind {
        case .tab, .space: return true
        default: return false
        }
    }
    
    // MARK: - Initializers
    
    /**
     Create a `Token` value without a source context:
     
     ```
     let token = Token(.identifier("ID1"))
     ```
     
     Create a `Token` value with context within a source file:
     
     ```
     let token = Token(.float(1.2345, "1.2345"), range: 0...5, line: 0, columnRange: 0...5)
     ```
     */
    public init(_ kind: TokenKind, sourcePosition: SourcePosition = SourcePosition()) {
        self.kind = kind
        self.sourcePosition = sourcePosition
    }
}

extension Token: CustomStringConvertible {
    
    public var description: String {
        return "\(kind)"
    }
}

extension Token: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(kind); \(sourcePosition.debugDescription)"
    }
}
