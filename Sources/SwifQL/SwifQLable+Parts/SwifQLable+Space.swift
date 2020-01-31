//
//  SwifQLable+Space.swift
//  SwifQL
//
//  Created by Mihael Isaev on 31.01.2020.
//

import Foundation

//MARK: simpel whitespace

extension SwifQLable {
    public var space: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .space)
        return SwifQLableParts(parts: parts)
    }
}
