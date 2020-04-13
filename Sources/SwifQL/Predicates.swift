//
//  Predicates.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

public struct SwifQLPredicate: SwifQLable {
    public var parts: [SwifQLPart]
    
    public init (operator: SwifQLPartOperator, lhs: SwifQLable, rhs: SwifQLable?) {
        parts = lhs.parts
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
    }
}

public func > (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .greaterThan, lhs: lhs, rhs: rhs)
}

public func < (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .lessThan, lhs: lhs, rhs: rhs)
}

public func >= (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .greaterThanOrEqual, lhs: lhs, rhs: rhs)
}

public func <= (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .lessThanOrEqual, lhs: lhs, rhs: rhs)
}

public func == <T>(lhs: T, rhs: T.AType) -> SwifQLable
    where T: SwifQLUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType: Encodable {
    SwifQLPredicate(operator: .equal, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartSafeValue(rhs.rawValue)))
}
public func == <T>(lhs: T, rhs: T.AType.RawValue) -> SwifQLable
    where T: SwifQLUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType.RawValue: SwifQLable {
    SwifQLPredicate(operator: .equal, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartSafeValue(rhs)))
}
public func != <T>(lhs: T, rhs: T.AType) -> SwifQLable
    where T: SwifQLUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType: Encodable {
    SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartSafeValue(rhs.rawValue)))
}
public func != <T>(lhs: T, rhs: T.AType.RawValue) -> SwifQLable
    where T: SwifQLUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType.RawValue: SwifQLable {
    SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartSafeValue(rhs)))
}

public func == (lhs: SwifQLable, rhs: SwifQLable?) -> SwifQLable {
    SwifQLPredicate(operator: .equal, lhs: lhs, rhs: rhs)
}

public func != (lhs: SwifQLable, rhs: SwifQLable?) -> SwifQLable {
    SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: rhs)
}

public func == (lhs: SwifQLable, rhs: Bool) -> SwifQLable {
    SwifQLPredicate(operator: .equal, lhs: lhs, rhs: SwifQLPartBool(rhs))
}

public func != (lhs: SwifQLable, rhs: Bool) -> SwifQLable {
    SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: SwifQLPartBool(rhs))
}

public func == (lhs: Bool, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .equal, lhs: SwifQLPartBool(lhs), rhs: rhs)
}

public func != (lhs: Bool, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .notEqual, lhs: SwifQLPartBool(lhs), rhs: rhs)
}

public func && (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .and, lhs: lhs, rhs: rhs)
}

public func || (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .or, lhs: lhs, rhs: rhs)
}

/// Originally: @>
infix operator ||> : AdditionPrecedence
public func ||> (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .contains, lhs: lhs, rhs: rhs)
}

/// Originally: <@
infix operator <|| : AdditionPrecedence
public func <|| (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .containedBy, lhs: lhs, rhs: rhs)
}

/// Originally: BETWEEN
infix operator <> : AdditionPrecedence
public func <> (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    SwifQLPredicate(operator: .between, lhs: lhs, rhs: rhs)
}

// TBD: Table 9.43. json and jsonb Operators (https://www.postgresql.org/docs/current/functions-json.html)
// TBD: Table 9.44. Additional jsonb Operators (https://www.postgresql.org/docs/current/functions-json.html)

//OR ||
