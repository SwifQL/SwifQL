//
//  KeyPath.swift
//  SwifQL
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation

public protocol KeyPathLastPath {
    var lastPath: String { get }
}

extension String: KeyPathLastPath {
    public var lastPath: String { self }
}

public protocol FQUniversalKeyPathSimple: KeyPathLastPath {
    var queryValue: String { get }
    var path: String { get }
    var lastPath: String { get }
}

public protocol FQUniversalKeyPath {
    associatedtype AType
    associatedtype AModel: Decodable
    associatedtype ARoot
    
    var queryValue: String { get }
    var path: String { get }
    var lastPath: String { get }
    var originalKeyPath: KeyPath<AModel, AType> { get }
}

//MARK: - Casting

infix operator => : AdditionPrecedence
/// e.g. `"1"::.text`
public func => (lhs: SwifQLable, rhs: Type) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .custom("::"))
    parts.append(o: .custom(rhs.name))
    return SwifQLableParts(parts: parts)
}
/// e.g. `"hello" as "title"`
public func => (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .as)
    parts.append(o: .space)
    if let rhs = rhs as? FQUniversalKeyPathSimple {
        parts.append(SwifQLPartAlias(rhs.lastPath))
    } else {
        parts.append(SwifQLPartAlias(String(describing: rhs)))
    }
    return SwifQLableParts(parts: parts)
}

prefix operator =>
/// write `=>"aliasName"` in Swift
/// to reach `"aliasName"` in SQL
public prefix func => (rhs: String) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(SwifQLPartAlias(rhs))
    return SwifQLableParts(parts: parts)
}

/// Getting keypath with alias
/// e.g. you have `User` table with `email` field, and normally you can just write \User.email
/// but in case of alias e.g. `let u = User.alias("u")` you should call it like `u+\.email`
infix operator ~: AdditionPrecedence
public func ~ <K, T, V>(lhs: SwifQLTableAlias<T>, rhs: K) -> AliasedKeyPath<K, T, V> where K: KeyPath<T, V>, K: Keypathable, T: Decodable {
    return AliasedKeyPath(lhs.alias, rhs)
}

//MARK: - Basic arithmetic functions
public func + (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("+"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

infix operator ++: AdditionPrecedence
public func ++ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("+"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

public func - (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("-"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

infix operator --: AdditionPrecedence
public func -- (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("-"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

public func * (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("*"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

infix operator **: AdditionPrecedence
public func ** (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("*"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

public func / (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = lhs.parts
    parts.append(o: .space)
    parts.append(o: .custom("/"))
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

//% prefix for LIKE
prefix operator %
prefix public func %(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .custom("%"))
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}

//% postfix for LIKE
postfix operator %
postfix public func %(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .custom("%"))
    return SwifQLableParts(parts: parts)
}

//1 opening bracket
prefix operator |
prefix public func |(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}
//2 opening brackets
prefix operator ||
prefix public func ||(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}
//3 opening brackets
prefix operator |||
prefix public func |||(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}
//4 opening brackets
prefix operator ||||
prefix public func ||||(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}
//5 opening brackets
prefix operator |||||
prefix public func |||||(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}
//6 opening brackets
prefix operator ||||||
prefix public func ||||||(lhs: SwifQLable) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(o: .openBracket)
    parts.append(contentsOf: lhs.parts)
    return SwifQLableParts(parts: parts)
}

//1 closing bracket
postfix operator |
postfix public func |(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}
//2 closing brackets
postfix operator ||
postfix public func ||(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}
//3 closing brackets
postfix operator |||
postfix public func |||(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}
//4 closing brackets
postfix operator ||||
postfix public func ||||(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}
//5 closing brackets
postfix operator |||||
postfix public func |||||(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}
//6 closing brackets
postfix operator ||||||
postfix public func ||||||(rhs: SwifQLable) -> SwifQLable {
    var parts = rhs.parts
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    parts.append(o: .closeBracket)
    return SwifQLableParts(parts: parts)
}

postfix operator *
postfix public func *(lhs: SwifQLable) -> SwifQLable {
    var parts = lhs.parts
    parts.appendSpaceIfNeeded()
    parts.append(o: .custom("*"))
    return SwifQLableParts(parts: parts)
}

postfix operator .*
postfix public func .*(lhs: SwifQLable) -> SwifQLable {
    var parts = lhs.parts
    parts.append(o: .custom(".*"))
    parts.append(o: .space)
    return SwifQLableParts(parts: parts)
}
