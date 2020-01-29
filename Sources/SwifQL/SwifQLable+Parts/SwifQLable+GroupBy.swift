//
//  SwifQLable+GroupBy.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: GROUP BY

extension SwifQLable {
    public func groupBy(_ fields: SwifQLable...) -> SwifQLable {
        groupBy(fields)
    }
    public func groupBy(_ fields: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .group)
        parts.append(o: .space)
        parts.append(o: .by)
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
