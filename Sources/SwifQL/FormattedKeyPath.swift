//
//  FormattedKeyPath.swift
//  SwifQL
//
//  Created by Mihael Isaev on 20/06/2019.
//

import Foundation

/// Formatting keypath
public typealias FKP = FormattedKeyPath

public struct FormattedKeyPath {
    let _table: String
    let _schema: String?
    let _paths: [String]
    
    public init <T: Tableable>(_ table: T.Type, _ paths: String...) {
        _table = table.tableName
        _schema = table.schemaName
        _paths = paths
    }
    
    public init <T: Tableable>(_ table: T.Type, _ paths: [String]) {
        _table = table.tableName
        _schema = table.schemaName
        _paths = paths
    }
    
    public init (_ table: String, _ schema: String? = nil, _ paths: String...) {
        _table = table
        _schema = schema
        _paths = paths
    }
    
    public init (_ table: String, _ schema: String? = nil, _ paths: [String]) {
        _table = table
        _schema = schema
        _paths = paths
    }
}

extension FormattedKeyPath: SwifQLable {
    public var parts: [SwifQLPart] {
        [SwifQLPartKeyPath(table: _table, schema: _schema, paths: _paths)]
    }
}

extension FormattedKeyPath: KeyPathLastPath {
    public var lastPath: String { _paths.last ?? "" }
}

extension Tableable {
    /// Manual key path. Alias to `\User.something`
    public static func manualKeyPath(_ paths: String...) -> FormattedKeyPath {
        manualKeyPath(paths)
    }
    
    /// Manual key path. Alias to `\User.something`
    public static func manualKeyPath(_ paths: [String]) -> FormattedKeyPath {
        FormattedKeyPath(tableName, schemaName, paths)
    }
    
    /// Manual key path. Alias to `\User.something`
    public static func mkp(_ paths: String...) -> FormattedKeyPath {
        manualKeyPath(paths)
    }
    
    /// Manual key path. Alias to `\User.something`
    public static func mkp(_ paths: [String]) -> FormattedKeyPath {
        manualKeyPath(paths)
    }
}
