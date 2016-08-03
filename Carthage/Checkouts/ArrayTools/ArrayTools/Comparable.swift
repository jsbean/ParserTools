//
//  Comparable.swift
//  ArrayTools
//
//  Created by James Bean on 6/2/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

// Modified from: https://airspeedvelocity.net/2016/01/10/writing-a-generic-stable-sort/

extension RangeReplaceableCollectionType where
    Index: RandomAccessIndexType,
    SubSequence.Generator.Element == Generator.Element,
    Index.Distance == Index.Stride
{
    public func stableSort(
        isOrderedBefore: (Generator.Element, Generator.Element) -> Bool
    ) -> [Generator.Element]
    {
        var result = self // make copy of self to return
        let count = result.count
        
        var aux: [Generator.Element] = []
        aux.reserveCapacity(numericCast(count))
        
        func merge(lo: Index, _ mid: Index, _ hi: Index) {
            
            aux.removeAll(keepCapacity: true)
        
            var i = lo
            var j = mid
            
            while i < mid && j < hi {
                if isOrderedBefore(result[j], result[i]) {
                    aux.append(result[j])
                    j += 1
                }
                else {
                    aux.append(result[i])
                    i += 1
                }
            }
            
            aux.appendContentsOf(result[i ..< mid])
            aux.appendContentsOf(result[j ..< hi])
            result.replaceRange(lo ..< hi, with: aux)
        }
        
        var sz: Index.Distance = 1
        while sz < count {
            for lo in result.startIndex.stride(to: result.endIndex - sz, by: sz * 2) {
                merge(lo, lo + sz, lo.advancedBy(sz * 2, limit: result.endIndex))
            }
            sz *= 2
        }
        return Array(result)
    }
}