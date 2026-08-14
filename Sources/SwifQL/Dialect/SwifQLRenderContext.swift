//
//  SwifQLRenderContext.swift
//  SwifQL
//

import Foundation

public struct SwifQLRenderScope: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }
}

public struct SwifQLRenderContext: Sendable {
    public let scopes: [SwifQLRenderScope]

    internal init(scopes: [SwifQLRenderScope] = []) {
        self.scopes = scopes
    }

    public var currentScope: SwifQLRenderScope? {
        scopes.last
    }

    public func contains(_ scope: SwifQLRenderScope) -> Bool {
        scopes.contains(scope)
    }

    internal func appending(_ scope: SwifQLRenderScope) -> Self {
        .init(scopes: scopes + [scope])
    }
}

struct SwifQLScopedPart: SwifQLPart {
    let scope: SwifQLRenderScope
    let parts: [SwifQLPart]
}
