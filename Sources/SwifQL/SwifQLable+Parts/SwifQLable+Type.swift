//
//  SwifQLable+Type.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

extension SwifQLable {
    public var type: SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .type)
        return SwifQLableParts(parts: parts)
    }
    
    public func type(_ name: String) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .type)
        parts.append(o: .space)
        parts.append(o: .custom(name))
        return SwifQLableParts(parts: parts)
    }
}
