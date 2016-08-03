//
//  Combinations+Permutations.swift
//  ArrayTools
//
//  Created by James Bean on 5/5/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

/**
 - returns: All combinations of elements of two arrays.
 */
public func combinations<T, U>(array1: [T], _ array2: [U]) -> [(T, U)] {
    return array1.reduce([]) { accum, t in accum + array2.map { u in (t,u) } }
}

extension Array {
    
    /**
     - returns: All combinations of with a given cardinality 
     (how many elements chosen per combination) if self is not empty or count < k.
     Otherwise, `nil`.
     */
    public func subsets(withCardinality k: UInt) -> [[Element]]? {
        
        func subsets(
            withCardinality k: UInt,
            combinedWith prefix: [Element],
            startingAt index: Int
        ) -> [[Element]]
        {
            if k == 0 { return [prefix] }
            if index < count {
                let first = self[index]
                return (
                    subsets(
                        withCardinality: k - 1,
                        combinedWith: prefix + [first],
                        startingAt: index + 1
                    ) +
                    subsets(
                        withCardinality: k,
                        combinedWith: prefix,
                        startingAt: index + 1
                    )
                )
            }
            return []
        }
        
        if isEmpty || count < Int(k) { return nil }
        return subsets(withCardinality: k, combinedWith: [], startingAt: 0)
    }
}