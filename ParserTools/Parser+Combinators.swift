//
//  Combinators.swift
//  ParserTools
//
//  Created by James Bean on 8/4/16.
//
//

// TODO: Remove
public func sequence <Token, A, B> (lhs: Parser<Token, A>, _ rhs: Parser<Token, B>)
    -> Parser<Token, (A, B)>
{
    return Parser { input in
        let leftResults = lhs.parse(input)
        return flatMap(leftResults) { a, leftRemainder in
            let rightResults = rhs.parse(leftRemainder)
            return map(rightResults, { b, rightRemainder in
                ((a,b), rightRemainder)
            })
        }
    }
}

// TODO: Remove
public func combinator<Token, A, B>(lhs: Parser<Token, A -> B>, _ rhs: Parser<Token, A>)
    -> Parser<Token, B>
{
    return Parser { input in
        let leftResults = lhs.parse(input)
        return flatMap(leftResults) { f, leftRemainder in
            let rightResults = rhs.parse(leftRemainder)
            return map(rightResults) { x, rightRemainder in
                (f(x), rightRemainder)
            }
        }
    }
}

infix operator <|> { associativity right precedence 130 }

/**
 Option.
 */
public func <|> <Token, A> (lhs: Parser<Token, A>, rhs: Parser<Token, A>) -> Parser<Token, A> {
    return Parser { input in
        lhs.parse(input) + rhs.parse(input)
    }
}

infix operator <*> { associativity left precedence 150 }

public func <*> <Token, A, B> (lhs: Parser<Token, A -> B>, rhs: Parser<Token, A>)
    -> Parser<Token, B>
{
    
    return Parser { input in
        let leftResults = lhs.parse(input)
        return flatMap(leftResults) { f, leftRemainder in
            let rightResults = rhs.parse(leftRemainder)
            return map(rightResults) { x,y in (f(x), y) }
        }
    }
}

infix operator </> { precedence 170 }

public func </> <Token, A, B> (lhs: A -> B, rhs: Parser<Token, A>) -> Parser<Token, B> {
    return pure(lhs) <*> rhs
}

// MARK: - Discard 

infix operator <* { associativity left precedence 150 }

/**
 Discard right token.
 */
public func <* <Token, A, B> (lhs: Parser<Token, A>, rhs: Parser<Token, B>)
    -> Parser<Token, A>
{
    return { x in { _ in x } } </> lhs <*> rhs
}

infix operator *> { associativity left precedence 150 }

/**
 Discard left token.
 */
public func *> <Token, A, B> (lhs: Parser<Token, A>, rhs: Parser<Token, B>)
    -> Parser<Token, B>
{
    return { _ in { y in y } } </> lhs <*> rhs
}

infix operator </ { associativity left precedence 170 }

public func </ <Token, A, B> (lhs: A, rhs: Parser<Token, B>) -> Parser<Token, A> {
    return pure(lhs) <* rhs
}

