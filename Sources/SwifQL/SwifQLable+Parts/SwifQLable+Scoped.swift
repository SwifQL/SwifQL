//
//  SwifQLable+Scoped.swift
//  SwifQL
//

import Foundation

extension SwifQLable {
    public func scoped(_ scope: SwifQLRenderScope) -> SwifQLable {
        SwifQLableParts(parts: [SwifQLScopedPart(scope: scope, parts: parts)])
    }
}
