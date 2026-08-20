//
//  HybridOperatorPart.swift
//  
//
//  Created by TierraCero on 5/30/23.
//

import Foundation

public struct SwifQLHybridRepresentationKey: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }

    public static let psql = Self(namespace: "swifql", name: "psql")
    public static let postgresql = psql
    public static let mysql = Self(namespace: "swifql", name: "mysql")
    public static let duck = Self(namespace: "swifql", name: "duck")
    public static let duckdb = duck
}

public struct SwifQLHybridOperator: SwifQLPart, Equatable {
    public let representations: [SwifQLHybridRepresentationKey: SwifQLPartOperator]

    public init(
        representations: [SwifQLHybridRepresentationKey: SwifQLPartOperator]
    ) {
        self.representations = representations
    }

    public init(_ psql: SwifQLPartOperator, _ mysql: SwifQLPartOperator) {
        self.init(
            representations: [
                .psql: psql,
                .mysql: mysql
            ]
        )
    }

    public init(
        _ psql: SwifQLPartOperator,
        _ mysql: SwifQLPartOperator,
        _ duck: SwifQLPartOperator?
    ) {
        var representations: [SwifQLHybridRepresentationKey: SwifQLPartOperator] = [
            .psql: psql,
            .mysql: mysql
        ]
        if let duck {
            representations[.duck] = duck
        }
        self.init(representations: representations)
    }

    public func representation(
        for key: SwifQLHybridRepresentationKey
    ) -> SwifQLPartOperator? {
        representations[key]
    }

    public static func == (
        lhs: SwifQLHybridOperator,
        rhs: SwifQLHybridOperator
    ) -> Bool {
        guard lhs.representations.count == rhs.representations.count else {
            return false
        }

        return lhs.representations.allSatisfy { key, representation in
            rhs.representations[key] == representation
        }
    }
}

extension SwifQLHybridOperator: SwifQLable {
    public var parts: [SwifQLPart] {
        [self]
    }
}
