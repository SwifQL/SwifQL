//
//  SwifQLable+Conflict.swift
//  SwifQL
//
//  Created by Mihael Isaev on 24/07/2019.
//

import Foundation

//MARK: Conflict

extension SwifQLable {
    public var conflict: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .conflict)
        return SwifQLableParts(parts: parts)
    }
    public func conflict(_ fields: SwifQLable...) -> SwifQLable {
        return conflict(fields)
    }
    public func conflict(_ fields: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .conflict)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
