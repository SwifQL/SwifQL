//
//  SwifQLJoinBuilder.swift
//  App
//
//  Created by Mihael Isaev on 22/02/2019.
//

import Foundation

public enum JoinMode: String {
    case left = "LEFT"
    case right = "RIGHT"
    case inner = "INNER"
    case outer = "OUTER"
}

public struct SwifQLJoinBuilder: SwifQLable {
    let mode: JoinMode
    let table: SwifQLable
    let predicates: SwifQLable
    
    public init (_ mode: JoinMode, _ table: SwifQLable, _ predicates: SwifQLable) {
        self.mode = mode
        self.table = table
        self.predicates = predicates
    }
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom(mode.rawValue))
        parts.append(o: .space)
        parts.append(o: .join)
        parts.append(o: .space)
        parts.append(contentsOf: table.parts)
        parts.append(o: .space)
        parts.append(o: .on)
        parts.append(o: .space)
        parts.append(contentsOf: predicates.parts)
        return parts
    }
}
