//
//  Predicates.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

private func buildPredicate(operator: Fn.Operator, lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts = lhs.parts
    parts.append(o: .space)
    parts.append(o: `operator`)
    parts.append(o: .space)
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}

public func > (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .greaterThan, lhs: lhs, rhs: rhs)
}

public func < (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .lessThan, lhs: lhs, rhs: rhs)
}

public func >= (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .greaterThanOrEqual, lhs: lhs, rhs: rhs)
}

public func <= (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .lessThanOrEqual, lhs: lhs, rhs: rhs)
}

public func === (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .equal, lhs: lhs, rhs: rhs)
}

public func != (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .notEqual, lhs: lhs, rhs: rhs)
}

public func && (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .and, lhs: lhs, rhs: rhs)
}

public func || (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .or, lhs: lhs, rhs: rhs)
}

//OR ||
