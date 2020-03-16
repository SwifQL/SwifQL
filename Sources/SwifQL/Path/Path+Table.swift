//
//  Path+Table.swift
//  SwifQL
//
//  Created by Mihael Isaev on 07.01.2020.
//

import Foundation

extension Path {
    public struct Table {
        public let name: String
        public let schema: String?
        
        public init (_ name: String, schema: String? = nil) {
            self.schema = schema
            self.name = name
        }
        
        @discardableResult
        public func column(_ column: Column) -> TableWithColumn {
            self.column(column.paths)
        }
        
        @discardableResult
        public func column(_ paths: String...) -> TableWithColumn {
            column(paths)
        }
        
        @discardableResult
        public func column(_ paths: [String]) -> TableWithColumn {
            TableWithColumn(table: name, schema: schema, paths: paths)
        }
    }
}

extension Path.Table: SwifQLable {
    public var parts: [SwifQLPart] {
        [SwifQLPartTable(name, schema: schema)]
    }
}

extension Path.Table: KeyPathLastPath {
    public var lastPath: String { "" }
}
