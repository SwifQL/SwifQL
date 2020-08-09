//
//  SwifQLable+Join.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: JOIN

extension SwifQLable {
    /// Join tables
    ///
    /// Example usage:
    /// - join with subquery
    /// ```swift
    /// let u = TableAlias("u")
    /// let subquery = |SwifQL
    ///     .select(Fn.count(\User.$id) => "users",
    ///             \User.$groupID => "groupID")
    ///     .from(User.table)
    ///     .groupBy(\User.$groupID)| => u
    /// let query = SwifQL.select(..., u.users)
    ///     .from(...)
    ///     .join(.left, subquery, on: u.groupID == \Group.$id)
    ///     .groupBy(..., u.users)
    /// ```
    ///
    /// - Parameters:
    ///   - mode: type of JOIN `JoinMode`
    ///   - expression: `Table` or `subquery`
    ///   - predicates: which columns should be used to make `JOIN`
    /// - Returns: `SwifQLable`
    public func join(_ mode: JoinMode = .none, _ expression: SwifQLable, on predicates: SwifQLable? = nil) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        let join = SwifQLJoinBuilder(mode, expression, on: predicates)
        parts.append(contentsOf: join.parts)
        return SwifQLableParts(parts: parts)
    }
}
