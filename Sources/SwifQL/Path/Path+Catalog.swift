//
//  Path+Catalog.swift
//  SwifQL
//

import Foundation

extension Path {
    public struct Catalog {
        public let name: String

        public init (_ name: String) {
            self.name = name
        }

        @discardableResult
        public func schema(_ schema: String) -> CatalogWithSchema {
            .init(catalog: name, schema: schema)
        }
    }

    public struct CatalogWithSchema {
        public let catalog: String
        public let schema: String

        public init (catalog: String, schema: String) {
            self.catalog = catalog
            self.schema = schema
        }

        @discardableResult
        public func table(_ table: Table) -> CatalogWithSchemaAndTable {
            self.table(table.name)
        }

        @discardableResult
        public func table(_ table: String) -> CatalogWithSchemaAndTable {
            .init(catalog: catalog, schema: schema, table: table)
        }
    }

    public struct CatalogWithSchemaAndTable {
        public let catalog: String
        public let schema: String
        public let table: String

        public init (catalog: String, schema: String, table: String) {
            self.catalog = catalog
            self.schema = schema
            self.table = table
        }

        @discardableResult
        public func column(_ column: Column) -> CatalogWithSchemaAndTableAndColumn {
            self.column(column.paths)
        }

        @discardableResult
        public func column(_ paths: String...) -> CatalogWithSchemaAndTableAndColumn {
            column(paths)
        }

        @discardableResult
        public func column(_ paths: [String]) -> CatalogWithSchemaAndTableAndColumn {
            .init(catalog: catalog, schema: schema, table: table, paths: paths)
        }
    }

    public struct CatalogWithSchemaAndTableAndColumn {
        public let catalog: String
        public let schema: String
        public let table: String
        public let paths: [String]

        public init (catalog: String, schema: String, table: String, paths: [String]) {
            self.catalog = catalog
            self.schema = schema
            self.table = table
            self.paths = paths
        }
    }
}

extension Path.Catalog: SwifQLable {
    public var parts: [SwifQLPart] {
        [SwifQLPartCatalog(name)]
    }
}

extension Path.CatalogWithSchema: SwifQLable {
    public var parts: [SwifQLPart] {
        [
            SwifQLPartCatalog(catalog),
            SwifQLPartOperator.period,
            SwifQLPartSchema(schema)
        ]
    }
}

extension Path.CatalogWithSchemaAndTable: SwifQLable {
    public var parts: [SwifQLPart] {
        [
            SwifQLPartCatalog(catalog),
            SwifQLPartOperator.period,
            SwifQLPartTable(schema: schema, table: table)
        ]
    }
}

extension Path.CatalogWithSchemaAndTableAndColumn: SwifQLable {
    public var parts: [SwifQLPart] {
        [
            SwifQLPartCatalog(catalog),
            SwifQLPartOperator.period,
            SwifQLPartKeyPath(schema: schema, table: table, paths: paths)
        ]
    }
}

extension Path.CatalogWithSchemaAndTableAndColumn: KeyPathLastPath {
    public var lastPath: String { paths.last ?? "" }
}
