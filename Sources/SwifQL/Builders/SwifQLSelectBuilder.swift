//
//  SwifQLSelectBuilder.swift
//  App
//
//  Created by Mihael Isaev on 22/02/2019.
//

import Foundation

public class SwifQLSelectBuilder: QueryBuilderable {
    var select: [SwifQLable] = []
    var froms: [SwifQLable] = []
    
    public var queryParts = QueryParts()
    
    public init() {}
    
    public func copy() -> SwifQLSelectBuilder {
        let copy = SwifQLSelectBuilder()
        
        copy.select = select
        copy.froms = froms
        copy.queryParts = queryParts.copy()
        
        return copy
    }
    
    // MARK: Select
    
    @discardableResult
    public func select(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        select(item)
    }
    
    @discardableResult
    public func select(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        select.append(contentsOf: items)
        return self
    }
    
    // MARK: From
    
    @discardableResult
    public func from(_ item: SwifQLable...) -> SwifQLSelectBuilder {
        from(item)
    }
    
    @discardableResult
    public func from(_ items: [SwifQLable]) -> SwifQLSelectBuilder {
        froms.append(contentsOf: items)
        return self
    }
    
    public func build() -> SwifQLable {
        var query = SwifQL.select(select)
        if froms.count > 0 {
            query = query.from(froms)
        }
        return queryParts.appended(to: query)
    }
}
