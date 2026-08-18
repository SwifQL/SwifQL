import Foundation

extension SwifQLClauseOwner {
    /// The structural owner for DuckDB's simplified PIVOT grammar.
    public static let simplifiedPivot = Self(
        namespace: "swifql",
        name: "simplifiedPivot"
    )
}

extension SwifQLRenderScope {
    /// The bounded render scopes used by DuckDB's simplified PIVOT grammar.
    public static let simplifiedPivotOn =
        SwifQLClauseOwner.simplifiedPivot.renderScope(for: .on)

    public static let simplifiedPivotUsing =
        SwifQLClauseOwner.simplifiedPivot.renderScope(for: .using)

    /// Owner-derived scopes intentionally share the generic owner identity
    /// derivation used by GROUP BY and ORDER BY rendering.
    public static let simplifiedPivotGroupBy =
        SwifQLClauseOwner.simplifiedPivot.renderScope(for: .groupBy)

    public static let simplifiedPivotOrderBy =
        SwifQLClauseOwner.simplifiedPivot.renderScope(for: .orderBy)
}

extension SwifQLable {
    /// Appends DuckDB's simplified PIVOT source clause and establishes its
    /// ownership of its contextual ON, USING, GROUP BY, and ORDER BY clauses.
    public func pivot(_ source: SwifQLable) -> SwifQLable {
        let fragment = SwifQLableParts(parts:
            [SwifQLPartOperator.space, .custom("PIVOT"), .space] + source.parts
        )
        return _SwifQLStructuralComposition.append(
            self,
            parts: fragment.parts,
            owners: [
                .on: .simplifiedPivot,
                .using: .simplifiedPivot,
                .groupBy: .simplifiedPivot,
                .orderBy: .simplifiedPivot
            ]
        )
    }

    private func expression(
        _ expression: SwifQLable,
        scopedFor kind: SwifQLClauseKind
    ) -> SwifQLable {
        guard let owner = structuralOwner(for: kind) else {
            return expression
        }
        return expression.scoped(owner.renderScope(for: kind))
    }

    /// Appends SQL ON and applies context selected by the current root owner.
    public func on(_ expression: SwifQLable) -> SwifQLable {
        let scopedExpression = self.expression(expression, scopedFor: .on)
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.on,
            SwifQLPartOperator.space
        ]
        parts.append(contentsOf: scopedExpression.parts)
        return structurallyAppending(SwifQLableParts(parts: parts))
    }

    /// Appends simplified-PIVOT ON with a non-empty explicit IN list.
    public func on(
        _ expression: SwifQLable,
        in first: SwifQLable,
        _ rest: SwifQLable...
    ) -> SwifQLable {
        let scopedExpression = self.expression(expression, scopedFor: .on)
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.on,
            SwifQLPartOperator.space
        ]
        parts.append(contentsOf: scopedExpression.parts)
        parts.append(contentsOf: [
            SwifQLPartOperator.space,
            SwifQLPartOperator.in,
            SwifQLPartOperator.space,
            SwifQLPartOperator.openBracket
        ] as [SwifQLPart])

        for (index, value) in ([first] + rest).enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: value.parts)
        }
        parts.append(o: .closeBracket)

        return structurallyAppending(SwifQLableParts(parts: parts))
    }

    /// Appends SQL USING and applies context selected by the current root owner.
    public func using(_ expression: SwifQLable) -> SwifQLable {
        let scopedExpression = self.expression(expression, scopedFor: .using)
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.using,
            SwifQLPartOperator.space
        ]
        parts.append(contentsOf: scopedExpression.parts)
        return structurallyAppending(SwifQLableParts(parts: parts))
    }
}
