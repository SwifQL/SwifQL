//
//  Functions+List.swift
//  SwifQL
//

import Foundation

extension Fn.Name {
    public static let listTransform: Self = .init("list_transform")
    public static let listFilter: Self = .init("list_filter")
    public static let listReduce: Self = .init("list_reduce")
}

extension Fn {
    private static func listFunctionArguments(_ values: [SwifQLable]) -> [SwifQLPart] {
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

    public static func listTransform(_ list: SwifQLable, _ lambda: SwifQLable) -> SwifQLable {
        build(.listTransform, body: listFunctionArguments([list, lambda]))
    }

    public static func listFilter(_ list: SwifQLable, _ lambda: SwifQLable) -> SwifQLable {
        build(.listFilter, body: listFunctionArguments([list, lambda]))
    }

    public static func listReduce(_ list: SwifQLable, _ lambda: SwifQLable) -> SwifQLable {
        build(.listReduce, body: listFunctionArguments([list, lambda]))
    }

    public static func listReduce(
        _ list: SwifQLable,
        _ lambda: SwifQLable,
        _ initialValue: SwifQLable
    ) -> SwifQLable {
        build(.listReduce, body: listFunctionArguments([list, lambda, initialValue]))
    }
}
