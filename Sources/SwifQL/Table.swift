//
//  Table.swift
//  SwifQL
//
//  Created by Mihael Isaev on 07.01.2020.
//

import Foundation

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
    public var lastPath: String { "" }
}
