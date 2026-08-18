//
//  DML.swift
//  SwifQL
//

import Foundation

extension SwifQLable {
    /// Appends the exact SQL phrase `BY NAME`.
    public var byName: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("BY NAME"))
        return SwifQLableParts(parts: parts)
    }

    /// Builds the exact SQL statement `TRUNCATE <table>`.
    public func truncate(_ table: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("TRUNCATE"), .space)
        if let name = table as? String {
            parts.append(SwifQLPartTable(name))
        } else {
            parts.append(contentsOf: table.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
