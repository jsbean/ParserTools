//
//  AnySequenceType.swift
//  ArrayTools
//
//  Created by James Bean on 6/3/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
 Type erasing protocol that allows the `SequenceType` implementation to be left to the 
 individual `struct`.
 
 For example, `PitchSet` and `PitchSequence` are both containers for `Pitch` values, and should
 both be able to be used as `SequenceType` conforming structures. By conforming to this
 protocol, the `PitchSet` can use a `Set<Pitch>` as its underlying model, while `PitchSequence`
 can use an `Array<Pitch>` as its underlying model.
 
 In the conforming `struct`, it is necessary to add a private `var` which is an implementation
 of a `SequenceType` conforming `struct`, which is then given by the `sequence` getter. 
 
 In the `init` method of the conforming `struct`, set the value of this private `var` with the
 given `sequence.
 */
public protocol AnySequenceType: SequenceType, ArrayLiteralConvertible {
    
    // MARK: Associated Types
    
    /// The contained type
    associatedtype Element
    
    /// `AnySequence` wrapper that provides shade for the domain specific implementation.
    var sequence: AnySequence<Element> { get }
    
    /**
     Create an `AnySequenceType` with a `Sequence` of any type.
     
     In the `init` method of the conforming `struct`, set the value of this private `var` with
     the given `sequence.
     */
    init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S)
}

extension AnySequenceType {

    // MARK: - SequenceType
    
    /**
     Returns a generator over the elements of this sequence.
     */
    public func generate() -> AnyGenerator<Element> {
        let generator = sequence.generate()
        return AnyGenerator { return generator.next() }
    }
}

/**
 - returns: `true` if all elements in both sequnces are equivalent. Otherwise, `false`.
 */
public func == <T: AnySequenceType where T.Element: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs.sequence == rhs.sequence
}