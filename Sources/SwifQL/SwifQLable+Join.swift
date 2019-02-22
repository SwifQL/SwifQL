//
//  SwifQLable+Join.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: JOIN

extension SwifQLable {
    public func join(_ mode: JoinMode, _ table: SwifQLable, _ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        let join = SwifQLJoinBuilder(mode, table, predicates)
        parts.append(contentsOf: join.parts)
        return SwifQLableParts(parts: parts)
    }
}
