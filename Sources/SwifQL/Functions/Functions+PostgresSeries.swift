//
//  Functions+PostgresSeries.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var generate_series: Self = .init("generate_series")
}

extension Fn {
    /// Generate series
    /// # Example
    /// ```swift
    /// Fn.generate_series(1, 4)
    /// Fn.generate_series(1, 4, 2)
    /// Fn.generate_series('2019-10-01', '2019-10-04', '1 day')
    /// ```
    /// # Result
    /// ```
    /// 1, 2, 3, 4
    /// 1, 3
    /// 2019-10-01, 2019-10-02, 2019-10-03, 2019-10-04
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-srf.html)
    public static func generate_series(_ start: SwifQLable, _ stop: SwifQLable, _ step: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = start.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: stop.parts)
        if let step = step {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: step.parts)
        }
        return build(.generate_series, body: parts)
    }
}
