//
//  Path+Column.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04.01.2020.
//

import Foundation

extension Path {
    public struct Column {
        public let paths: [String]
        
        public init (_ paths: String...) {
            self.paths = paths
        }
        
        public init (_ paths: [String]) {
            self.paths = paths
        }
    }
}

extension Path.Column: SwifQLable {
    public var parts: [SwifQLPart] {
        [SwifQLPartKeyPath(table: nil, paths: paths)]
    }
}

extension Path.Column: KeyPathLastPath {
    public var lastPath: String { paths.last ?? "" }
}
