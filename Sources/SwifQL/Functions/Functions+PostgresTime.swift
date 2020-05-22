//
//  Functions+PostgresTime.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var age: Self = .init("age")
    public static var clock_timestamp: Self = .init("clock_timestamp")
    public static var current_date: Self = .init("current_date")
    public static var current_time: Self = .init("current_time")
    public static var current_timestamp: Self = .init("current_timestamp")
    public static var date_part: Self = .init("date_part")
    public static var date_trunc: Self = .init("date_trunc")
    public static var extract: Self = .init("extract")
    public static var isfinite: Self = .init("isfinite")
    public static var justify_days: Self = .init("justify_days")
    public static var justify_hours: Self = .init("justify_hours")
    public static var justify_interval: Self = .init("justify_interval")
    public static var localtime: Self = .init("localtime")
    public static var localtimestamp: Self = .init("localtimestamp")
    public static var make_date: Self = .init("make_date")
    public static var make_interval: Self = .init("make_interval")
    public static var make_time: Self = .init("make_time")
    public static var make_timestamp: Self = .init("make_timestamp")
    public static var make_timestamptz: Self = .init("make_timestamptz")
    public static var now: Self = .init("now")
    public static var statement_timestamp: Self = .init("statement_timestamp")
    public static var timeofday: Self = .init("timeofday")
    public static var transaction_timestamp: Self = .init("transaction_timestamp")
    public static var to_timestamp: Self = .init("to_timestamp")
}

extension Fn {
    /// Subtract arguments, producing a “symbolic” result that uses years and months, rather than just days
    /// # Example
    /// ```swift
    /// Fn.age("2001-04-10" => .timestamp, "1957-06-13" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 43 years 9 mons 27 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func age(_ timestamp1: SwifQLable, _ timestamp2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = timestamp1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: timestamp2.parts)
        return build(.age, body: parts)
    }
    
    /// Subtract from current_date (at midnight)
    /// # Example
    /// ```swift
    /// Fn.age("2001-04-10" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 43 years 8 mons 3 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func age(_ timestamp1: SwifQLable) -> SwifQLable {
        build(.age, body: timestamp1.parts)
    }
    
    /// Current date and time (changes during statement execution)
    /// # Example
    /// ```swift
    /// Fn.clock_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func clock_timestamp() -> SwifQLable {
        build(.clock_timestamp, body: [])
    }
    
    /// Current date
    /// # Example
    /// ```swift
    /// Fn.current_date
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static var current_date: SwifQLable {
        SwifQLableParts(parts: Name.current_date.part)
    }
    
    /// Current time of day
    /// # Example
    /// ```swift
    /// Fn.current_time
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func current_time(_ aggregateExpression: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: Name.current_time.part)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.current_timestamp
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func current_timestamp(_ aggregateExpression: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: Name.current_timestamp.part)
    }
    
    /// Get subfield (equivalent to extract)
    /// # Example with timestamp
    /// ```swift
    /// Fn.date_part("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.date_part("month", "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func date_part(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.date_part, body: parts)
    }
    
    /// Truncate to specified precision
    /// # Example with timestamp
    /// ```swift
    /// Fn.date_trunc("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 2001-02-16 20:00:00
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.date_trunc("hour", "2 days 3 hours 40 minutes" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 2 days 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC)
    public static func date_trunc(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.date_trunc, body: parts)
    }
    
    /// Get subfield
    /// # Example with timestamp
    /// ```swift
    /// Fn.extract(.hour, "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.extract(.month, "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func extract(_ field: ExtractFieldValue, from value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(safe: field.value)
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.extract, body: parts)
    }
    
    /// Get subfield
    /// # Example with timestamp
    /// ```swift
    /// Fn.extract("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.extract("month", "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func extract(_ field: SwifQLable, from value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = field.parts
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.extract, body: parts)
    }
    
    /// Test for finite date (not +/-infinity)
    /// # Example
    /// ```swift
    /// Fn.isfinite("4 hours" => .interval)
    /// ```
    /// # Result
    /// ```
    /// true
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func isfinite(_ interval: SwifQLable) -> SwifQLable {
        build(.isfinite, body: interval.parts)
    }
    
    /// Adjust interval so 30-day time periods are represented as months
    /// # Example
    /// ```swift
    /// Fn.justify_days("35 days" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 mon 5 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_days(_ interval: SwifQLable) -> SwifQLable {
        build(.justify_days, body: interval.parts)
    }
    
    /// Adjust interval so 24-hour time periods are represented as days
    /// # Example
    /// ```swift
    /// Fn.justify_hours("27 hours" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 day 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_hours(_ interval: SwifQLable) -> SwifQLable {
        build(.justify_hours, body: interval.parts)
    }
    
    /// Adjust interval using justify_days and justify_hours, with additional sign adjustments
    /// # Example
    /// ```swift
    /// Fn.justify_interval("1 mon -1 hour" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 29 days 23:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_interval(_ interval: SwifQLable) -> SwifQLable {
        build(.justify_interval, body: interval.parts)
    }
    
    /// Current time of day
    /// # Example
    /// ```swift
    /// Fn.localtime
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static var localtime: SwifQLable {
        SwifQLableParts(parts: Name.localtime.part)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.localtimestamp
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static var localtimestamp: SwifQLable {
        SwifQLableParts(parts: Name.localtimestamp.part)
    }
    
    /// Create date from year, month and day fields
    /// # Example
    /// ```swift
    /// Fn.make_date(2013, 7, 15)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_date(_ year: SwifQLable, _ month: SwifQLable, _ day: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        return build(.make_date, body: parts)
    }
    
    /// Create interval from years, months, weeks, days, hours, minutes and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_interval(days: 10)
    /// ```
    /// # Result
    /// ```
    /// 10 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_interval(years: SwifQLable? = nil,
                                                   months: SwifQLable? = nil,
                                                   weeks: SwifQLable? = nil,
                                                   days: SwifQLable? = nil,
                                                   hours: SwifQLable? = nil,
                                                   mins: SwifQLable? = nil,
                                                   secs: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let years = years {
            parts.append(o: .custom("years => "))
            parts.append(contentsOf: years.parts)
        }
        if let months = months {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("months => "))
            parts.append(contentsOf: months.parts)
        }
        if let weeks = weeks {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("weeks => "))
            parts.append(contentsOf: weeks.parts)
        }
        if let days = days {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("days => "))
            parts.append(contentsOf: days.parts)
        }
        if let hours = hours {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("hours => "))
            parts.append(contentsOf: hours.parts)
        }
        if let mins = mins {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("mins => "))
            parts.append(contentsOf: mins.parts)
        }
        if let secs = secs {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("secs => "))
            parts.append(contentsOf: secs.parts)
        }
        return build(.make_interval, body: parts)
    }
    
    /// Create time from hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_time(8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_time(_ hour: SwifQLable, _ min: SwifQLable, _ sec: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = hour.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        return build(.make_time, body: parts)
    }
    
    /// Create timestamp from year, month, day, hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_timestamp(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_timestamp(_ year: SwifQLable,
                                                       _ month: SwifQLable,
                                                       _ day: SwifQLable,
                                                       _ hour: SwifQLable,
                                                       _ min: SwifQLable,
                                                       _ sec: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: hour.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        return build(.make_timestamp, body: parts)
    }
    
    /// Create timestamp with time zone from year, month, day, hour, minute and seconds fields;
    /// if timezone is not specified, the current time zone is used
    /// # Example
    /// ```swift
    /// Fn.make_timestamptz(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5+01
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_timestamptz(_ year: SwifQLable,
                                                          _ month: SwifQLable,
                                                          _ day: SwifQLable,
                                                          _ hour: SwifQLable,
                                                          _ min: SwifQLable,
                                                          _ sec: SwifQLable,
                                                          _ timezone: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: hour.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        if let timezone = timezone {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: timezone.parts)
        }
        return build(.make_timestamptz, body: parts)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.now()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func now() -> SwifQLable {
        build(.now, body: [])
    }
    
    /// Current date and time (start of current statement)
    /// # Example
    /// ```swift
    /// Fn.statement_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func statement_timestamp() -> SwifQLable {
        build(.statement_timestamp, body: [])
    }
    
    /// Current date and time (like clock_timestamp, but as a text string)
    /// # Example
    /// ```swift
    /// Fn.timeofday()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func timeofday() -> SwifQLable {
        build(.timeofday, body: [])
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.transaction_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func transaction_timestamp() -> SwifQLable {
        build(.transaction_timestamp, body: [])
    }
    
    /// Convert Unix epoch (seconds since 1970-01-01 00:00:00+00) to timestamp
    /// # Example
    /// ```swift
    /// Fn.to_timestamp(1284352323)
    /// ```
    /// # Result
    /// ```
    /// 2010-09-13 04:32:03+00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func to_timestamp(_ value: SwifQLable) -> SwifQLable {
        build(.to_timestamp, body: value.parts)
    }
}
