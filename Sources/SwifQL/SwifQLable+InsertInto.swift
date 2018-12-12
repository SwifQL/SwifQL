//
//  SwifQLable+InsertInto.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

extension SwifQLable {
    public func insertInto(_ table: SwifQLable, fields: SwifQLable...) -> SwifQLable {
        return insertInto(table, fields: fields)
    }
    public func insertInto(_ table: SwifQLable, fields: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .insertInto)
        parts.append(o: .space)
        parts.append(contentsOf: table.parts)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        for (i, v) in fields.compactMap({ v -> SwifQLPart? in
            if let part = v.parts.first as? SwifQLKeyPathable, let lastPath = part.paths.last {
                return SwifQLPartKeyPathLastPart(lastPath)
            }
            return nil
        }).enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(v)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
