//
//  QueryBuilder.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 19.12.2019.
//

import Foundation

public protocol QueryBuilderItemable {
    var values: [SwifQLable] { get }
}
public struct QueryBuilderItem: SwifQLable {
    public let parts: [SwifQLPart]
    public let values: [SwifQLable]
    public init (_ values: [SwifQLable]? = nil) {
        var parts: [SwifQLPart] = []
        if let values = values {
            values.forEach {
                parts.append(contentsOf: $0.parts)
            }
        }
        self.parts = parts
        self.values = values ?? []
    }
}
@_functionBuilder public struct QueryBuilder {
    public typealias Block = () -> SwifQLable
    
    /// Builds an empty view from an block containing no statements, `{ }`.
    public static func buildBlock() -> SwifQLable { QueryBuilderItem() }
    
    /// Passes a single view written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
    public static func buildBlock(_ attr: SwifQLable) -> SwifQLable {
        QueryBuilderItem([attr])
    }
    
    /// Passes a single view written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
    public static func buildBlock(_ attrs: SwifQLable...) -> SwifQLable {
        QueryBuilderItem(attrs)
    }
    
    /// Passes a single view written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
    public static func buildBlock(_ attrs: [SwifQLable]) -> SwifQLable {
        QueryBuilderItem(attrs)
    }
    
    /// Provides support for "if" statements in multi-statement closures, producing an `Optional` view
    /// that is visible only when the `if` condition evaluates `true`.
    public static func buildIf(_ content: SwifQLable?) -> SwifQLable {
        guard let content = content else { return QueryBuilderItem() }
        return QueryBuilderItem([content])
    }
    
    /// Provides support for "if" statements in multi-statement closures, producing
    /// ConditionalContent for the "then" branch.
    public static func buildEither(first: SwifQLable) -> SwifQLable {
        QueryBuilderItem([first])
    }

    /// Provides support for "if-else" statements in multi-statement closures, producing
    /// ConditionalContent for the "else" branch.
    public static func buildEither(second: SwifQLable) -> SwifQLable {
        QueryBuilderItem([second])
    }
}
