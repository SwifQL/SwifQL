//
//  Predicates.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

private func buildPredicate(operator: Fn.Operator, lhs: SwifQLable, rhs: SwifQLable?) -> SwifQLable {
    var parts = lhs.parts
    parts.append(o: .space)
    if let rhs = rhs {
        parts.append(o: `operator`)
        parts.append(o: .space)
        parts.append(contentsOf: rhs.parts)
    } else {
        switch `operator` {
        case .equal: parts.append(o: .isNull)
        case .notEqual: parts.append(o: .isNotNull)
        default: parts.append(o: .null)
        }
    }
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

public func == (lhs: SwifQLable, rhs: SwifQLable?) -> SwifQLable {
    return buildPredicate(operator: .equal, lhs: lhs, rhs: rhs)
}

public func != (lhs: SwifQLable, rhs: SwifQLable?) -> SwifQLable {
    return buildPredicate(operator: .notEqual, lhs: lhs, rhs: rhs)
}

public func == (lhs: SwifQLable, rhs: Bool) -> SwifQLable {
    return buildPredicate(operator: .equal, lhs: lhs, rhs: SwifQLPartBool(rhs))
}

public func != (lhs: SwifQLable, rhs: Bool) -> SwifQLable {
    return buildPredicate(operator: .notEqual, lhs: lhs, rhs: SwifQLPartBool(rhs))
}

public func == (lhs: Bool, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .equal, lhs: SwifQLPartBool(lhs), rhs: rhs)
}

public func != (lhs: Bool, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .notEqual, lhs: SwifQLPartBool(lhs), rhs: rhs)
}

public func && (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .and, lhs: lhs, rhs: rhs)
}

public func || (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .or, lhs: lhs, rhs: rhs)
}

/// Originally: @>
infix operator ||> : AdditionPrecedence
public func ||> (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .contains, lhs: lhs, rhs: rhs)
}

/// Originally: <@
infix operator <|| : AdditionPrecedence
public func <|| (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    return buildPredicate(operator: .containedBy, lhs: lhs, rhs: rhs)
}

// TBD: Table 9.43. json and jsonb Operators (https://www.postgresql.org/docs/current/functions-json.html)
// TBD: Table 9.44. Additional jsonb Operators (https://www.postgresql.org/docs/current/functions-json.html)

//OR ||
