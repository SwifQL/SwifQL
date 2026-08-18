//
//  StarModifiers.swift
//  SwifQL
//

import Foundation

/// One expression-and-target entry for a star `REPLACE` modifier.
public struct StarReplacement: SwifQLable {
    public let expressionParts: [SwifQLPart]
    public let columnName: String

    public init(_ expression: SwifQLable, as column: KeyPathLastPath) {
        expressionParts = expression.parts
        columnName = column.lastPath
    }

    public var parts: [SwifQLPart] {
        var parts = expressionParts
        parts.append(o: .space, .as, .space)
        parts.append(SwifQLPartColumn(columnName))
        return parts
    }
}

/// One old-and-new structural-name entry for a star `RENAME` modifier.
public struct StarRename: SwifQLable {
    public let oldColumnName: String
    public let newColumnName: String

    public init(_ oldColumn: KeyPathLastPath, to newColumn: KeyPathLastPath) {
        oldColumnName = oldColumn.lastPath
        newColumnName = newColumn.lastPath
    }

    public var parts: [SwifQLPart] {
        [
            SwifQLPartColumn(oldColumnName),
            SwifQLPartOperator.space,
            SwifQLPartOperator.as,
            SwifQLPartOperator.space,
            SwifQLPartColumn(newColumnName)
        ]
    }
}
