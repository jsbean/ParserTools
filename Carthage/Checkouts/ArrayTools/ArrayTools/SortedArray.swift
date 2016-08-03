//
//  SortedArray.swift
//  ArrayTools
//
//  Created by James Bean on 6/26/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/// Array that keeps itself sorted.
public struct SortedArray<T: Comparable> {
    
    private var array: [T] = []
    
    /// Create an empty `SortedArray`
    public init() { }

    /**
     Create a `SortedArray` with another `Array` value.
     */
    public init(_ array: [T]) {
        self.array = array.sort()
    }
    
    /**
     Remove the given `element`, if it is contained herein.
     */
    public mutating func remove(element: T) {
        guard let index = array.indexOf(element) else { return }
        array.removeAtIndex(index)
    }
    
    /**
     Insert the given `element`. Order will be kept.
     */
    public mutating func insert(element: T) {
        let index = insertionPoint(for: element)
        array.insert(element, atIndex: index)
    }
    
    /**
     Insert the contents of another sequence of `T`.
     */
    public mutating func insertContents<S: SequenceType where S.Generator.Element == T> (
        of elements: S
    )
    {
        elements.forEach { insert($0) }
    }
    
    // Use binary search to find insertion point
    private func insertionPoint(for element: T) -> Int {
        var range = 0..<array.count
        while range.startIndex < range.endIndex {
            let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
            if array[midIndex] == element {
                return midIndex
            } else if array[midIndex] < element {
                range.startIndex = midIndex + 1
            } else {
                range.endIndex = midIndex
            }
        }
        return range.startIndex
    }
}

/**
 - returns: `SortedArray` with the contents of two `SortedArray` values.
 */
public func + <T>(lhs: SortedArray<T>, rhs: SortedArray<T>) -> SortedArray<T> {
    var result = lhs
    result.insertContents(of: rhs)
    return result
}

extension SortedArray: Equatable { }

public func == <T>(lhs: SortedArray<T>, rhs: SortedArray<T>) -> Bool {
    for pair in zip(lhs, rhs) {
        if pair.0 != pair.1 { return false }
    }
    return true
}

extension SortedArray: SequenceType {
    
    public func generate() -> AnyGenerator<T> {
        var generator = array.generate()
        return AnyGenerator { return generator.next() }
    }
}

extension SortedArray: CollectionType {
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return array.count }
    
    public subscript (index: Int) -> T {
        return array[index]
    }
}

extension SortedArray: ArrayLiteralConvertible {
    
    
    
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}