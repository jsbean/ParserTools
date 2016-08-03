//
//  CombinationsTests.swift
//  ArrayTools
//
//  Created by James Bean on 5/5/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class CombinationsTests: XCTestCase {

    func testCombinations() {
        let array1 = [1,2,3]
        let array2 = [4,5]
        XCTAssertEqual(combinations(array1, array2).count, 6)
    }
    
    func testSubsetsEmptyNil() {
        let array: [Int] = []
        XCTAssertNil(array.subsets(withCardinality: 2))
    }
    
    func testSubsetsCarinalityGreaterThanCountNil() {
        let array = [1,2]
        XCTAssertNil(array.subsets(withCardinality: 3))
    }
    
    func testSubsetsDouble() {
        let array = [1,2]
        XCTAssertEqual([[1],[2]], array.subsets(withCardinality: 1)!)
    }
    
    func testSubsetsTriple() {
        let array = [1,2,3]
        XCTAssertEqual([[1,2],[1,3],[2,3]], array.subsets(withCardinality: 2)!)
    }
    
    func testSubsetsQuadruple() {
        let array = [1,2,3,4]
        XCTAssertEqual(
            [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]],
            array.subsets(withCardinality: 2)!
        )
    }
    
    func testAdjacentPairsNil() {
        XCTAssertNil([1].adjacentPairs)
    }
    
    func testAdjacentPairs() {
        XCTAssertEqual([1,2,3,4].adjacentPairs!.count, 3)
    }
}
