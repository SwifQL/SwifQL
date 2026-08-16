//
//  CatalogPart.swift
//  SwifQL
//

import Foundation

public struct SwifQLPartCatalog: SwifQLPart {
    public let name: String

    public init (_ name: String) {
        self.name = name
    }
}
