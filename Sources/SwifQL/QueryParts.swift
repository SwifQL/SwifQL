//
//  QueryParts.swift
//  SwifQL
//
//  Created by Mihael Isaev on 18.05.2020.
//

import Foundation

public class QueryParts {
    public var joins: [SwifQLJoinBuilder] = []
    public var wheres: [SwifQLable] = []
    public var groupBy: [SwifQLable] = []
    public var havings: [SwifQLable] = []
    public var orderBy: [OrderByItem] = []
    public var offset: Int?
    public var limit: Int?
    
    public init () {}
    
    public func copy() -> QueryParts {
        let copy = QueryParts()
        
        copy.joins = joins
        copy.wheres = wheres
        copy.groupBy = groupBy
        copy.havings = havings
        copy.orderBy = orderBy
        copy.offset = offset
        copy.limit = limit
        
        return copy
    }
    
    public func buildQuery() -> SwifQLable {
        var query = SwifQL
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
    
    public func appended(to query: SwifQLable) -> SwifQLable {
        let q = buildQuery()
        guard q.parts.count > 0 else { return query }
        return query.addQuery(q)
    }
}
