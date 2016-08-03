//
//  Stack.swift
//  ArrayTools
//
//  Created by James Bean on 2/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
 Implementation of Stack structure.
 
 - TODO: Conform to `SequenceType` and `ComparableType`.
 */
public struct Stack<Element: Equatable> {
    
    private var items: [Element] = []
    
    // MARK: - Instance Variables
    
    /// Last `Element` in `Stack`
    public var top: Element? { return items.last }
    
    // MARK: - Initializers
    
    /**
     Create an empty `Stack`
     
     - returns: Initialized `Stack`
     */
    public init() { }
    
    /**
     Create a `Stack` with the items of an `Array`
     
     - parameter items: Items with which to populate `Stack`
     
     - returns: Initialized `Stack` with items in `Array`
     */
    public init(_ items: [Element]) {
        self.items = items
    }
    
    /**
     Create a `Stack` with items
     
     - parameter items: Items with which to populate `Stack`
     
     - returns: Initialized `Stack` with items
     */
    public init(_ items: Element...) {
        self.items = items
    }
    
    // MARK: - Instance Methods
    
    /**
     Push item to end of `Stack`
     
     - parameter item: Item to push to end of `Stack`
     */
    public mutating func push(item: Element) {
        items.append(item)
    }
    
    /**
     Pop item from end of `Stack`
     
     - returns: Last item of `Stack`
     */
    public mutating func pop() -> Element? {
        if items.count == 0 { return nil }
        return items.removeLast()
    }
    
    /**
     Pop a given amount of items from end of `Stack`
     
     - parameter amount: Amount of items to pop from end of `Stack`
     
     - throws: `ArrayError.RemovalError` if `amount` is greater than amount of items in `Stack`
     
     - returns: `Stack` containing items popped from end of `Stack`
     */
    public mutating func pop(amount amount: Int) throws -> Stack<Element> {
        guard items.count > amount else { throw ArrayError.RemovalError }
        var poppedItems: Stack<Element> = Stack()
        for _ in 0..<amount { poppedItems.push(pop()!) }
        return poppedItems
    }
}

extension Stack: Equatable { }

/**
 Check equality of two `Stack` structs
 
 - parameter lhs: One `Stack`
 - parameter rhs: Another `Stack`
 
 - returns: True if all items in both `Stack` structs are equivalent. Otherwise false.
 */
public func == <T>(lhs: Stack<T>, rhs: Stack<T>) -> Bool {
    return lhs.items == rhs.items
}