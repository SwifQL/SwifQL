//
//  Path+Identifier.swift
//  SwifQL
//

import Foundation

extension Path {
    /// A value-semantic database-object identifier with optional catalog and
    /// schema qualifiers.
    public struct Identifier {
        public let catalog: String?
        public let schema: String?
        public let name: String

        public init (_ name: String) {
            self.catalog = nil
            self.schema = nil
            self.name = name
        }

        public init (schema: String, name: String) {
            self.catalog = nil
            self.schema = schema
            self.name = name
        }

        public init (catalog: String, schema: String, name: String) {
            self.catalog = catalog
            self.schema = schema
            self.name = name
        }
    }
}

extension Path.Identifier: SwifQLable {
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        if let catalog {
            parts.append(SwifQLPartCatalog(catalog))
            parts.append(o: .period)
        }
        if let schema {
            parts.append(SwifQLPartSchema(schema))
            parts.append(o: .period)
        }
        parts.append(SwifQLPartIdentifier(name))
        return parts
    }
}
