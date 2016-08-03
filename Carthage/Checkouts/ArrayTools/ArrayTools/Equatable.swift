//
//  Equatable.swift
//  ArrayTools
//
//  Created by James Bean on 2/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // MARK: - Element: Equatable
    
    /// `true` if all `Elements` are logically equivalent. Otherwise `false`.
    public var isHomogeneous: Bool { return filter({ $0 == first }).count == self.count }
    
    /**
     `true` if there are two or more `Elemments`, and they are not all logically equivalent.
     Otherwise `false`.
    */
    public var isHeterogeneous: Bool { return self.count < 2 ? false : !isHomogeneous }
    
    /**
     `[1,2,2,2,3,4,2].amountOf(2) -> 4`
     
     `[1,2,3,4].amountOf(5) -> 0`
     
    - returns: Amount of given `Element` in `Array`.
    */
    public func amount(of element: Element) -> Int {
        
        func amount(of element: Element, in array: [Element], accum: Int) -> Int {
            var accum = accum
            guard let (head, tail) = array.destructured else { return accum }
            if head == element { accum += 1 }
            return amount(of: element, in: tail, accum: accum)
        }
        
        return amount(of: element, in: self, accum: 0)
    }
    
    /**
    Extract all instances of `Element` in `Array`.
     
    >`[1,2,2,2,3,4].extractAllOf(2) -> ([2,2,2], [1,3,4])`

    - returns: 2-tuple of extracted elements, and leftovers
    */
    public func extractAll(element: Element) -> ([Element], [Element]) {

        func remove(element: Element,
            fromArray array: [Element],
            leftovers: [Element],
            extracted: [Element]
        ) -> ([Element], [Element])
        {
            guard let (head, tail) = array.destructured else { return (extracted, leftovers) }
            let (l,e) = head == element
                ? (leftovers, extracted + head)
                : (leftovers + head, extracted)
            return remove(element, fromArray: tail, leftovers: l, extracted: e)
        }
        
        return remove(element, fromArray: self, leftovers: [], extracted: [])
    }
    
    /**
    Sort the contents of `Array` with the order of contents in another `Array`.
     
    >`["a","b","c","d].sort(withOrderOfContentsIn: ["b","c","d"]) -> ["b","c","d","a"]`

    - returns: `Array` of `Elements` sorted with the desired order.
    */
    public func sort(withOrderOfContentsIn array: [Element]) -> [Element] {
        
        func appendMatchesOf(element: Element,
            from array: [Element],
            to result: [Element]
        ) -> ([Element],[Element])
        {
            let (leftovers, matches) = array.extractAll(element)
            return (result + matches, leftovers)
        }
        
        func sort(array: [Element],
            withOrderOfContentsIn reference: [Element],
            into result: [Element]
        ) -> [Element]
        {
            guard let (head, tail) = reference.destructured else { return result + array }
            let (sorted, source) = appendMatchesOf(head, from: array, to: result)
            return sort(source, withOrderOfContentsIn: tail, into: sorted)
        }
        
        return sort(self, withOrderOfContentsIn: array, into: [])
    }
    
    /**
    >`[1,2,2,2,3,4,4].extractDuplicates() -> ([2,2,4],[1,2,3,4])`

    - returns: 2-tuple of (`extracted`, `leftovers`).
    */
    public func extractDuplicates() -> ([Element], [Element]) {
        
        func extractDuplicates(from array: [Element],
            duplicates: [Element],
            leftovers: [Element]
        ) -> ([Element], [Element])
        {
            guard let (head, tail) = array.destructured else { return (duplicates, leftovers) }
            let (d,l) = leftovers.contains(head)
                ? (duplicates + head, leftovers)
                : (duplicates, leftovers + head)
            return extractDuplicates(from: tail, duplicates: d, leftovers: l)
        }
        
        return extractDuplicates(from: self, duplicates: [], leftovers: [])
    }
    
    /**
     `Array` of `Elements` containing only single instances of any `Element`.
     
     >`[1,2,2,3,4,4].unique -> [1,2,3,4]`
     */
    public var unique: [Element] {
        
        func extractUniqueValues(from array: [Element], to result: [Element]) -> [Element] {
            guard let (head, tail) = array.destructured else { return result }
            let result = result.contains(head) ? result : result + head
            return extractUniqueValues(from: tail, to: result)
        }
        
        return extractUniqueValues(from: self, to: [])
    }
    
    /**
    Get index of `Element` in `Array`.
     
    >`["c","a","t","s"].indexOf("t") -> 2`
     
    >`["c","a","t","s"].indexOf("k") -> nil`

    - returns: Index of first instance of value, if present. Otherwise, `nil`.
    */
    public func index(of value: Element) -> Int? {
        for (index, el) in self.enumerate() { if el == value { return index } }
        return nil
    }
    
    /**
     Replace `element` with `newElement`.
     
     >`["a","c","g","t"].replace("g", withElement: "b") -> ["a","c","b","t"]`
     
     - throws: `ArrayError.RemovalError` if given element not in `Array`.
     */
    public mutating func replace(element: Element, with newElement: Element) throws {
        guard let index = indexOf(element) else { throw ArrayError.RemovalError }
        removeAtIndex(index)
        insert(element, atIndex: index)
    }
}

/**
 - returns: `true` if all elements in both sequnces are equivalent. Otherwise, `false`.
 */
public func == <T: SequenceType where T.Generator.Element: Equatable>(lhs: T, rhs: T) -> Bool {
    for pair in zip(lhs,rhs).lazy {
        if pair.0 != pair.1 { return false }
    }
    return true
}