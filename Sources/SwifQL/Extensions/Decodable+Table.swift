//
//  Decodable+Table.swift
//  
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

extension Decodable {
    public static var table: SwifQLable {
        var parts: [SwifQLPart] = []
        if let schema = Self.self as? Schemable.Type {
            parts.append(SwifQLPartSchema(schema.schemaName))
            parts.append(o: .custom("."))
        }
        if let model = Self.self as? AnyTable.Type {
            parts.append(SwifQLPartTable(model.tableName))
        } else {
            parts.append(SwifQLPartTable(String(describing: Self.self)))
        }
        return SwifQLableParts(parts: parts)
    }
    
    /// Use it instead of MyTable.table
    /// when you want to reach result like
    /// ```sql
    /// someting as my_table_name
    /// ```
    /// instead of
    /// ```sql
    /// someting as my_achema.my_table_name
    /// ```
    public static var alias: SwifQLable {
        var parts: [SwifQLPart] = []
        if let model = Self.self as? AnyTable.Type {
            parts.append(SwifQLPartAlias(model.tableName))
        } else {
            parts.append(SwifQLPartAlias(String(describing: Self.self)))
        }
        return SwifQLableParts(parts: parts)
    }
}
