//
//  KeyPathPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartKeyPath: SwifQLKeyPathable {
    public var schema: String?
    public var table: String?
    public var paths: [String]
    public var asText: Bool
    // FIXME: instead of `asText` here create some protocol for path which will support `asText` for each part of path
    public init (schema: String? = nil, table: String? = nil, paths: String..., asText: Bool = false) {
        self.init(schema: schema, table: table, paths: paths, asText: asText)
    }
    public init (schema: String? = nil, table: String? = nil, paths: [String], asText: Bool = false) {
        self.schema = schema
        self.table = table
        self.paths = paths
        self.asText = asText
    }
    public var column: SwifQLPartColumn {
        .init(paths[0])
    }
}

extension SwifQLPartKeyPath: SwifQLable {
    public var parts: [SwifQLPart] {
        SwifQLableParts(parts: self).parts
    }
}
