//
//  Alias.swift
//  SwifQL
//
//  Created by Mihael Isaev on 13.04.2020.
//

import Foundation

@dynamicMemberLookup
public class SwifQLAlias: SwifQLable {
    public var name: String

    public init (_ name: String) {
        self.name = name
    }
    
    public subscript(dynamicMember path: String) -> SwifQLable {
        Path.Table(name).column(path)
    }
    
    public var parts: [SwifQLPart] {
        [SwifQLPartAlias(name)]
    }
}
