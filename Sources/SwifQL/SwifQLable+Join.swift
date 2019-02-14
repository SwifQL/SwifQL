//
//  SwifQLable+Join.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: JOIN

public enum JoinMode: String {
    case left = "LEFT"
    case right = "RIGHT"
    case inner = "INNER"
    case outer = "OUTER"
}

extension SwifQLable {
    public func join(_ mode: JoinMode, _ table: SwifQLable, _ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
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
        return SwifQLableParts(parts: parts)
    }
}
