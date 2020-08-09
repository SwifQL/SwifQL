//
//  SwifQLable+Like.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: LIKE

extension SwifQLable {
    /// Builds query with `LIKE` parameter
    ///
    /// Example usage:
    /// ```swift
    /// let name = "John"
    /// SwifQL.select
    ///     // ...
    ///     .where((\User.$name).like(name))
    /// ```
    /// - Parameter part: `SwifQLable` element
    ///
    public func like(_ part: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .like)
        parts.append(o: .space)
        parts.append(contentsOf: part.parts)
        return SwifQLableParts(parts: parts)
    }
}
