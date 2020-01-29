//
//  SwifQLable+Drop.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

extension SwifQLable {
    public var drop: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .drop)
        return SwifQLableParts(parts: parts)
    }
}
