//
//  SwifQL.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public let SwifQL: SwifQLable = _SwifQL()

public func SwifQL(_ query: SwifQLable) -> SwifQLable {
    _SwifQL(query)
}

private struct _SwifQL: SwifQLable {
    public var parts: [SwifQLPart] = []
    
    public init (_ query: SwifQLable? = nil) {
        if let parts = query?.parts {
            self.parts = parts
        }
    }
}

infix operator ~
public func ~ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    var parts = lhs.parts
    parts.append(contentsOf: rhs.parts)
    return SwifQLableParts(parts: parts)
}
public func ~ (lhs: SwifQLable, rhs: SwifQLPartOperator) -> SwifQLable {
    var parts = lhs.parts
    parts.append(o: rhs)
    return SwifQLableParts(parts: parts)
}
