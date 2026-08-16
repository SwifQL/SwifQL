//
//  SwifQLable+GroupBy.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: GROUP BY

extension SwifQLable {
    public func groupBy(_ fields: SwifQLable...) -> SwifQLable {
        groupBy(fields)
    }
    public func groupBy(_ fields: [SwifQLable]) -> SwifQLable {
        let clause = SwifQLGroupByPart(
            owner: structuralOwner(for: .groupBy),
            fields: fields.map(\.parts)
        )
        let fragment = SwifQLableParts(parts: [SwifQLPartOperator.space, clause])
        return structurallyAppending(fragment)
    }
}
