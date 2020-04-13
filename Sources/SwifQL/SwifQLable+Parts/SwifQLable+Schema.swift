//
//  SwifQLable+Schema.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12.04.2020.
//

import Foundation

extension SwifQLable {
    public var schema: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .schema)
        return SwifQLableParts(parts: parts)
    }
    
    public func schema(_ name: String) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .schema)
        parts.append(o: .space)
        parts.append(SwifQLPartSchema(name))
        return SwifQLableParts(parts: parts)
    }
}
