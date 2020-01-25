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
    
    public func `as`(_ type: Type) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(o: .custom(type.name))
        return SwifQLableParts(parts: parts)
    }
    
    public var `function`: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .function)
        return SwifQLableParts(parts: parts)
    }
}
