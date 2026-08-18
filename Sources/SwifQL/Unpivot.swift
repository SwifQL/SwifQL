import Foundation

/// A grouped column set in DuckDB's simplified UNPIVOT grammar.
///
/// The value keeps the grouped columns and optional alias as semantic state;
/// parentheses and `AS` are emitted only when the value is rendered.
public struct UnpivotColumnSet: SwifQLable {
    public let columns: [[SwifQLPart]]
    public let alias: String?

    public init(
        _ first: SwifQLable,
        _ rest: SwifQLable...,
        as alias: KeyPathLastPath? = nil
    ) {
        columns = ([first] + rest).map(\.parts)
        self.alias = alias?.lastPath
    }

    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = [SwifQLPartOperator.openBracket]
        for (index, columnParts) in columns.enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: columnParts)
        }
        parts.append(o: .closeBracket)

        if let alias {
            parts.append(o: .space, .as, .space)
            parts.append(SwifQLPartAlias(alias))
        }
        return parts
    }
}

extension SwifQLClauseOwner {
    /// The structural owner for DuckDB's simplified UNPIVOT grammar.
    public static let simplifiedUnpivot = Self(
        namespace: "swifql",
        name: "simplifiedUnpivot"
    )
}

extension SwifQLRenderScope {
    /// The bounded render scope used by DuckDB's simplified UNPIVOT ORDER BY.
    public static let simplifiedUnpivotOrderBy =
        SwifQLClauseOwner.simplifiedUnpivot.renderScope(for: .orderBy)
}

extension SwifQLable {
    /// Appends DuckDB's simplified UNPIVOT source clause and establishes its
    /// ownership of the output ORDER BY clause.
    public func unpivot(_ source: SwifQLable) -> SwifQLable {
        let fragment = SwifQLableParts(parts:
            [SwifQLPartOperator.space, .custom("UNPIVOT"), .space] + source.parts
        )
        return _SwifQLStructuralComposition.append(
            self,
            parts: fragment.parts,
            owners: [.orderBy: .simplifiedUnpivot]
        )
    }

    private func unpivotOnExpression(_ expression: SwifQLable) -> SwifQLable {
        guard let owner = structuralOwner(for: .on) else {
            return expression
        }
        return expression.scoped(owner.renderScope(for: .on))
    }

    /// Appends a comma-separated simplified-UNPIVOT ON list while preserving
    /// the current generic ON owner, if one is present.
    public func on(_ first: SwifQLable, _ rest: SwifQLable...) -> SwifQLable {
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.on,
            SwifQLPartOperator.space
        ]

        for (index, expression) in ([first] + rest).enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: unpivotOnExpression(expression).parts)
        }

        return structurallyAppending(SwifQLableParts(parts: parts))
    }

    /// Appends one structural `NAME` identifier and one structural `VALUE`
    /// identifier to simplified UNPIVOT.
    public func into(
        name nameColumn: KeyPathLastPath,
        value valueColumn: KeyPathLastPath
    ) -> SwifQLable {
        appendUnpivotInto(
            name: nameColumn,
            values: [valueColumn]
        )
    }

    /// Appends one structural `NAME` identifier and a non-empty structural
    /// `VALUE` identifier list to simplified UNPIVOT.
    public func into(
        name nameColumn: KeyPathLastPath,
        values first: KeyPathLastPath,
        _ rest: KeyPathLastPath...
    ) -> SwifQLable {
        appendUnpivotInto(
            name: nameColumn,
            values: [first] + rest
        )
    }

    private func appendUnpivotInto(
        name nameColumn: KeyPathLastPath,
        values: [KeyPathLastPath]
    ) -> SwifQLable {
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.into,
            SwifQLPartOperator.space,
            SwifQLPartOperator.custom("NAME"),
            SwifQLPartOperator.space,
            SwifQLPartColumn(nameColumn.lastPath),
            SwifQLPartOperator.space,
            SwifQLPartOperator.custom("VALUE"),
            SwifQLPartOperator.space
        ]
        for (index, value) in values.enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(SwifQLPartColumn(value.lastPath))
        }
        return structurallyAppending(SwifQLableParts(parts: parts))
    }
}
