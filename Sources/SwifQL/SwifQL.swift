//
//  SwifQL.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public let SwifQL = _SwifQL()

public struct _SwifQL: SwifQLable {
    public var parts: [SwifQLPart]  { return [] }
    public init () {}
}

extension Decodable {
    public static var table: SwifQLable {
        if let model = Self.self as? Tableable.Type {
            return SwifQLableParts(parts: SwifQLPartTable(model.entity))
        }
        return SwifQLableParts(parts: SwifQLPartTable(String(describing: Self.self)))
    }
}

//extension SwifQLable {
//    public var SELECT: SwifQLable {
//        var parts = self.parts
//        parts.appendSpaceIfNeeded()
//        parts.append(o: .select)
//        return SwifQLableParts(parts: parts)
//    }
//    public var FROM: SwifQLable {
//        var parts = self.parts
//        parts.appendSpaceIfNeeded()
//        parts.append(o: .from)
//        return SwifQLableParts(parts: parts)
//    }
//}

infix operator ~
public func ~ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts = lhs.parts
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}
public func ~ (lhs: SwifQLable, rhs: Fn.Operator) -> SwifQLable {
    var parts = lhs.parts
    parts.append(o: rhs)
    return SwifQLableParts(parts: parts)
}

public enum SwifQLableArraySeparator {
    case comma
    
    var `operator`: Fn.Operator {
        switch self {
        case .comma: return .comma
        }
    }
}

extension Array: SwifQLable where Element == SwifQLable {
    public var parts: [SwifQLPart] {
        return separator(.comma).parts
    }
}

extension Array where Element == SwifQLable {
    public func separator(_ separator: SwifQLableArraySeparator) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, v) in enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
