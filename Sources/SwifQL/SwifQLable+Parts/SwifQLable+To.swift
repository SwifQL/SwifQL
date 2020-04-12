//
//  SwifQLable+To.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12.04.2020.
//

import Foundation

extension SwifQLable {
    public var to: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .to)
        return SwifQLableParts(parts: parts)
    }
}
