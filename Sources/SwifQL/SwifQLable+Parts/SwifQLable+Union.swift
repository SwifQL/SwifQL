//
//  SwifQLable+Union.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: Union

extension SwifQLable {
    public var union: SwifQLable {
        let setResult = _SwifQLStructuralComposition.setResult(from: self)
        let fragmentParts: [SwifQLPart] = [
            SwifQLPartOperator.space,
            SwifQLPartOperator.union,
            SwifQLPartOperator.space
        ]
        let fragment = SwifQLableParts(parts: fragmentParts)
        return setResult.structurallyAppending(fragment)
    }

    public func union(_ selection: SwifQLable) -> SwifQLable {
        Union(self, selection)
    }

    public func union(all selection: SwifQLable) -> SwifQLable {
        Union(all: self, selection)
    }
}
