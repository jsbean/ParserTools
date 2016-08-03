//
//  ListProcessing.swift
//  ArrayTools
//
//  Created by James Bean on 2/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension ArraySlice {
    
    /// First `Element` of a list.
    public var head: Element? {
        return self.first
    }
    
    /// Remaining `Elements` of a list.
    public var tail: ArraySlice<Element>? {
        if self.isEmpty { return nil }
        return self[(self.startIndex + 1) ..< self.endIndex]
    }
    
    /**
     2-tuple containing the `head` and `tail`.
     
     -  note: From Chris Eidhof: http://chris.eidhof.nl/posts/swift-tricks.html
     */
    public var destructured: (Element, ArraySlice<Element>)? {
        guard let head = head, tail = tail else { return nil }
        return (head, tail)
    }
}

extension Array {
    
    // MARK: - List Processing
    
    /// First `Element` of a list.
    public var head: Element? {
        return self.first
    }
    
    /// Remaining `Elements` of a list.
    public var tail: Array<Element>? {
        if self.isEmpty { return nil }
        return Array(self[1..<self.count])
    }
    
    /**
     2-tuple containing the `head` `Element` and `tail` `[Element]` of `Self`
     
     -  note: From Chris Eidhof: http://chris.eidhof.nl/posts/swift-tricks.html
     */
    public var destructured: (Element, Array<Element>)? {
        guard let head = head, tail = tail else { return nil }
        return (head, tail)
    }
}

/**
- returns: New `Array` with the first element `head`, and the remaining elements of `tail`.
*/
public func + <T>(head: T, tail: [T]) -> [T] {
    return [head] + tail
}

/**
- returns: New `Array` with `item` appended to the end of `list`.
*/
public func + <T>(list: [T], item: T) -> [T] {
    return list + [item]
}