//
//  TablePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartTable: SwifQLPart {
    public var table: String
    public var schema: String?
    public init(_ table: String, schema: String? = nil) {
        self.table = table
        self.schema = schema
    }
}
