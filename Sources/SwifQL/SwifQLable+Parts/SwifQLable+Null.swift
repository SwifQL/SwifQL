//
//  SwifQLable+Null.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

//MARK: NULL

extension SwifQLable {
    public var null: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .null)
        return SwifQLableParts(parts: parts)
    }
}
