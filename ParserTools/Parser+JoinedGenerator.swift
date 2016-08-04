//
//  JoinedGenerator.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

import Foundation

public struct JoinedGenerator<Element>: GeneratorType {
    
    public var generator: AnyGenerator<AnyGenerator<Element>>
    public var current: AnyGenerator<Element>?
    
    public init<
        G: GeneratorType where G.Element: GeneratorType, G.Element.Element == Element
    >(_ g: G)
    {
        var g = g
        self.generator = g.map(AnyGenerator.init)
        self.current = generator.next()
    }
    
    public mutating func next() -> Element? {
        guard let c = current else { return nil }
        if let x = c.next() {
            return x
        } else {
            current = generator.next()
            return next()
        }
    }
}

public func join<A>(s: AnySequence<AnySequence<A>>) -> AnySequence<A> {
    return AnySequence {
        JoinedGenerator(map(s.generate()) { $0.generate() })
    }
}

public func flatMap<A, B>(ls: AnySequence<A>, _ f: A -> AnySequence<B>) -> AnySequence<B> {
    return join(map(ls, f))
}

public func + <A> (lhs: AnySequence<A>, rhs: AnySequence<A>) -> AnySequence<A> {
    return join(AnySequence([lhs, rhs]))
}
