//
//  SchemableTable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12.04.2020.
//

import Foundation

@dynamicMemberLookup
public protocol SchemableTable: Tableable, Schemable {
    subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> SwifQLable { get }
}

// MARK: Optional

extension SchemableTable {
    public subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> SwifQLable {
        guard let k = keyPath as? Keypathable else { return "<keyPath should conform to Keypathable>" }
        return SwifQLPartKeyPath(schema: Self.schemaName, table: k.table, paths: k.paths)
    }
}
