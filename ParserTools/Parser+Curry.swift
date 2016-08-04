//
//  Curry.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

public func curry <A, B, C, D> (f: (A, B, C) -> D) -> A -> B -> C -> D {
    return { a in { b in { c in f(a,b,c) } } }
}

public func curry <A, B, C> (f: (A, B) -> C) -> A -> B -> C {
    return { a in { b in f(a,b) } }
}