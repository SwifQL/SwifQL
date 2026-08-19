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

    public func union(byName selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .unionByName)
    }

    public func union(allByName selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .unionAllByName)
    }

    public func intersect(_ selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .intersect)
    }

    public func intersect(all selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .intersectAll)
    }

    public func except(_ selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .except)
    }

    public func except(all selection: SwifQLable) -> SwifQLable {
        _SwifQLSetOperationBuilder(self, selection, kind: .exceptAll)
    }
}
