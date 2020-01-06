//
//  TableWithColumn.swift
//  SwifQL
//
//  Created by Mihael Isaev on 07.01.2020.
//

import Foundation

public struct TableWithColumn {
    let table: String
    let paths: [String]
}

extension TableWithColumn: SwifQLable {
    public var parts: [SwifQLPart] {
        return [SwifQLPartKeyPath(table: table, paths: paths)]
    }
}

extension TableWithColumn: KeyPathLastPath {
    public var lastPath: String { return paths.last ?? "" }
}
