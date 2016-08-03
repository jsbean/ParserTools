//
//  Predicates.swift
//  ArrayTools
//
//  Created by James Bean on 5/27/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension SequenceType {
    
    // MARK: - Predicates

    /**
     - parameter compare:      Function the takes two values of the type of the given
        `extractedValue`, for the purpose of sorting this `SequenceType`.
     - parameter extractValue: Function that takes a value of the type of this `SequenceType`,
        and returns a given instance property of the value.
     
     - returns: The elements containing the value
     
     **Example:**
     
     ```
     struct S: Equatable { let value: Int }
     let array = [S(value: 1), S(value: 3), S(value: 2), S(value: 3)]
     ```
     
     ```
     let greatestElements = array.extremeElements(>) { $0.value }
     let leastElements = array.extremeElements(<) { $0.value }
     ```
     
     ```
     greatestElements == [S(value: 3), S(value: 3)]
     leastElements == [S(value: 1)]
     ```
     */
    public func extremeElements<T: Comparable>(
        compare: (T, T) -> Bool,
        valueToCompare extractValue: (Generator.Element) -> T) -> [Generator.Element]
    {
        let sorted = self.sort { compare(extractValue($0), extractValue($1)) }
        guard let first = sorted.first else { return [] }
        let most = extractValue(first)
        return sorted.filter { extractValue($0) == most }
    }
    
    /**
     - returns: The greatest value held by an element held herein, if there are more than 0
     elements. Otherwise, `nil`.
     */
    public func greatest<T: Comparable>(valueToCompare extractValue: (Generator.Element) -> T)
        -> T?
    {
        return extremity(>, valueToCompare: extractValue)
    }
    
    /**
     - returns: The least value held by an element held herein, if there are more than 0
     elements. Otherwise, `nil`.
     */
    public func least<T: Comparable>(valueToCompare extractValue: (Generator.Element) -> T)
        -> T?
    {
        return extremity(<, valueToCompare: extractValue)
    }
    
    /**
     - returns: The most extreme value held by an element held herein, if there are more than 0
     elements. Otherwise, `nil`.
     */
    public func extremity<T: Comparable>(
        compare: (T, T) -> Bool,
        valueToCompare extractValue: (Generator.Element) -> T
    ) -> T?
    {
        guard let first = sort ({ compare(extractValue($0), extractValue($1)) }).first else {
            return nil
        }
        
        return extractValue(first)
    }

    /**
     - returns: `true` if all elements satisfy the given `predicate`. Otherwise, `false`.
     */
    public func allSatisfy(@noescape predicate: Generator.Element -> Bool) -> Bool {
        for element in self { if !predicate(element) { return false } }
        return true
    }
    
    /**
     - returns: `true` if any elements satisfy the given `predicate`. Otherwise, `false`.
     */
    public func anySatisfy(@noescape predicate: Generator.Element -> Bool) -> Bool {
        for element in self { if predicate(element) { return true } }
        return false
    }
}

