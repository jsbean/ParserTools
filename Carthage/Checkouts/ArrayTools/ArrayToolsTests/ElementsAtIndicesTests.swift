//
//  ElementsAtIndicesTests.swift
//  Array
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class ElementsAtIndicesTests: XCTestCase {

    func testSafeSubscriptNil() {
        let array: [Int] = []
        XCTAssertNil(array[safe: 0])
    }
    
    func testSafeSubscriptValid() {
        let array = [1,2,3]
        XCTAssertEqual(array[safe: 2]!, 3)
    }
    
    func testSecondNil() {
        let array = [1]
        XCTAssertNil(array.second)
    }
    
    func testSecondVaild() {
        let array = [1,2]
        XCTAssertEqual(array.second!, 2)
    }
    
    func testPenultimateNil() {
        let array = [1]
        XCTAssertNil(array.penultimate)
    }
    
    func testPenultimateValid() {
        let array = [1,2]
        XCTAssertEqual(array.penultimate!, 1)
    }
    
    func testLastAmountEmpty() {
        let array: [Int] = []
        let last5 = array.last(amount: 5)
        XCTAssertNil(last5)
    }
    
    func testLastAmountTooMany() {
        let array = [1,2,3,4]
        let last5 = array.last(amount: 5)
        XCTAssertNil(last5)
    }
    
    func testLastAmountEquiv() {
        let array = [1,2,3,4,5]
        let last5 = array.last(amount: 5)!
        XCTAssertEqual(last5, array)
    }
    
    func testLastAmountValid() {
        let array = [1,2,3,4,5]
        let last4 = array.last(amount: 4)!
        XCTAssertEqual(last4, [2,3,4,5])        
    }
}
