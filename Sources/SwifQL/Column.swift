//
//  Column.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04.01.2020.
//

import Foundation

public struct Column {
    public let paths: [String]
    
    public init (_ paths: String...) {
        self.paths = paths
    }
    
    public init (_ paths: [String]) {
        self.paths = paths
    }
}

extension Column: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: nil, paths: paths)]
    }
}

extension Column: KeyPathLastPath {
    public var lastPath: String { return paths.last ?? "" }
}

public struct Table {
    public let name: String
    
    public init (_ name: String) {
        self.name = name
    }
    
    @discardableResult
    public func column(_ column: Column) -> TableWithColumn {
        return self.column(column.paths)
    }
    
    @discardableResult
    public func column(_ paths: String...) -> TableWithColumn {
        return column(paths)
    }
    
    @discardableResult
    public func column(_ paths: [String]) -> TableWithColumn {
        return TableWithColumn(table: name, paths: paths)
    }
}

extension Table: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: name, paths: [])]
    }
}

extension Table: KeyPathLastPath {
    public var lastPath: String { return "" }
}

public struct TableWithColumn {
    let table: String
    let paths: [String]
}

extension TableWithColumn: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: table, paths: paths)]
    }
}

extension TableWithColumn: KeyPathLastPath {
    public var lastPath: String { return paths.last ?? "" }
}
