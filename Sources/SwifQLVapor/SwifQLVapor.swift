//
//  SwifQLVapor.swift
//  SwifQL
//
//  Created by Mihael Isaev on 05/11/2018.
//

@_exported import SwifQL

#if canImport(Fluent)
import Fluent
//extension SwifQLable {
//    public func from(_ table: AnyModel.Type) -> SwifQLable {
//        var parts: [SwifQLPart] = self.parts
//        parts.appendSpaceIfNeeded()
//        parts.append(o: .from)
//        parts.append(o: .space)
//        parts.append(SwifQLPartTable(table.name))
//        return SwifQLableParts(parts: parts)
//    }
//}

postfix operator *
postfix public func *(table: AnyModel.Type) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(SwifQLPartTable(table.name))
    parts.append(o: .custom(".*"))
    parts.append(o: .space)
    return SwifQLableParts(parts: parts)
}
#endif
