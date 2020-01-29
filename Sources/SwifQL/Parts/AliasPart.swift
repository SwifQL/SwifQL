//
//  AliasPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartAlias: SwifQLPart {
    var alias: String
    
    init (_ alias: String) {
        self.alias = alias
    }
}
