//
//  StarProjectionParts.swift
//  SwifQL
//

import Foundation

/// Structural column names excluded from a star projection.
public struct SwifQLStarExcludePart: SwifQLPart, SwifQLSemanticRoleCarryingPart {
    public let columnNames: [String]
    public let semanticRole: SwifQLSemanticRole?

    init(columnNames: [String], semanticRole: SwifQLSemanticRole?) {
        self.columnNames = columnNames
        self.semanticRole = semanticRole
    }
}

/// Structural expression-and-target entries replacing columns in a star projection.
public struct SwifQLStarReplacePart: SwifQLPart, SwifQLSemanticRoleCarryingPart {
    public let entries: [StarReplacement]
    public let semanticRole: SwifQLSemanticRole?

    init(entries: [StarReplacement], semanticRole: SwifQLSemanticRole?) {
        self.entries = entries
        self.semanticRole = semanticRole
    }
}

/// Structural old-and-new column names in a star projection rename.
public struct SwifQLStarRenamePart: SwifQLPart, SwifQLSemanticRoleCarryingPart {
    public let entries: [StarRename]
    public let semanticRole: SwifQLSemanticRole?

    init(entries: [StarRename], semanticRole: SwifQLSemanticRole?) {
        self.entries = entries
        self.semanticRole = semanticRole
    }
}
