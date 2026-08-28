//
//  Functions+General.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static let subStr: Self = .init("substr")
    @available(*, deprecated, renamed: "subStr")
    public static var substr: Self { .subStr }
    public static let coalesce: Self = .init("coalesce")
    public static let octetLength: Self = .init("octet_length")
    @available(*, deprecated, renamed: "octetLength")
    public static var octet_length: Self { .octetLength }
    public static let cast: Self = .init("cast")
    public static let nextVal: Self = .init("nextval")
    public static let currVal: Self = .init("currval")
    public static let ifNull: Self = .init("ifnull")
    @available(*, deprecated, renamed: "ifNull")
    public static var ifnull: Self { .ifNull }
    public static let isNull: Self = .init("isnull")
    @available(*, deprecated, renamed: "isNull")
    public static var isnull: Self { .isNull }
    public static let nvl: Self = .init("nvl")
    public static let groupingId: Self = .init("grouping_id")
    public static let expression: Self = .init("expression")
}

extension Fn {
    public static func subStr(_ queryPart: SwifQLable, _ to: Int) -> SwifQLable {
        var parts: [SwifQLPart] = queryPart.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: to)
        return build(.subStr, body: parts)
    }

    @available(*, deprecated, renamed: "subStr(_:_:)")
    public static func substr(_ queryPart: SwifQLable, _ to: Int) -> SwifQLable {
        subStr(queryPart, to)
    }
    
    /// `SELECT COALESCE (NULL, 2 , 1);` will return 2
    public static func coalesce(_ queryPart: SwifQLable...) -> SwifQLable {
        coalesce(queryPart)
    }
    
    /// `SELECT COALESCE (NULL, 2 , 1);` will return 2
    public static func coalesce(_ queryParts: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, q) in queryParts.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
            }
            parts.append(contentsOf: q.parts)
        }
        return build(.coalesce, body: parts)
    }

    /// Returns the count of all rows in the current aggregate input.
    public static func count() -> SwifQLable {
        build(.count, body: [])
    }

    /// Returns DuckDB's grouping bitfield for one or more grouping expressions.
    public static func groupingId(
        _ expression: SwifQLable,
        _ expressions: SwifQLable...
    ) -> SwifQLable {
        groupingId([expression] + expressions)
    }

    public static func groupingId(_ expressions: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (index, expression) in expressions.enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: expression.parts)
        }
        return build(.groupingId, body: parts)
    }
    
    public static func octetLength(_ string: SwifQLable) -> SwifQLable {
        build(.octetLength, body: string.parts)
    }

    @available(*, deprecated, renamed: "octetLength(_:)")
    public static func octet_length(_ string: SwifQLable) -> SwifQLable {
        octetLength(string)
    }
    
    public static func cast(_ queryPart: SwifQLable, _ to: Type) -> SwifQLable {
        cast(nil, queryPart, to)
    }
    
    public static func cast(_ from: Type?, _ queryPart: SwifQLable, _ to: Type) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let from {
            parts.append(SwifQLPartType(from))
            parts.append(o: .space)
        }
        parts.append(contentsOf: queryPart.parts)
        parts.append(o: .space)
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(SwifQLPartType(to))
        return build(.cast, body: parts)
    }

    public static func nextVal(_ sequence: SwifQLable) -> SwifQLable {
        build(.nextVal, body: sequence.parts)
    }

    public static func currVal(_ sequence: SwifQLable) -> SwifQLable {
        build(.currVal, body: sequence.parts)
    }
    
    public static func ifNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.ifNull, body: parts)
    }
    
    public static func isNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.isNull, body: parts)
    }
    
    public static func nvl(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.nvl, body: parts)
    }
}
