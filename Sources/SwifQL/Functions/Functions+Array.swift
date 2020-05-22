//
//  Functions+Array.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var array_agg: Self = .init("array_agg")
    public static var array_remove: Self = .init("array_remove")
}

extension Fn {
    ///
    public static func array_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.array_agg, body: aggregateExpression.parts)
    }
    
    /// `SELECT array_remove(ARRAY[1,2,3,2], 2);` will return {1,3}
    public static func array_remove(_ queryPart: SwifQLable...) -> SwifQLable {
        array_remove(queryPart)
    }
    
    /// `SELECT array_remove(ARRAY[1,2,3,2], 2);` will return {1,3}
    public static func array_remove(_ queryParts: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, q) in queryParts.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: q.parts)
        }
        return build(.array_remove, body: parts)
    }
}
