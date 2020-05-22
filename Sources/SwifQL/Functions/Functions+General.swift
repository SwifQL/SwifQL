//
//  Functions+General.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var substr: Self = .init("substr")
    public static var coalesce: Self = .init("coalesce")
    public static var octet_length: Self = .init("octet_length")
    public static var cast: Self = .init("cast")
    public static var ifnull: Self = .init("ifnull")
    public static var isnull: Self = .init("isnull")
    public static var nvl: Self = .init("nvl")
    public static var expression: Self = .init("expression")
}

extension Fn {
    public static func substr(_ queryPart: SwifQLable, _ to: Int) -> SwifQLable {
        var parts: [SwifQLPart] = queryPart.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: to)
        return build(.substr, body: parts)
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
    
    public static func octet_length(_ string: SwifQLable) -> SwifQLable {
        build(.octet_length, body: string.parts)
    }
    
    public static func cast(_ queryPart: SwifQLable, _ to: Type) -> SwifQLable {
        cast(nil, queryPart, to)
    }
    
    public static func cast(_ from: Type?, _ queryPart: SwifQLable, _ to: Type) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let from = from?.name {
            parts.append(o: .custom(from))
            parts.append(o: .space)
        }
        parts.append(contentsOf: queryPart.parts)
        parts.append(o: .space)
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(o: .custom(to.name))
        return build(.cast, body: parts)
    }
    
    public static func ifNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.ifnull, body: parts)
    }
    
    public static func isNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.isnull, body: parts)
    }
    
    public static func nvl(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.nvl, body: parts)
    }
}
