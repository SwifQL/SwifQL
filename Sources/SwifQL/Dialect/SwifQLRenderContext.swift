//
//  SwifQLRenderContext.swift
//  SwifQL
//

import Foundation

public struct SwifQLRenderScope: Hashable, Sendable {
    public struct IdentityComponent: Hashable, Sendable {
        public let namespace: String
        public let name: String

        public init(namespace: String, name: String) {
            self.namespace = namespace
            self.name = name
        }
    }

    public let namespace: String
    public let name: String
    public let identityComponents: [IdentityComponent]

    public init(namespace: String, name: String) {
        self.init(namespace: namespace, name: name, identityComponents: [])
    }

    public init(
        namespace: String,
        name: String,
        identityComponents: [IdentityComponent]
    ) {
        self.namespace = namespace
        self.name = name
        self.identityComponents = identityComponents
    }
}

extension SwifQLRenderScope {
    public static let starPattern = SwifQLRenderScope(
        namespace: "swifql",
        name: "starPattern"
    )
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
