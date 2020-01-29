//
//  SwifQLable+Key.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

//MARK: KEY

extension SwifQLable {
    public var key: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .key)
        return SwifQLableParts(parts: parts)
    }
}
