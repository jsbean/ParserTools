//
//  RemoveElements.swift
//  ArrayTools
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

extension Array {

    // MARK: - Remove Elements
    
    /**
    Remove first element of Array
    
    >`[1,2,3].removeFirst -> [2,3]`
    
    >`[].removeFirst throws ArrayError.RemovalError`
    */
    public mutating func removeFirst() throws {
        guard count > 0 else { throw ArrayError.RemovalError }
        self.removeAtIndex(0)
    }
    
    /**
    Remove first number of elements from Array
     
    >`[1,2,3].removeFirst(amount: 2) -> [1]`
     
    >`[1,2,3].removeFirst(amount: 4) throws ArrayError.RemovalError`

    - parameter amount: Amount of elements to remove from beginning of Array
    */
    public mutating func removeFirst(amount amount: Int) throws {
        guard count >= amount else { throw ArrayError.RemovalError }
        for _ in 0..<amount { self.removeAtIndex(0) }
    }
    
    /**
    Remove last number of elements from Array
     
    >`[1,2,3].removeLast(amount: 3) -> []`
     
    >`[1,2,3].removeLast(amount: 4) throws ArrayError.RemovalError`

    - parameter amount: Amount of elements to remove from end of Array
    */
    public mutating func removeLast(amount amount: Int) throws {
        guard count >= amount else { throw ArrayError.RemovalError }
        for _ in 0..<amount { self.removeLast() }
    }
}