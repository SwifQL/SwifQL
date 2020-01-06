//
//  Column.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04.01.2020.
//

import Foundation

public struct Column {
    public let paths: [String]
    
    public init (_ paths: String...) {
        self.paths = paths
    }
    
    public init (_ paths: [String]) {
        self.paths = paths
    }
}

extension Column: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: nil, paths: paths)]
    }
}

extension Column: KeyPathLastPath {
    public var lastPath: String { return paths.last ?? "" }
}
