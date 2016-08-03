//
//  SortedArrayTests.swift
//  ArrayTools
//
//  Created by James Bean on 6/26/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class SortedArrayTests: XCTestCase {

    func testInitWithArraySorted() {
        let array = [1,5,4,3,2]
        let sortedArray = SortedArray(array)
        XCTAssert(sortedArray == [1,2,3,4,5])
    }
    
    func testInsertAtBeginning() {
        var sortedArray: SortedArray = [2,3,4,5]
        sortedArray.insert(1)
        XCTAssert(sortedArray == [1,2,3,4,5])
    }
    
    func testInsertAtEnd() {
        var sortedArray: SortedArray = [1,2,3,4]
        sortedArray.insert(5)
        XCTAssert(sortedArray == [1,2,3,4,5])
    }
    
    func testInsertInMiddle() {
        var sortedArray: SortedArray = [1,2,4,5]
        sortedArray.insert(3)
        XCTAssert(sortedArray == [1,2,3,4,5])
    }
    
    func testRemove() {
        var sortedArray: SortedArray = [1,2,3,4,5]
        sortedArray.remove(3)
        XCTAssert(sortedArray == [1,2,4,5])
    }
    
    func testInsertElements() {
        var a: SortedArray = [1,3,5]
        let b: SortedArray = [2,4,6]
        a.insertContents(of: b)
        XCTAssert(a == [1,2,3,4,5,6])
    }
    
    func testAdd() {
        let a: SortedArray = [1,2,5,6]
        let b: SortedArray = [3,4]
        XCTAssert(a + b == [1,2,3,4,5,6])
    }
}
