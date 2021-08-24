//
//  SwifQLable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

// MARK: - SwifQLable Protocols

public protocol SwifQLable: CustomStringConvertible {
    var parts: [SwifQLPart] { get }
}

extension SwifQLable {
    public var description: String { prepare(.psql).plain }
}

// MARK: - SwifQLPart Protocols

public protocol SwifQLPart {
    func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String
}

public extension SwifQLPart {
    func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String { return "" }
}

// MARK: - SwifQLKeyPathable Protocols

public protocol SwifQLKeyPathable: SwifQLPart {
    var schema: String? { get }
    var table: String? { get }
    var paths: [String] { get }
}

extension SwifQLable {

    /// Good choice only for super short and universal queries like `BEGIN;`, `ROLLBACK;`, `COMMIT;`
    public func prepare() -> SwifQLPrepared {
        prepare(.any)
    }

    public func prepare(_ dialect: SQLDialect) -> SwifQLPrepared {
      return SwifQLPrepared(self, dialect)
    }

}

// MARK: - SwifQLableParts

public struct SwifQLableParts: SwifQLable {

    // MARK: - Properties

    public var parts: [SwifQLPart]

    // MARK: - Initializers

    public init (parts: [SwifQLPart]) { self.parts = parts }
    public init (parts: SwifQLPart...) { self.init(parts: parts) }

}

