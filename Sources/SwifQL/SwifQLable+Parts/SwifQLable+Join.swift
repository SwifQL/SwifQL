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

    /// Join tables using structural column names from the last path segment.
    public func join(
        _ expression: SwifQLable,
        using first: KeyPathLastPath,
        _ rest: KeyPathLastPath...
    ) -> SwifQLable {
        makeUsingJoin(.none, expression, columns: [first] + rest)
    }

    /// Join tables using structural column names from the last path segment.
    public func join(
        _ mode: JoinMode,
        _ expression: SwifQLable,
        using first: KeyPathLastPath,
        _ rest: KeyPathLastPath...
    ) -> SwifQLable {
        makeUsingJoin(mode, expression, columns: [first] + rest)
    }

    /// Array form for helper-driven composition. The SQL grammar requires at
    /// least one USING identifier.
    public func join(
        _ expression: SwifQLable,
        using columns: [KeyPathLastPath]
    ) -> SwifQLable {
        makeUsingJoin(.none, expression, columns: columns)
    }

    /// Array form for helper-driven composition. The SQL grammar requires at
    /// least one USING identifier.
    public func join(
        _ mode: JoinMode,
        _ expression: SwifQLable,
        using columns: [KeyPathLastPath]
    ) -> SwifQLable {
        makeUsingJoin(mode, expression, columns: columns)
    }

    private func makeUsingJoin(
        _ mode: JoinMode,
        _ expression: SwifQLable,
        columns: [KeyPathLastPath]
    ) -> SwifQLable {
        precondition(!columns.isEmpty, "JOIN USING requires at least one column")

        var parts = self.parts
        parts.appendSpaceIfNeeded()
        let join = SwifQLJoinBuilder(mode, expression, using: columns)
        parts.append(contentsOf: join.parts)
        return SwifQLableParts(parts: parts)
    }

}
