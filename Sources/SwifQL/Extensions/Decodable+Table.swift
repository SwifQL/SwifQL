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
}
