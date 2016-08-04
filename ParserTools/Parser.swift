//
//  Parser.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

import ArrayTools

/**
 Generic wrapper of `parse` function.
 */
public struct Parser<Token, Result> {
    
    /// Function that takes an `ArraySlice` of generic Token type, and returns a sequence of
    /// 2-tuples containing the generic Result type and an `ArraySlice` of Token type values.
    let parse: ArraySlice<Token> -> AnySequence<(Result, ArraySlice<Token>)>
}

public func eof<A>() -> Parser<A, ()> {
    
    return Parser { stream in
        if stream.isEmpty {
            return one((), stream)
        }
        return none()
    }
}

public func none<T>() -> AnySequence<T> {
    return AnySequence(AnyGenerator { nil })
}

public func fail<Token, Result>() -> Parser<Token, Result> {
    return Parser { _ in none() }
}

public func one<T>(x: T?) -> AnyGenerator<T> {
    return AnyGenerator(GeneratorOfOne(x))
}

public func one<A>(x: A) -> AnySequence<A> {
    return AnySequence(GeneratorOfOne(x))
}

public func zeroOrMore<Token, A> (parser: Parser<Token, A>) -> Parser<Token, [A]> {
    return (pure(prepend) <*> parser <*> lazy { zeroOrMore(parser) }) <|> pure([])
}

public func oneOrMore<Token, A> (parser: Parser<Token, A>) -> Parser<Token, [A]> {
    return pure(prepend) <*> parser <*> zeroOrMore(parser)
}

public func pure<Token, A>(x: A) -> Parser<Token, A> {
    return Parser { one((x, $0)) }
}

public func prepend<A>(l: A) -> [A] -> [A] {
    return { (x: [A]) in [l] + x }
}

public func lazy<Token, A>(f: () -> Parser<Token, A>) -> Parser<Token, A> {
    return Parser { x in f().parse(x) }
}

public func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
    return Parser { x in
        if let (head, tail) = x.destructured {
            if condition(head) {
                return one((head, tail))
            }
        }
        return none()
    }
}

public func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
    return satisfy { $0 == t }
}