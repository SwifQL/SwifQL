//
//  Merge.swift
//  SwifQL
//

import Foundation

extension SwifQLable {
    /// Starts a generic SQL-shaped `MERGE INTO` statement.
    ///
    /// A String target is represented as a table part, matching the existing
    /// INSERT INTO target behavior and keeping table names structural.
    public func merge(into target: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("MERGE"), .space, .into, .space)
        if let name = target as? String {
            parts.append(SwifQLPartTable(name))
        } else {
            parts.append(contentsOf: target.parts)
        }
        return SwifQLableParts(parts: parts)
    }

    /// Builds `MERGE INTO ... USING ... ON ...` through the same incremental
    /// composition path as the individual helpers.
    public func merge(
        into target: SwifQLable,
        using source: SwifQLable,
        on condition: SwifQLable
    ) -> SwifQLable {
        merge(into: target).using(source).on(condition)
    }

    /// Appends DuckDB's structural `USING (<columns>)` shorthand.
    public func using(
        columns first: KeyPathLastPath,
        _ rest: KeyPathLastPath...
    ) -> SwifQLable {
        using(columns: [first] + rest)
    }

    /// Appends DuckDB's structural `USING (<columns>)` shorthand.
    public func using(columns: [KeyPathLastPath]) -> SwifQLable {
        precondition(!columns.isEmpty, "MERGE USING requires at least one column")

        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .using, .space, .openBracket)
        for (index, column) in columns.enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(SwifQLPartColumn(column.lastPath))
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }

    /// Appends an unconditional `WHEN MATCHED` branch predicate.
    public var whenMatched: SwifQLable {
        appendingMergeClause([.when, .space, .custom("MATCHED")])
    }

    /// Appends a conditional `WHEN MATCHED` branch predicate.
    public func whenMatched(and condition: SwifQLable) -> SwifQLable {
        appendingMergeClause(
            [.when, .space, .custom("MATCHED")],
            condition: condition
        )
    }

    /// Appends an unconditional `WHEN NOT MATCHED` branch predicate.
    public var whenNotMatched: SwifQLable {
        appendingMergeClause([
            .when, .space, .not, .space, .custom("MATCHED")
        ])
    }

    /// Appends a conditional `WHEN NOT MATCHED` branch predicate.
    public func whenNotMatched(and condition: SwifQLable) -> SwifQLable {
        appendingMergeClause(
            [.when, .space, .not, .space, .custom("MATCHED")],
            condition: condition
        )
    }

    /// Appends an unconditional `WHEN NOT MATCHED BY SOURCE` branch predicate.
    public var whenNotMatchedBySource: SwifQLable {
        appendingMergeClause([
            .when, .space, .not, .space, .custom("MATCHED"), .space,
            .by, .space, .custom("SOURCE")
        ])
    }

    /// Appends a conditional `WHEN NOT MATCHED BY SOURCE` branch predicate.
    public func whenNotMatchedBySource(and condition: SwifQLable) -> SwifQLable {
        appendingMergeClause(
            [
                .when, .space, .not, .space, .custom("MATCHED"), .space,
                .by, .space, .custom("SOURCE")
            ],
            condition: condition
        )
    }

    /// Appends an unconditional `WHEN NOT MATCHED BY TARGET` branch predicate.
    public var whenNotMatchedByTarget: SwifQLable {
        appendingMergeClause([
            .when, .space, .not, .space, .custom("MATCHED"), .space,
            .by, .space, .custom("TARGET")
        ])
    }

    /// Appends a conditional `WHEN NOT MATCHED BY TARGET` branch predicate.
    public func whenNotMatchedByTarget(and condition: SwifQLable) -> SwifQLable {
        appendingMergeClause(
            [
                .when, .space, .not, .space, .custom("MATCHED"), .space,
                .by, .space, .custom("TARGET")
            ],
            condition: condition
        )
    }

    /// Appends the exact SQL branch action separator `THEN`.
    public var then: SwifQLable {
        appendingMergeClause([.then])
    }

    /// Appends DuckDB's bare `merge_action` returning expression.
    ///
    /// This intentionally renders an identifier, not `merge_action()`.
    public var mergeAction: SwifQLable {
        appendingMergeClause([.custom("merge_action")])
    }

    private func appendingMergeClause(
        _ clause: [SwifQLPartOperator],
        condition: SwifQLable? = nil
    ) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        clause.forEach { parts.append($0) }
        if let condition {
            parts.append(o: .space, .and, .space)
            parts.append(contentsOf: condition.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
