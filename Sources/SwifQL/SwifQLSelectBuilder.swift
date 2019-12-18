//
//  SwifQLSelectBuilder.swift
//  App
//
//  Created by Mihael Isaev on 22/02/2019.
//

import Foundation

public protocol QueryBuilderItemable {
    var values: [SwifQLable] { get }
}
public struct QueryBuilderItem: SwifQLable {
    public let parts: [SwifQLPart]
    public init (_ values: [SwifQLable]? = nil) {
        var parts: [SwifQLPart] = []
        if let values = values {
            values.forEach {
                parts.append(contentsOf: $0.parts)
            }
        }
        self.parts = parts
    }
}
@_functionBuilder public struct QueryBuilder {
    public typealias SingleView = () -> SwifQLable
    
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

public class SwifQLSelectBuilder {
    var select: [SwifQLable] = []
    var froms: [SwifQLable] = []
    var joins: [SwifQLJoinBuilder] = []
    var wheres: [SwifQLable] = []
    var groupBy: [SwifQLable] = []
    var havings: [SwifQLable] = []
    var orderBy: [OrderByItem] = []
    var offset: Int?
    var limit: Int?
    
    public init() {}
    
    public func copy() -> SwifQLSelectBuilder {
        let copy = SwifQLSelectBuilder()
        
        copy.select = select
        copy.froms = froms
        copy.joins = joins
        copy.wheres = wheres
        copy.groupBy = groupBy
        copy.havings = havings
        copy.orderBy = orderBy
        copy.offset = offset
        copy.limit = limit
        
        return copy
    }
    // MARK: Select
    
    @discardableResult
    public func select(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        return select(item)
    }
    
    @discardableResult
    public func select(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        select.append(contentsOf: items)
        return self
    }
    
    // MARK: From
    
    @discardableResult
    public func from(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        return from(item)
    }
    
    @discardableResult
    public func from(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        froms.append(contentsOf: items)
        return self
    }
    
    // MARK: Join
    
    @discardableResult
    public func join(_ mode: JoinMode, _ table: SwifQLable, on predicates: SwifQLable) -> SwifQLSelectBuilder {
        return join(SwifQLJoinBuilder(mode, table, on: predicates))
    }
    
    @discardableResult
    public func join(_ item: SwifQLJoinBuilder...) -> SwifQLSelectBuilder {
        return join(item)
    }
    
    @discardableResult
    public func join(_ items: [SwifQLJoinBuilder]) -> SwifQLSelectBuilder {
        joins.append(contentsOf: items)
        return self
    }
    
    // MARK: Where
    
    @discardableResult
    public func `where`(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        return `where`(item)
    }
    
    @discardableResult
    public func `where`(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        wheres.append(contentsOf: items)
        return self
    }
    
    // MARK: Group by
    
    @discardableResult
    public func groupBy(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        return groupBy(item)
    }
    
    @discardableResult
    public func groupBy(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        groupBy.append(contentsOf: items)
        return self
    }
    
    // MARK: Having
    
    @discardableResult
    public func having(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        return having(item)
    }
    
    @discardableResult
    public func having(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        havings.append(contentsOf: items)
        return self
    }
    
    // MARK: Order by
    
    @discardableResult
    public func orderBy(_ item: OrderByItem...) -> SwifQLSelectBuilder {
        return orderBy(item)
    }
    
    @discardableResult
    public func orderBy(_ items: [OrderByItem]) -> SwifQLSelectBuilder {
        orderBy.append(contentsOf: items)
        return self
    }
    
    // MARK: Offset
    
    @discardableResult
    public func offset(_ value: Int) -> SwifQLSelectBuilder {
        offset = value
        return self
    }
    
    // MARK: Limit
    
    @discardableResult
    public func limit(_ value: Int) -> SwifQLSelectBuilder {
        limit = value
        return self
    }
    @discardableResult
    public func limit(_ offset: Int,_ limit: Int) -> SwifQLSelectBuilder {
        self.limit = limit
        self.offset = offset
        return self
    }
    
    public func build() -> SwifQLable {
        var query = SwifQL.select(select)
        if froms.count > 0 {
            query = query.from(froms)
        }
        joins.forEach {
            query = query.join($0.mode, $0.table, on: $0.predicates)
        }
        wheres.enumerated().forEach {
            if $0.offset == 0 {
                query = query.where($0.element)
            } else {
                query = query && $0.element
            }
        }
        if groupBy.count > 0 {
            query = query.groupBy(groupBy)
        }
        havings.enumerated().forEach {
            if $0.offset == 0 {
                query = query.having($0.element)
            } else {
                query = query && $0.element
            }
        }
        if orderBy.count > 0 {
            query = query.orderBy(orderBy)
        }
        if let limit = limit {
            query = query.limit(limit)
        }
        if let offset = offset {
            query = query.offset(offset)
        }
        return query
    }
}
