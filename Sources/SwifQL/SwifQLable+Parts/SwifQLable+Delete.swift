//
//  SwifQLable+Delete.swift
//  SwifQL
//
//  Created by Mihael Isaev on 26/11/2018.
//

import Foundation

extension SwifQLable {
    public var delete: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .delete)
        return SwifQLableParts(parts: parts)
    }
    
    public func delete(from table: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .delete)
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: table.parts)
        return SwifQLableParts(parts: parts)
    }
}
