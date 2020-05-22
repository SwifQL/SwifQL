//
//  SwifQLable+Window.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

import Foundation

//MARK: Window

extension SwifQLable {
    /// [Learn more →](https://www.postgresqltutorial.com/postgresql-window-function/)
    public func window(_ expression: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .window)
        parts.append(o: .space)
        parts.append(contentsOf: expression.parts)
        return SwifQLableParts(parts: parts)
    }
    
    /// [Learn more →](https://www.postgresqltutorial.com/postgresql-window-function/)
    public func window(_ window: SwifQLable, as query: SwifQLable) -> SwifQLable {
        var parts = window.parts
        parts.append(contentsOf: window.parts)
        parts.append(o: .space)
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        parts.append(contentsOf: query.parts)
        parts.append(o: .closeBracket)
        return self.window(SwifQLableParts(parts: parts))
    }
    
    /// [Learn more →](https://www.postgresqltutorial.com/postgresql-window-function/)
    public func window(_ window: SwifQLable, asPartitionBy expression: SwifQLable, orderBy: OrderByItem...) -> SwifQLable {
        self.window(window, asPartitionBy: expression, orderBy: orderBy)
    }
    
    /// [Learn more →](https://www.postgresqltutorial.com/postgresql-window-function/)
    public func window(_ window: SwifQLable, asPartitionBy expression: SwifQLable, orderBy: [OrderByItem]) -> SwifQLable {
        var query = SwifQL.partition(by: expression)
        if orderBy.count > 0 {
            query = query.orderBy(orderBy)
        }
        return self.window(window, as: query)
    }
}
