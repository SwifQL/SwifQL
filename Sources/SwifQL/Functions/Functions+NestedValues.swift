//
//  Functions+NestedValues.swift
//  SwifQL
//

import Foundation

extension Fn.Name {
    public static let listValue: Self = .init("list_value")
    public static let arrayValue: Self = .init("array_value")
    public static let map: Self = .init("map")
}

extension Fn {
    private static func nestedValueArguments(_ values: [SwifQLable]) -> [SwifQLPart] {
        var parts: [SwifQLPart] = []
        for (index, value) in values.enumerated() {
            if index > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: value.parts)
        }
        return parts
    }

    public static func listValue(_ values: SwifQLable...) -> SwifQLable {
        listValue(values)
    }

    public static func listValue(_ values: [SwifQLable]) -> SwifQLable {
        build(.listValue, body: nestedValueArguments(values))
    }

    public static func arrayValue(_ values: SwifQLable...) -> SwifQLable {
        arrayValue(values)
    }

    public static func arrayValue(_ values: [SwifQLable]) -> SwifQLable {
        precondition(!values.isEmpty, "arrayValue requires at least one value")
        return build(.arrayValue, body: nestedValueArguments(values))
    }

    public static func map(_ keys: SwifQLable, _ values: SwifQLable) -> SwifQLable {
        build(.map, body: nestedValueArguments([keys, values]))
    }
}
