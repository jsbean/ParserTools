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
     let token = Token(.openBrace, range: 0...4, line: 0, columnRange: 0...4)
     ```
     
     - TODO: Inject `SourcePosition`, replacing `range`, `line`, `columnRange`.
     */
    public init(_ kind: TokenKind, sourcePosition: SourcePosition = SourcePosition()) {
        self.kind = kind
        self.sourcePosition = sourcePosition
    }
}
