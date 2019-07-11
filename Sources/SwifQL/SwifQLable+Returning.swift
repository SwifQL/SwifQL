//
//  SwifQLable+Returning.swift
//  SwifQL
//
//  Created by Mihael Isaev on 11/07/2019.
//

import Foundation

extension SwifQLable {
    public func returning(_ items: SwifQLable...) -> SwifQLable {
        return returning(items)
    }
    public func returning(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .returning)
        parts.append(o: .space)
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
