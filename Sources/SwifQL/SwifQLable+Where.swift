//
//  SwifQLable+Where.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

//MARK: Where

extension SwifQLable {
    public var `where`: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .where)
        return SwifQLableParts(parts: parts)
    }
    public func `where`(_ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .where)
        parts.append(o: .space)
        parts.append(contentsOf: predicates.parts)
        return SwifQLableParts(parts: parts)
    }
    public func `where`(@QueryBuilder block: QueryBuilder.Block) -> SwifQLable {
        if let value = block() as? QueryBuilderItem {
            return `where`(value.values)
        } else {
            return `where`(block())
        }
    }
}
