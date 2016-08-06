//
//  SourcePosition.swift
//  ParserTools
//
//  Created by James Bean on 8/3/16.
//
//

/**
 Position of `Token` in source file.
 */
public struct SourcePosition {
    
    // MARK: - Instance properties
    
    /**
     Range of characters in source file.
     
     - note: 0-indexed.
     */
    public let range: Range<Int>
    
    /**
     Line of characters in source file.
     
     - note: 0-indexed.
     */
    public let line: Int
    
    /**
     Range of columns in source file.
     
     - note: 0-indexed.
     */
    public let columns: Range<Int>
    
    // MARK: - Initializers
    
    /**
     Create a `SourcePosition` value.
     */
    public init(range: Range<Int> = 0...0, line: Int = 0, columns: Range<Int> = 0...0) {
        self.range = range
        self.line = line
        self.columns = columns
    }
}

extension SourcePosition: CustomStringConvertible {
    
    public var description: String {
        return "\(range)"
    }
}

extension SourcePosition: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "range: \(range); line: \(line); columns: \(columns)"
    }
}