//
//  ElementsAtIndices.swift
//  ArrayTools
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension Array {

    // MARK: - Elements At Indices
    
    /**
    - parameter index: Index of desired `Element`.

    - returns: `Element` at index if present. Otherwise `nil`.
    */
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    /// Second `Element` in an `Array`
    public var second: Element? {
        guard count > 1 else { return nil }
        return self[1] as Element
    }
    
    /// Second-to-last `Element` in `Array`
    public var penultimate: Element? {
        guard count > 1 else { return nil }
        return self[self.count - 2] as Element
    }
    
    public func last(amount amount: Int) -> [Element]? {
        guard count >= amount else { return nil }
        return Array(self[(self.count - amount)..<self.count])
    }
}