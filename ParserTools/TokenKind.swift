//
//  TokenKind.swift
//  ParserTools
//
//  Created by James Bean on 8/3/16.
//
//

/**
 Enumeration of possible kinds of `Token` values.
 */
public enum TokenKind {
    
    /**
     Float token.
     
     > `original` is the original string representation of the float value in the source file.
     */
    case float(value: Float, original: String)
    
    /**
     Integer token.
     */
    case int(Int)
    
    /**
     Identifier token.
     */
    case identifier(String)
    
    /**
     Symbol token.
     
     - TODO: Add allowed / disallowed symbols.
     */
    case symbol(String)
    
    /**
     Newline token.
     
     > Created with `"\n"` character.
     */
    case newline
    
    /**
     Tab token.
     
     > Created with `"\t"` character.
     */
    case tab
    
    /**
     Space token.
     */
    case space
    
    // TODO: make these symbols
    
    /**
     Line comment token.
     
     > Created with the `"//"` characters.
     */
    case lineComment
    
    /**
     Multiline comment start token.
     
     > Created with the `"/ *"` characters.
     */
    case multilineCommentStart
    
    /**
     Multiline comment end token.
     
     > Created with the `"* /"` characters.
     */
    case multilineCommentEnd
    
    /**
     Open parenthesis token.
     
     > Created with the `"("` character.
     */
    case openParenthesis
    
    /**
     Close parenthesis token.
     
     > Created with the `")"` character.
     */
    case closeParenthesis
    
    /**
     Open bracket token.
     
     > Created with the `"["` character.
     */
    case openBracket
    
    /**
     Close bracket token.
     
     > Created with the `"]"` character.
     */
    case closeBracket
    
    /**
     Open brace token.
     
     > Created with the `"{"` character.
     */
    case openBrace
    
    /**
     Close brace token.
     
     > Created with the `"}"` character.
     */
    case closeBrace
}

extension TokenKind: Equatable { }

/**
 - returns: `true` if `TokenKind` values are equal. Otherwise, `nil`.
 */
public func == (lhs: TokenKind, rhs: TokenKind) -> Bool {
    switch (lhs, rhs) {
    case (.newline, .newline),
         (.tab, .tab),
         (.space, .space),
         (.multilineCommentStart, .multilineCommentStart),
         (.multilineCommentEnd, .multilineCommentEnd),
         (.openParenthesis, .openParenthesis),
         (.closeParenthesis, .closeParenthesis),
         (.openBracket, .openBracket),
         (.closeBracket, .closeBracket),
         (.openBrace, .openBrace),
         (.closeBrace, .closeBrace): return true
    case let (.float(_, lhs), .float(_, rhs)): return lhs == rhs
    case let (.int(lhs), .int(rhs)): return lhs == rhs
    case let (.identifier(lhs), .identifier(rhs)): return lhs == rhs
    case let (.symbol(lhs), .symbol(rhs)): return lhs == rhs
    default: return false
    }
}
