//
//  KeyPathPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartKeyPath: SwifQLKeyPathable {

    // MARK: - Properties

    public var schema: String?
    public var table: String?
    public var paths: [String]
    public var asText: Bool

    // MARK: - Computed Properties

    public var column: SwifQLPartColumn { .init(paths[0]) }

    // MARK: - Initializers

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
}

extension SwifQLPartKeyPath: SwifQLable {
    public var parts: [SwifQLPart] {
        SwifQLableParts(parts: self).parts
    }
}

extension SwifQLPartKeyPath {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    return dialect.keyPath(self)
  }

}
