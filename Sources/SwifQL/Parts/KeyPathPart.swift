//
//  KeyPathPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartKeyPath: SwifQLKeyPathable {
    public var table: String?
    public var paths: [String]
    public var asText: Bool
    // FIXME: instead of `asText` here create some protocol for path which will support `asText` for each part of path
    public init (table: String? = nil, paths: String..., asText: Bool = false) {
        self.init(table: table, paths: paths, asText: asText)
    }
    public init (table: String? = nil, paths: [String], asText: Bool = false) {
        self.table = table
        self.paths = paths
        self.asText = asText
    }
}

extension SwifQLPartKeyPath: SwifQLable{
    public var parts: [SwifQLPart] {
        SwifQLableParts(parts: self).parts
    }
}
