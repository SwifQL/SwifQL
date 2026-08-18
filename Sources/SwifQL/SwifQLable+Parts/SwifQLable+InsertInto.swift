//
//  SwifQLable+InsertInto.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

extension SwifQLable {
    public subscript (newColumns items: NewColumn...) -> SwifQLable {
        newColumns(items)
    }
    
    public subscript (newColumns items: [NewColumn]) -> SwifQLable {
        newColumns(items)
    }
    
    public func newColumns(_ items: NewColumn...) -> SwifQLable {
        newColumns(items)
    }
    
    public func newColumns(_ items: [NewColumn]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .openBracket)
        items.enumerated().forEach { i, v in
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
    
    public subscript (fields items: SwifQLable...) -> SwifQLable {
        fields(items)
    }
    
    public subscript (fields items: [SwifQLable]) -> SwifQLable {
        fields(items)
    }
    
    /// Represent just a list of fields in round brackets separated by comma
    public func fields(_ items: SwifQLable...) -> SwifQLable {
        fields(items)
    }
    
    /// Represent just a list of fields in round brackets separated by comma
    public func fields(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .openBracket)
        items.compactMap { v -> SwifQLPart? in
            if let part = v.parts.first as? SwifQLKeyPathable, let lastPath = part.paths.last {
                return SwifQLPartColumn(lastPath)
            } else if let name = v as? String {
                return SwifQLPartColumn(name)
            }
            return nil
        }
        .enumerated()
        .forEach { i, v in
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
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        if let name = item as? String {
            parts.append(SwifQLPartTable(name))
        } else {
            parts.append(contentsOf: item.parts)
        }
        return SwifQLableParts(parts: parts)
    }
    
    public func insertInto(_ table: SwifQLable, fields: SwifQLable...) -> SwifQLable {
        insertInto(table, fields: fields)
    }
    public func insertInto(_ table: SwifQLable, fields: [SwifQLable]) -> SwifQLable {
        insert.into[table: table].fields(fields)
    }

    /// Appends `INSERT INTO` and a target table without synthesizing an empty
    /// field list.
    public func insertInto(_ table: SwifQLable) -> SwifQLable {
        insert.into[table: table]
    }

    private func insertWithExactConflictPrefix(
        _ prefix: SwifQLPartOperator,
        into table: SwifQLable,
        fields: [SwifQLable]?
    ) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .insert, .space, .or, .space, prefix, .space, .into, .space)
        if let name = table as? String {
            parts.append(SwifQLPartTable(name))
        } else {
            parts.append(contentsOf: table.parts)
        }
        let query = SwifQLableParts(parts: parts)
        guard let fields else { return query }
        return query.fields(fields)
    }

    /// Appends the exact SQL identity `INSERT OR IGNORE INTO`.
    public func insertOrIgnoreInto(_ table: SwifQLable) -> SwifQLable {
        insertWithExactConflictPrefix(.custom("IGNORE"), into: table, fields: nil)
    }

    /// Appends the exact SQL identity `INSERT OR IGNORE INTO` with a target
    /// column list.
    public func insertOrIgnoreInto(_ table: SwifQLable, fields: SwifQLable...) -> SwifQLable {
        insertOrIgnoreInto(table, fields: fields)
    }

    /// Appends the exact SQL identity `INSERT OR IGNORE INTO` with a target
    /// column list.
    public func insertOrIgnoreInto(_ table: SwifQLable, fields: [SwifQLable]) -> SwifQLable {
        insertWithExactConflictPrefix(.custom("IGNORE"), into: table, fields: fields)
    }

    /// Appends the exact SQL identity `INSERT OR REPLACE INTO`.
    public func insertOrReplaceInto(_ table: SwifQLable) -> SwifQLable {
        insertWithExactConflictPrefix(.custom("REPLACE"), into: table, fields: nil)
    }

    /// Appends the exact SQL identity `INSERT OR REPLACE INTO` with a target
    /// column list.
    public func insertOrReplaceInto(_ table: SwifQLable, fields: SwifQLable...) -> SwifQLable {
        insertOrReplaceInto(table, fields: fields)
    }

    /// Appends the exact SQL identity `INSERT OR REPLACE INTO` with a target
    /// column list.
    public func insertOrReplaceInto(_ table: SwifQLable, fields: [SwifQLable]) -> SwifQLable {
        insertWithExactConflictPrefix(.custom("REPLACE"), into: table, fields: fields)
    }
}
