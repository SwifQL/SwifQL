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
    public var parts: [SwifQLPart]

    public init (_ query: SwifQLable? = nil) {
        self.parts = query?.parts ?? [SwifQLStructuralFramePart(region: .statement)]
    }
}

infix operator ~
public func ~ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
    if lhs.parts.first is SwifQLStructuralFramePart {
        if rhs.parts.first is SwifQLStructuralFramePart {
            return SwifQLableParts(rawParts: lhs.parts + rhs.parts)
        }
        return _SwifQLStructuralComposition.append(
            lhs,
            parts: rhs.parts,
            spacing: .literal
        )
    }

    return SwifQLableParts(rawParts: lhs.parts + rhs.parts)
}
public func ~ (lhs: SwifQLable, rhs: SwifQLPartOperator) -> SwifQLable {
    let fragment = SwifQLableParts(parts: rhs)
    if lhs.parts.first is SwifQLStructuralFramePart {
        return _SwifQLStructuralComposition.append(
            lhs,
            parts: fragment.parts,
            spacing: .literal
        )
    }

    return SwifQLableParts(rawParts: lhs.parts + fragment.parts)
}
