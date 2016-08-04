//
//  Map.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

extension GeneratorType {
    
    public mutating func map<B>(transform: Element -> B) -> AnyGenerator<B> {
        return AnyGenerator {
            self.next().map(transform)
        }
    }
}

/**
 - returns: `AnyGenerator` with the values of `g` applied to the function `f`.
 */
public func map<A, B>(g: AnyGenerator<A>, _ f: A -> B) -> AnyGenerator<B> {
    return AnyGenerator { g.next().map(f) }
}

/**
 - returns: `AnySequence` with the values of `s` applied to the function `f`.
 */
public func map<A, B>(s: AnySequence<A>, _ f: A -> B) -> AnySequence<B> {
    return AnySequence { map(s.generate(), f) }
}
