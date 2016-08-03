//
//  StackTests.swift
//  ArrayTools
//
//  Created by James Bean on 2/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class StackTests: XCTestCase {

    func testPush() {
        var stack = Stack<Int>()
        stack.push(1)
        XCTAssertEqual(stack, Stack(1))
    }
    
    func testPop() {
        var stack = Stack(1,2,3)
        stack.pop()
        XCTAssertEqual(stack, Stack(1,2))
    }
    
    func testPopAmountValid() {
        var stack = Stack(1,2,3,4,5,6,7,8,9)
        do {
            let popped = try stack.pop(amount: 4)
            XCTAssertEqual(popped, Stack(9,8,7,6))
            XCTAssertEqual(stack, Stack(1,2,3,4,5))
        } catch {
            XCTFail()
        }
    }
    
    func testPopTooManyAndThrow() {
        var stack = Stack(1,2,3,4)
        do {
            try stack.pop(amount: 5)
            XCTFail()
        } catch { }
    }
}