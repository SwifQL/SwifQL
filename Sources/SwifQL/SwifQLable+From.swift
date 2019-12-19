//
//  SwifQLable+From.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 13/11/2018.
//

import Foundation

//MARK: From

extension SwifQLable {
    public func from(_ tables: SwifQLable...) -> SwifQLable {
        return from(tables)
    }
    public func from(_ tables: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .from)
        parts.append(o: .space)
        for (i, v) in tables.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
    public func from(@QueryBuilder block: QueryBuilder.Block) -> SwifQLable {
        if let value = block() as? QueryBuilderItem {
            from(value.values)
        } else {
            from(block())
        }
    }
}

//extension SwifQLable {
//    public var From: SwifQLable {
//        var parts: [SwifQLPart] = self.parts
//        parts.append(o: .space)
//        parts.append(o: .from)
//        parts.append(o: .space)
//        return SwifQLableParts(parts: parts)
//    }
//    public func From<T>(_ table: T.Type) -> SwifQLable {
//        var parts: [SwifQLPart] = self.parts
//        parts.append(o: .space)
//        parts.append(o: .from)
//        parts.append(o: .space)
//        parts.append(SwifQLPartTable(String(describing: table)))
//        return SwifQLableParts(parts: parts)
//    }
//    public func From<T>(_ alias: FQAlias<T>) -> SwifQLable {
//        var parts: [SwifQLPart] = self.parts
//        parts.append(o: .space)
//        parts.append(o: .from)
//        parts.append(o: .space)
//        parts.append(contentsOf: alias.parts)
//        return SwifQLableParts(parts: parts)
//    }
//}
