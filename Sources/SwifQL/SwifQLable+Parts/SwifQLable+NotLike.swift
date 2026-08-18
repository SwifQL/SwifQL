//
//  SwifQLable+NotLike.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

// MARK: NOT LIKE

extension SwifQLable {
    /// Builds query with `NOT LIKE` parameter
    ///
    /// Example usage:
    /// ```swift
    /// let name = "John"
    /// SwifQL.select
    ///     // ...
    ///     .where((\User.$name).notLike(name))
    /// ```
    /// - Parameter part: `SwifQLable` element
    ///
    public func notLike(_ part: SwifQLable) -> SwifQLable {
        applyingPatternOperator(.notLike, to: part)
    }
}
