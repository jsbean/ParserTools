//
//  ReplaceElementsTests.swift
//  Array
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class ReplaceElementsTests: XCTestCase {

    func testReplaceFirstThrows() {
        var array: [Int] = []
        do {
            try array.replaceFirst(with: 0)
            XCTFail()
        } catch { }
    }
    
    func testReplaceFirst() {
        var array = [1,2,3]
        do {
            try array.replaceFirst(with: 4)
            XCTAssertEqual(array, [4,2,3])
        } catch {
            XCTFail()
        }
    }
    
    func testReplaceLastThrows() {
        var array: [Int] = []
        do {
            try array.replaceLast(with: 0)
            XCTFail()
        } catch { }
    }
    
    func testReplaceLast() {
        var array = [1,2,3]
        do {
            try array.replaceLast(with: 0)
            XCTAssertEqual(array, [1,2,0])
        } catch {
            XCTFail()
        }
    }
    
    func testReplaceElementAtIndexThrows() {
        var array: [Int] = []
        do {
            try array.replaceElement(at: 0, withElement: 0)
            XCTFail()
        } catch { }
    }
    
    func testReplaceElementAtIndex() {
        var array: [Int] = [1,2]
        do {
            try array.replaceElement(at: 1, withElement: 0)
            XCTAssertEqual(array, [1,0])
        } catch {
            XCTFail()
        }
    }
}
