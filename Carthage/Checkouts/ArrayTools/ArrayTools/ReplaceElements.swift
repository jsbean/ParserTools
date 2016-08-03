//
//  ReplaceElements.swift
//  ArrayTools
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension Array {
    
    // MARK: - Replace Elements
    
    /**
    Replace element at index with a new element.

    - parameter index:      Index of element to be replaced
    - parameter newElement: New element to replace element at index.
    */
    public mutating func replaceElement(at index: Int, withElement newElement: Element) throws
    {
        guard index > 0 && index < self.count else { throw ArrayError.RemovalError }
        removeAtIndex(index)
        insert(newElement, atIndex: index)
    }
    
    /**
    Replace the last element in Array with a new element.

    - parameter newElement: New element to replace last element.
    */
    public mutating func replaceLast(with element: Element) throws {
        guard self.count > 0 else { throw ArrayError.RemovalError }
        removeLast()
        append(element)
    }
    
    /**
    Replace first element in Array with a new element.

    - parameter newElement: New element to replace first element.
    */
    public mutating func replaceFirst(with element: Element) throws {
        try removeFirst()
        insert(element, atIndex: 0)
    }
}