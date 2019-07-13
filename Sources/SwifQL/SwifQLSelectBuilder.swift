//
//  SwifQLSelectBuilder.swift
//  App
//
//  Created by Mihael Isaev on 22/02/2019.
//

import Foundation

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
        var query = SwifQL.select(select).from(froms)
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
            }
            query = query && $0.element
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
