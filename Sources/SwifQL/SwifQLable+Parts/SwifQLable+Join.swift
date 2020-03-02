//
//  SwifQLable+Join.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: JOIN

extension SwifQLable {
    public func join(_ mode: JoinMode = .none, _ expression: SwifQLable, on predicates: SwifQLable? = nil) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        let join = SwifQLJoinBuilder(mode, expression, on: predicates)
        parts.append(contentsOf: join.parts)
        return SwifQLableParts(parts: parts)
    }
}
