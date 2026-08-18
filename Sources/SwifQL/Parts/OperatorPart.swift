//
//  OperatorPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLSemanticRole: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }

    public static let starProjection = Self(
        namespace: "swifql",
        name: "starProjection"
    )
}

public protocol SwifQLSemanticRoleCarryingPart: SwifQLPart {
    var semanticRole: SwifQLSemanticRole? { get }
}

public struct SwifQLPartOperator: SwifQLPart, Equatable, SwifQLSemanticRoleCarryingPart {
    var _value: String
    public let semanticRole: SwifQLSemanticRole?
    
    public init (_ value: String) {
        self._value = value
        self.semanticRole = nil
    }

    public init (_ value: String, semanticRole: SwifQLSemanticRole) {
        self._value = value
        self.semanticRole = semanticRole
    }

    public static func == (lhs: SwifQLPartOperator, rhs: SwifQLPartOperator) -> Bool {
        lhs._value == rhs._value
    }
}

extension SwifQLPartOperator: SwifQLable {
    public var parts: [SwifQLPart] {
        [self]
    }
}
