//
//  TableWithAliasPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartTableWithAlias: SwifQLPart {
    public var table: String
    public var alias: String
    public init (_ table: String, _ alias: String) {
        self.table = table
        self.alias = alias
    }
}
