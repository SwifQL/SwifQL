//
//  Functions+Window.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var row_number: Self = .init("row_number")
    public static var rank: Self = .init("rank")
    public static var dense_rank: Self = .init("dense_rank")
    public static var percent_rank: Self = .init("percent_rank")
    public static var cume_dist: Self = .init("cume_dist")
    public static var ntile: Self = .init("ntile")
    public static var lag: Self = .init("lag")
    public static var lead: Self = .init("lead")
    public static var first_value: Self = .init("first_value")
    public static var last_value: Self = .init("last_value")
    public static var nth_value: Self = .init("nth_value")
}

extension Fn {
    /// Number of the current row within its partition, counting from 1
    ///
    /// # Example
    /// ```swift
    /// Fn.row_number()
    /// ```
    /// # Result
    /// ```
    /// row_number()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func row_number() -> SwifQLable {
        build(.row_number, body: [])
    }
    
    /// Rank of the current row with gaps
    /// same as row_number of its first peer
    ///
    /// # Example
    /// ```swift
    /// Fn.rank()
    /// ```
    /// # Result
    /// ```
    /// rank()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func rank() -> SwifQLable {
        build(.rank, body: [])
    }
    
    /// Rank of the current row without gaps
    /// this function counts peer groups
    ///
    /// # Example
    /// ```swift
    /// Fn.dense_rank()
    /// ```
    /// # Result
    /// ```
    /// dense_rank()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func dense_rank() -> SwifQLable {
        build(.dense_rank, body: [])
    }
    
    /// Relative rank of the current row: (rank - 1) / (total partition rows - 1)
    ///
    /// # Example
    /// ```swift
    /// Fn.percent_rank()
    /// ```
    /// # Result
    /// ```
    /// percent_rank()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func percent_rank() -> SwifQLable {
        build(.percent_rank, body: [])
    }
    
    /// Cumulative distribution: (number of partition rows preceding or peer with current row) / total partition rows
    ///
    /// # Example
    /// ```swift
    /// Fn.cume_dist()
    /// ```
    /// # Result
    /// ```
    /// cume_dist()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func cume_dist() -> SwifQLable {
        build(.cume_dist, body: [])
    }
    
    /// Integer ranging from 1 to the argument value, dividing the partition as equally as possible
    ///
    /// # Example
    /// ```swift
    /// Fn.ntile()
    /// ```
    /// # Result
    /// ```
    /// ntile()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func ntile(_ num_buckets: SwifQLable) -> SwifQLable {
        build(.ntile, body: num_buckets.parts)
    }
    
    /// Returns `value` evaluated at the row that is `offset` rows before the current row within the partition
    /// if there is no such row, instead return `default` (which must be of the same type as `value`).
    /// Both `offset` and `default` are evaluated with respect to the current row.
    /// If omitted, `offset` defaults to 1 and `default` to null
    ///
    /// # Example
    /// ```swift
    /// Fn.lag()
    /// ```
    /// # Result
    /// ```
    /// lag()
    /// ```
    /// [Examples →](https://www.postgresqltutorial.com/postgresql-lag-function/)
    ///
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func lag(_ value: SwifQLable, _ offset: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = value.parts
        if let offset = offset {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: offset.parts)
        }
        return build(.lag, body: parts)
    }
    
    /// Returns value evaluated at the row that is `offset` rows after the current row within the partition
    /// if there is no such row, instead return `default` (which must be of the same type as `value`).
    /// Both `offset` and `default` are evaluated with respect to the current row.
    /// If omitted, `offset` defaults to 1 and `default` to null
    ///
    /// # Example
    /// ```swift
    /// Fn.lead()
    /// ```
    /// # Result
    /// ```
    /// lead()
    /// ```
    /// [Examples →](https://www.postgresqltutorial.com/postgresql-lead-function/)
    ///
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func lead(_ value: SwifQLable, _ offset: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = value.parts
        if let offset = offset {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: offset.parts)
        }
        return build(.lead, body: parts)
    }
    
    /// Returns value evaluated at the row that is the first row of the window frame
    ///
    /// # Example
    /// ```swift
    /// Fn.first_value()
    /// ```
    /// # Result
    /// ```
    /// first_value()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func first_value(_ value: SwifQLable) -> SwifQLable {
        build(.first_value, body: value.parts)
    }
    
    /// Returns value evaluated at the row that is the last row of the window frame
    ///
    /// # Example
    /// ```swift
    /// Fn.last_value()
    /// ```
    /// # Result
    /// ```
    /// last_value()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func last_value(_ value: SwifQLable) -> SwifQLable {
        build(.last_value, body: value.parts)
    }
    
    /// Returns `value` evaluated at the row that is the `nth` row of the window frame (counting from 1)
    /// null if no such row
    ///
    /// # Example
    /// ```swift
    /// Fn.nth_value()
    /// ```
    /// # Result
    /// ```
    /// nth_value()
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-window.html)
    public static func nth_value(_ value: SwifQLable, _ nth: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: nth.parts)
        return build(.nth_value, body: parts)
    }
}
