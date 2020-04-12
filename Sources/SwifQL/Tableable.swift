//
//  Tableable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation

public protocol AnyTableable: Codable {
    /// This model's unique name. By default, this property is set to a `String` describing the type.
    static var tableName: String { get }
}

extension AnyTableable {
    public static var tableName: String {
        String(describing: Self.self)
    }
    
    public static func column(_ paths: String...) -> Path.SchemaWithTableAndColumn {
        Path.Schema((Self.self as? Schemable.Type)?.schemaName).table(tableName).column(paths)
    }
    
    public static func inSchema(_ name: String) -> Schema<Self> {
        .init(name)
    }
    
    public static func inSchema(_ schema: Schemable.Type) -> Schema<Self> {
        .init(schema.schemaName)
    }
}

@dynamicMemberLookup
public protocol Tableable: AnyTableable {
    static subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> SwifQLable { get }
}

extension Tableable {
    public static subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> SwifQLable {
        guard let k = keyPath as? Keypathable else { return "<keyPath should conform to Keypathable>" }
        let schema: String? = (Self.self as? Schemable.Type)?.schemaName
        return SwifQLPartKeyPath(schema: schema, table: Self.tableName, paths: k.paths)
    }
}
