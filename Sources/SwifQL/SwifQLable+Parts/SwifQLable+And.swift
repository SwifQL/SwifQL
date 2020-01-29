//
//  SwifQLable+And.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: AND

extension SwifQLable {
    public var and: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .and)
        return SwifQLableParts(parts: parts)
    }
    
    public func and(_ predicate: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .and)
        parts.append(o: .space)
        parts.append(contentsOf: predicate.parts)
        return SwifQLableParts(parts: parts)
    }
}
