//
//  SwifQLable+As.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

//MARK: AS

extension SwifQLable {
    public var `as`: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .as)
        return SwifQLableParts(parts: parts)
    }
    
    public func `as`(_ type: Type) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(SwifQLPartType(type))
        return SwifQLableParts(parts: parts)
    }

    public func `as`(_ expression: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .as, .space)
        parts.append(contentsOf: expression.parts)
        return SwifQLableParts(parts: parts)
    }
}
