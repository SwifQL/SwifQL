//
//  SwifQLable+InsertInto.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

extension SwifQLable {
    public subscript (fields items: SwifQLable...) -> SwifQLable {
        get { return fields(items) }
    }
    
    public subscript (fields items: [SwifQLable]) -> SwifQLable {
        get { return fields(items) }
    }
    
    /// Represent just a list of fields in round brackets separated by comma
    public func fields(_ items: SwifQLable...) -> SwifQLable {
        return fields(items)
    }
    
    /// Represent just a list of fields in round brackets separated by comma
    public func fields(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .openBracket)
        for (i, v) in items.compactMap({ v -> SwifQLPart? in
            if let part = v.parts.first as? SwifQLKeyPathable, let lastPath = part.paths.last {
                return SwifQLPartKeyPathLastPart(lastPath)
            } else if let name = v as? String {
                return SwifQLPartKeyPathLastPart(name)
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
    
    public var insert: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .insert)
        return SwifQLableParts(parts: parts)
    }
    
    public var into: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .into)
        return SwifQLableParts(parts: parts)
    }
    
    public subscript (table item: SwifQLable) -> SwifQLable {
        get {
            var parts: [SwifQLPart] = self.parts
            parts.appendSpaceIfNeeded()
            if let name = item as? String {
                parts.append(SwifQLPartTable(name))
            } else {
                parts.append(contentsOf: item.parts)
            }
            return SwifQLableParts(parts: parts)
        }
    }
    
    public func insertInto(_ table: SwifQLable, fields: SwifQLable...) -> SwifQLable {
        return insertInto(table, fields: fields)
    }
    public func insertInto(_ table: SwifQLable, fields: [SwifQLable]) -> SwifQLable {
        return insert.into[table: table].fields(fields)
    }
}
