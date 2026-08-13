//
//  Functions+MySQL.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var fromUnixtime: Self = .init("FROM_UNIXTIME")
    @available(*, deprecated, renamed: "fromUnixtime")
    public static var from_unixtime: Self { .fromUnixtime }
    public static var dateFormat: Self = .init("DATE_FORMAT")
    @available(*, deprecated, renamed: "dateFormat")
    public static var date_format: Self { .dateFormat }
}

extension Fn {
    public static func fromUnixtime(_ timeinterval: SwifQLable, _ format: String? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = timeinterval.parts
        if let format = format {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(o: .custom(format.singleQuotted))
        }
        return build(.fromUnixtime, body: parts)
    }

    @available(*, deprecated, renamed: "fromUnixtime(_:_:)")
    public static func from_unixtime(_ timeinterval: SwifQLable, _ format: String? = nil) -> SwifQLable {
        fromUnixtime(timeinterval, format)
    }

    /// Formats the date value according to the format string.
    /// # Example
    /// ```swift
    /// Fn.dateFormat(\User.createdAt, "%y-%m")
    /// ```
    /// # Result
    /// ```
    /// date_format(User.createdAt, '%y-%m')
    /// ```
    /// [Learn more →](https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format)
    /// [Learn more →](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format)
    public static func dateFormat(_ datetime: SwifQLable, _ format: String) -> SwifQLable {
        var parts: [SwifQLPart] = datetime.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(o: .custom(format.singleQuotted))
        return build(.dateFormat, body: parts)
    }

    @available(*, deprecated, renamed: "dateFormat(_:_:)")
    public static func date_format(_ datetime: SwifQLable, _ format: String) -> SwifQLable {
        dateFormat(datetime, format)
    }
}
