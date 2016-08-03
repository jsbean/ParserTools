//
//  EquatableTests.swift
//  ArrayTools
//
//  Created by James Bean on 4/27/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class EquatableTests: XCTestCase {

    func testIsHomoegeneous() {
        XCTAssert([1,1,1,1,1].isHomogeneous)
    }
    
    func testIsHomogeneousFail() {
        XCTAssertFalse([1,2,1,1].isHomogeneous)
    }
    
    func testIsHomogeneousTrueSingleElement() {
        XCTAssert([1].isHomogeneous)
    }
    
    func testIsHeterogeneousFalseSingleElement() {
        XCTAssertFalse([1].isHeterogeneous)
    }
    
    func testIsHeterogeneousFalse() {
        XCTAssertFalse([1,1,1,1,1].isHeterogeneous)
    }
}
