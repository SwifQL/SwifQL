//
//  KeyPathPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartKeyPath: SwifQLKeyPathable {
    public var table: String?
    public var schema: String?
    public var paths: [String]
    public var asText: Bool
    // FIXME: instead of `asText` here create some protocol for path which will support `asText` for each part of path
    public init (table: String? = nil, schema: String? = nil, paths: String..., asText: Bool = false) {
        self.init(table: table, schema: schema, paths: paths, asText: asText)
    }
    public init (table: String? = nil, schema: String? = nil, paths: [String], asText: Bool = false) {
        self.table = table
        self.schema = schema
        self.paths = paths
        self.asText = asText
    }
    public var column: SwifQLPartColumn {
        .init(paths[0])
    }
}

extension SwifQLPartKeyPath: SwifQLable{
    public var parts: [SwifQLPart] {
        SwifQLableParts(parts: self).parts
    }
}
