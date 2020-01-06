//
//  Column.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04.01.2020.
//

import Foundation

public struct Column {
    public let table: String?
    public let paths: [String]
    
    public init (_ table: String? = nil, _ paths: String...) {
        self.table = table
        self.paths = paths
    }
    
    public init (_ table: String? = nil, _ paths: [String]) {
        self.table = table
        self.paths = paths
    }
}

extension Column: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: table, paths: paths)]
    }
}

extension Column: KeyPathLastPath {
    public var lastPath: String { return paths.last ?? "" }
}
