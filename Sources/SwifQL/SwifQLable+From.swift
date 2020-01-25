//
//  SwifQLable+From.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

//MARK: From

extension SwifQLable {
    public func from(_ tables: SwifQLable...) -> SwifQLable {
        from(tables)
    }
    public func from(_ tables: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .from)
        parts.append(o: .space)
        for (i, v) in tables.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
