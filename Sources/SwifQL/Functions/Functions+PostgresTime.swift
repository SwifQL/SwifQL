//
//  Functions+PostgresTime.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var age: Self = .init("age")
    public static var clockTimestamp: Self = .init("clock_timestamp")
    @available(*, deprecated, renamed: "clockTimestamp")
    public static var clock_timestamp: Self { .clockTimestamp }
    public static var currentDate: Self = .init("current_date")
    @available(*, deprecated, renamed: "currentDate")
    public static var current_date: Self { .currentDate }
    public static var currentTime: Self = .init("current_time")
    @available(*, deprecated, renamed: "currentTime")
    public static var current_time: Self { .currentTime }
    public static var currentTimestamp: Self = .init("current_timestamp")
    @available(*, deprecated, renamed: "currentTimestamp")
    public static var current_timestamp: Self { .currentTimestamp }
    public static var datePart: Self = .init("date_part")
    @available(*, deprecated, renamed: "datePart")
    public static var date_part: Self { .datePart }
    public static var dateTrunc: Self = .init("date_trunc")
    @available(*, deprecated, renamed: "dateTrunc")
    public static var date_trunc: Self { .dateTrunc }
    public static var extract: Self = .init("extract")
    public static var isfinite: Self = .init("isfinite")
    public static var justifyDays: Self = .init("justify_days")
    @available(*, deprecated, renamed: "justifyDays")
    public static var justify_days: Self { .justifyDays }
    public static var justifyHours: Self = .init("justify_hours")
    @available(*, deprecated, renamed: "justifyHours")
    public static var justify_hours: Self { .justifyHours }
    public static var justifyInterval: Self = .init("justify_interval")
    @available(*, deprecated, renamed: "justifyInterval")
    public static var justify_interval: Self { .justifyInterval }
    public static var localtime: Self = .init("localtime")
    public static var localtimestamp: Self = .init("localtimestamp")
    public static var makeDate: Self = .init("make_date")
    @available(*, deprecated, renamed: "makeDate")
    public static var make_date: Self { .makeDate }
    public static var makeInterval: Self = .init("make_interval")
    @available(*, deprecated, renamed: "makeInterval")
    public static var make_interval: Self { .makeInterval }
    public static var makeTime: Self = .init("make_time")
    @available(*, deprecated, renamed: "makeTime")
    public static var make_time: Self { .makeTime }
    public static var makeTimestamp: Self = .init("make_timestamp")
    @available(*, deprecated, renamed: "makeTimestamp")
    public static var make_timestamp: Self { .makeTimestamp }
    public static var makeTimestamptz: Self = .init("make_timestamptz")
    @available(*, deprecated, renamed: "makeTimestamptz")
    public static var make_timestamptz: Self { .makeTimestamptz }
    public static var now: Self = .init("now")
    public static var statementTimestamp: Self = .init("statement_timestamp")
    @available(*, deprecated, renamed: "statementTimestamp")
    public static var statement_timestamp: Self { .statementTimestamp }
    public static var timeofday: Self = .init("timeofday")
    public static var transactionTimestamp: Self = .init("transaction_timestamp")
    @available(*, deprecated, renamed: "transactionTimestamp")
    public static var transaction_timestamp: Self { .transactionTimestamp }
    public static var toTimestamp: Self = .init("to_timestamp")
    @available(*, deprecated, renamed: "toTimestamp")
    public static var to_timestamp: Self { .toTimestamp }
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
    /// Fn.clockTimestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func clockTimestamp() -> SwifQLable {
        build(.clockTimestamp, body: [])
    }

    @available(*, deprecated, renamed: "clockTimestamp()")
    public static func clock_timestamp() -> SwifQLable {
        clockTimestamp()
    }
    
    /// Current date
    /// # Example
    /// ```swift
    /// Fn.currentDate
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static var currentDate: SwifQLable {
        SwifQLableParts(parts: Name.currentDate.part)
    }

    @available(*, deprecated, renamed: "currentDate")
    public static var current_date: SwifQLable {
        currentDate
    }
    
    /// Current time of day
    /// # Example
    /// ```swift
    /// Fn.currentTime
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func currentTime(_ aggregateExpression: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: Name.currentTime.part)
    }

    @available(*, deprecated, renamed: "currentTime(_:)")
    public static func current_time(_ aggregateExpression: SwifQLable) -> SwifQLable {
        currentTime(aggregateExpression)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.currentTimestamp
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func currentTimestamp(_ aggregateExpression: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: Name.currentTimestamp.part)
    }

    @available(*, deprecated, renamed: "currentTimestamp(_:)")
    public static func current_timestamp(_ aggregateExpression: SwifQLable) -> SwifQLable {
        currentTimestamp(aggregateExpression)
    }
    
    /// Get subfield (equivalent to extract)
    /// # Example with timestamp
    /// ```swift
    /// Fn.datePart("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.datePart("month", "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func datePart(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.datePart, body: parts)
    }

    @available(*, deprecated, renamed: "datePart(_:_:)")
    public static func date_part(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        datePart(text, value)
    }
    
    /// Truncate to specified precision
    /// # Example with timestamp
    /// ```swift
    /// Fn.dateTrunc("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 2001-02-16 20:00:00
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.dateTrunc("hour", "2 days 3 hours 40 minutes" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 2 days 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC)
    public static func dateTrunc(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.dateTrunc, body: parts)
    }

    @available(*, deprecated, renamed: "dateTrunc(_:_:)")
    public static func date_trunc(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        dateTrunc(text, value)
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
    /// Fn.justifyDays("35 days" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 mon 5 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justifyDays(_ interval: SwifQLable) -> SwifQLable {
        build(.justifyDays, body: interval.parts)
    }

    @available(*, deprecated, renamed: "justifyDays(_:)")
    public static func justify_days(_ interval: SwifQLable) -> SwifQLable {
        justifyDays(interval)
    }
    
    /// Adjust interval so 24-hour time periods are represented as days
    /// # Example
    /// ```swift
    /// Fn.justifyHours("27 hours" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 day 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justifyHours(_ interval: SwifQLable) -> SwifQLable {
        build(.justifyHours, body: interval.parts)
    }

    @available(*, deprecated, renamed: "justifyHours(_:)")
    public static func justify_hours(_ interval: SwifQLable) -> SwifQLable {
        justifyHours(interval)
    }
    
    /// Adjust interval using justify_days and justify_hours, with additional sign adjustments
    /// # Example
    /// ```swift
    /// Fn.justifyInterval("1 mon -1 hour" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 29 days 23:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justifyInterval(_ interval: SwifQLable) -> SwifQLable {
        build(.justifyInterval, body: interval.parts)
    }

    @available(*, deprecated, renamed: "justifyInterval(_:)")
    public static func justify_interval(_ interval: SwifQLable) -> SwifQLable {
        justifyInterval(interval)
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
    /// Fn.makeDate(2013, 7, 15)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func makeDate(_ year: SwifQLable, _ month: SwifQLable, _ day: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        return build(.makeDate, body: parts)
    }

    @available(*, deprecated, renamed: "makeDate(_:_:_:)")
    public static func make_date(_ year: SwifQLable, _ month: SwifQLable, _ day: SwifQLable) -> SwifQLable {
        makeDate(year, month, day)
    }
    
    /// Create interval from years, months, weeks, days, hours, minutes and seconds fields
    /// # Example
    /// ```swift
    /// Fn.makeInterval(days: 10)
    /// ```
    /// # Result
    /// ```
    /// 10 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func makeInterval(years: SwifQLable? = nil,
                                                   months: SwifQLable? = nil,
                                                   weeks: SwifQLable? = nil,
                                                   days: SwifQLable? = nil,
                                                   hours: SwifQLable? = nil,
                                                   mins: SwifQLable? = nil,
                                                   secs: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let years = years {
            parts.append(o: .custom("years => "))
            if let number = years as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: years.parts)
            }
        }
        if let months = months {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("months => "))
            if let number = months as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: months.parts)
            }
        }
        if let weeks = weeks {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("weeks => "))
            if let number = weeks as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: weeks.parts)
            }
        }
        if let days = days {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("days => "))
            if let number = days as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: days.parts)
            }
        }
        if let hours = hours {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("hours => "))
            if let number = hours as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: hours.parts)
            }
        }
        if let mins = mins {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("mins => "))
            if let number = mins as? Int {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: mins.parts)
            }
        }
        if let secs = secs {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("secs => "))
            if let number = secs as? Int {
                parts.append(o: .custom("\(number)"))
            } else if let number = secs as? Double {
                parts.append(o: .custom("\(number)"))
            } else {
                parts.append(contentsOf: secs.parts)
            }
        }
        return build(.makeInterval, body: parts)
    }

    @available(*, deprecated, renamed: "makeInterval(years:months:weeks:days:hours:mins:secs:)")
    public static func make_interval(years: SwifQLable? = nil,
                                                   months: SwifQLable? = nil,
                                                   weeks: SwifQLable? = nil,
                                                   days: SwifQLable? = nil,
                                                   hours: SwifQLable? = nil,
                                                   mins: SwifQLable? = nil,
                                                   secs: SwifQLable? = nil) -> SwifQLable {
        makeInterval(years: years, months: months, weeks: weeks, days: days, hours: hours, mins: mins, secs: secs)
    }
    
    /// Create time from hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.makeTime(8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func makeTime(_ hour: SwifQLable, _ min: SwifQLable, _ sec: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = hour.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        return build(.makeTime, body: parts)
    }

    @available(*, deprecated, renamed: "makeTime(_:_:_:)")
    public static func make_time(_ hour: SwifQLable, _ min: SwifQLable, _ sec: SwifQLable) -> SwifQLable {
        makeTime(hour, min, sec)
    }
    
    /// Create timestamp from year, month, day, hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.makeTimestamp(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func makeTimestamp(_ year: SwifQLable,
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
        return build(.makeTimestamp, body: parts)
    }

    @available(*, deprecated, renamed: "makeTimestamp(_:_:_:_:_:_:)")
    public static func make_timestamp(_ year: SwifQLable,
                                                       _ month: SwifQLable,
                                                       _ day: SwifQLable,
                                                       _ hour: SwifQLable,
                                                       _ min: SwifQLable,
                                                       _ sec: SwifQLable) -> SwifQLable {
        makeTimestamp(year, month, day, hour, min, sec)
    }
    
    /// Create timestamp with time zone from year, month, day, hour, minute and seconds fields;
    /// if timezone is not specified, the current time zone is used
    /// # Example
    /// ```swift
    /// Fn.makeTimestamptz(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5+01
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func makeTimestamptz(_ year: SwifQLable,
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
        return build(.makeTimestamptz, body: parts)
    }

    @available(*, deprecated, renamed: "makeTimestamptz(_:_:_:_:_:_:_:)")
    public static func make_timestamptz(_ year: SwifQLable,
                                                          _ month: SwifQLable,
                                                          _ day: SwifQLable,
                                                          _ hour: SwifQLable,
                                                          _ min: SwifQLable,
                                                          _ sec: SwifQLable,
                                                          _ timezone: SwifQLable? = nil) -> SwifQLable {
        makeTimestamptz(year, month, day, hour, min, sec, timezone)
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
    /// Fn.statementTimestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func statementTimestamp() -> SwifQLable {
        build(.statementTimestamp, body: [])
    }

    @available(*, deprecated, renamed: "statementTimestamp()")
    public static func statement_timestamp() -> SwifQLable {
        statementTimestamp()
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
    /// Fn.transactionTimestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func transactionTimestamp() -> SwifQLable {
        build(.transactionTimestamp, body: [])
    }

    @available(*, deprecated, renamed: "transactionTimestamp()")
    public static func transaction_timestamp() -> SwifQLable {
        transactionTimestamp()
    }
    
    /// Convert Unix epoch (seconds since 1970-01-01 00:00:00+00) to timestamp
    /// # Example
    /// ```swift
    /// Fn.toTimestamp(1284352323)
    /// ```
    /// # Result
    /// ```
    /// 2010-09-13 04:32:03+00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func toTimestamp(_ value: SwifQLable) -> SwifQLable {
        build(.toTimestamp, body: value.parts)
    }

    @available(*, deprecated, renamed: "toTimestamp(_:)")
    public static func to_timestamp(_ value: SwifQLable) -> SwifQLable {
        toTimestamp(value)
    }
}
