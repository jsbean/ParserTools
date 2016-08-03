//
//  RemoveElementsTests.swift
//  Array
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class RemoveElementsTests: XCTestCase {

    func testRemoveFirstThrows() {
        var array: [Int] = []
        do {
            try array.removeFirst()
            XCTFail()
        } catch { }
    }
    
    func testRemoveFirst() {
        var array = [1]
        do {
            try array.removeFirst()
            XCTAssertEqual(array, [])
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveFirstAmountThrows() {
        var array = [1]
        do {
            try array.removeFirst(amount: 2)
            XCTFail()
        } catch { }
    }
    
    func testRemoveFirstAmount() {
        var array = [1,2,3]
        do {
            try array.removeFirst(amount: 2)
            XCTAssertEqual(array, [3])
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveLastAmountThrows() {
        var array: [Int] = []
        do {
            try array.removeLast(amount: 1)
            XCTFail()
        } catch { }
    }
    
    func testRemoveLastAmount() {
        var array = [1,2,3]
        do {
            try array.removeLast(amount: 2)
            XCTAssertEqual(array, [1])
        } catch {
            XCTFail()
        }
    }
}
