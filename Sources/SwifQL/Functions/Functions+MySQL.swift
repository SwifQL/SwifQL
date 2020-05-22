//
//  Functions+MySQL.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var from_unixtime: Self = .init("FROM_UNIXTIME")
}

extension Fn {
    public static func from_unixtime(_ timeinterval: SwifQLable, _ format: String? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = timeinterval.parts
        if let format = format {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(o: .custom(format.singleQuotted))
        }
        return build(.from_unixtime, body: parts)
    }
}
