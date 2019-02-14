//
//  SwifQLable+OrderBy.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

public enum OrderByItem: SwifQLable {
    case asc(SwifQLable)
    case desc(SwifQLable)
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        switch self {
        case .asc(let elements):
            parts.append(contentsOf: elements.parts)
            parts.append(o: .space)
            parts.append(o: .asc)
        case .desc(let elements):
            parts.append(contentsOf: elements.parts)
            parts.append(o: .space)
            parts.append(o: .desc)
        }
        return parts
    }
}

//MARK: ORDER BY

extension SwifQLable {
    public func orderBy(_ fields: OrderByItem...) -> SwifQLable {
        return orderBy(fields)
    }
    public func orderBy(_ fields: [OrderByItem]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .orderBy)
        parts.append(o: .space)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
