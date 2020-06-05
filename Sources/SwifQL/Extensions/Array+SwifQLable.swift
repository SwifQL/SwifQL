//
//  Array+SwifQLable.swift
//
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

extension Array: SwifQLable where Element: SwifQLable {
    public var parts: [SwifQLPart] {
        separator(.comma).parts
    }
}

extension Array where Element: SwifQLable {
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

extension Array: SwifQLPart where Element: SwifQLable {}

extension Array: SwifQLPartArray where Element: SwifQLable {
    public var elements: [SwifQLable] { self }
}
