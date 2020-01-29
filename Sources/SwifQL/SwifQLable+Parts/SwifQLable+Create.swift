//
//  SwifQLable+CreateType.swift
//  
//
//  Created by Mihael Isaev on 23.01.2020.
//

import Foundation

extension SwifQLable {
    public var create: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .create)
        return SwifQLableParts(parts: parts)
    }
}
