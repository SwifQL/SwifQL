//
//  Functions+MySQL.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var from_unixtime: Self = .init("FROM_UNIXTIME")
    public static var date_format: Self = .init("DATE_FORMAT")
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

    /// Formats the date value according to the format string.
    /// # Example
    /// ```swift
    /// Fn.date_format(\User.createdAt, "%y-%m")
    /// ```
    /// # Result
    /// ```
    /// date_format(User.createdAt, '%y-%m')
    /// ```
    /// [Learn more →](https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format)
    /// [Learn more →](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format)
    public static func date_format(_ datetime: SwifQLable, _ format: String) -> SwifQLable {
        var parts: [SwifQLPart] = datetime.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(o: .custom(format.singleQuotted))
        return build(.date_format, body: parts)
    }
}
