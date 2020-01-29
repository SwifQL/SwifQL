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
        parts.append(o: .custom(type.name))
        return SwifQLableParts(parts: parts)
    }
}
