import Foundation

private func groupingExpressionParts(
    _ keyword: String,
    expressions: [[SwifQLPart]]
) -> [SwifQLPart] {
    var parts: [SwifQLPart] = [
        SwifQLPartOperator.custom(keyword),
        SwifQLPartOperator.openBracket
    ]

    for (index, expression) in expressions.enumerated() {
        if index > 0 {
            parts.append(o: .comma, .space)
        }
        parts.append(contentsOf: expression)
    }

    parts.append(o: .closeBracket)
    return parts
}

private func groupingSetParts(_ sets: [[[SwifQLPart]]]) -> [SwifQLPart] {
    var parts: [SwifQLPart] = [
        SwifQLPartOperator.custom("GROUPING"),
        SwifQLPartOperator.space,
        SwifQLPartOperator.custom("SETS"),
        SwifQLPartOperator.space,
        SwifQLPartOperator.openBracket
    ]

    for (setIndex, set) in sets.enumerated() {
        if setIndex > 0 {
            parts.append(o: .comma, .space)
        }
        parts.append(o: .openBracket)
        for (expressionIndex, expression) in set.enumerated() {
            if expressionIndex > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: expression)
        }
        parts.append(o: .closeBracket)
    }

    parts.append(o: .closeBracket)
    return parts
}

/// A GROUP BY grouping-set expression.
public struct GroupingSets: SwifQLable {
    private let sets: [[[SwifQLPart]]]

    public init(_ sets: [SwifQLable]...) {
        self.init(sets)
    }

    public init(_ sets: [[SwifQLable]]) {
        self.sets = sets.map { set in
            set.map(\.parts)
        }
    }

    public var parts: [SwifQLPart] {
        groupingSetParts(sets)
    }
}

/// A ROLLUP grouping expression for the existing GROUP BY clause.
public struct Rollup: SwifQLable {
    private let expressions: [[SwifQLPart]]

    public init(_ expression: SwifQLable, _ expressions: SwifQLable...) {
        self.expressions = ([expression] + expressions).map(\.parts)
    }

    public init(_ expressions: [SwifQLable]) {
        self.expressions = expressions.map(\.parts)
    }

    public var parts: [SwifQLPart] {
        groupingExpressionParts("ROLLUP", expressions: expressions)
    }
}

/// A CUBE grouping expression for the existing GROUP BY clause.
public struct Cube: SwifQLable {
    private let expressions: [[SwifQLPart]]

    public init(_ expression: SwifQLable, _ expressions: SwifQLable...) {
        self.expressions = ([expression] + expressions).map(\.parts)
    }

    public init(_ expressions: [SwifQLable]) {
        self.expressions = expressions.map(\.parts)
    }

    public var parts: [SwifQLPart] {
        groupingExpressionParts("CUBE", expressions: expressions)
    }
}
