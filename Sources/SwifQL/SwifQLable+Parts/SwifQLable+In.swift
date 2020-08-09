//
//  SwifQLable+In.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: IN

extension SwifQLable {
    /// Builds query with `IN` parameter
    ///
    /// Example usage:
    /// ```swift
    /// SwifQL.select
    ///     // ...
    ///     .where((\User.$id).in(aUserID, bUserID))
    /// ```
    /// - Parameter items: comma separated list of  `SwifQLable` elements
    ///
    public func `in`(_ items: SwifQLable...) -> SwifQLable {
        `in`(items)
    }

    /// Builds query with `IN` parameter
    ///
    /// Example usage:
    /// ```swift
    /// SwifQL.select
    ///     // ...
    ///     .where((\User.$id).in(userIDsArray))
    /// ```
    /// - Parameter items: Array of `[SwifQLable]` elements
    ///
    public func `in`(_ items: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .in)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
