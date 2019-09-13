//
//  SwifQLable+OrderBy.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

public struct OrderByItem: SwifQLable {
    // MARK: - Elements
    
    let elements: [SwifQLable]
    
    // MARK: - Direction
    
    enum Direction {
        case asc, desc
        
        var `operator`: SwifQLPartOperator {
            switch self {
            case .asc: return .asc
            case .desc: return .desc
            }
        }
    }
    
    let direction: Direction
    
    // MARK: - Nulls
    
    public enum Nulls {
        case first, last
        
        var `operator`: SwifQLPartOperator {
            switch self {
            case .first: return .first
            case .last: return .last
            }
        }
    }
    
    let nulls: Nulls?
    
    // MARK: - Public statis initializers
    
    // MARK: Ascending
    
    public static func asc(_ elements: SwifQLable...) -> OrderByItem {
        return asc(elements, nulls: nil)
    }
    
    public static func asc(_ elements: [SwifQLable]) -> OrderByItem {
        return asc(elements, nulls: nil)
    }
    
    public static func asc(_ elements: SwifQLable..., nulls: Nulls?) -> OrderByItem {
        return asc(elements, nulls: nulls)
    }
    
    public static func asc(_ elements: [SwifQLable], nulls: Nulls?) -> OrderByItem {
        return OrderByItem(elements: elements, direction: .asc, nulls: nulls)
    }
    
    // MARK: Descending
    
    public static func desc(_ elements: SwifQLable...) -> OrderByItem {
        return desc(elements, nulls: nil)
    }
    
    public static func desc(_ elements: [SwifQLable]) -> OrderByItem {
        return desc(elements, nulls: nil)
    }
    
    public static func desc(_ elements: SwifQLable..., nulls: Nulls?) -> OrderByItem {
        return desc(elements, nulls: nulls)
    }
    
    public static func desc(_ elements: [SwifQLable], nulls: Nulls?) -> OrderByItem {
        return OrderByItem(elements: elements, direction: .desc, nulls: nulls)
    }
    
    // MARK: - SwifQLable
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        for (i, v) in elements.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .space)
        parts.append(o: direction.operator)
        if let nulls = nulls {
            parts.append(o: .space)
            parts.append(o: .nulls)
            parts.append(o: .space)
            parts.append(o: nulls.operator)
        }
        return parts
    }
}

//MARK: ORDER BY

extension SwifQLable {
    /// Order query results by some rows ascending or descending
    /// # Simple example
    /// ```swift
    /// .orderBy(.asc(\User.email), .desc(\User.firstName))
    /// ```
    /// # Raw SQL (in PostgreSQL syntax)
    /// ```sql
    /// ORDER BY "User"."email" ASC, "User"."firstName" DESC
    /// ```
    /// # Raw SQL (in MySQL syntax)
    /// ```sql
    /// ORDER BY "User"."email" ASC, "User"."firstName" DESC
    /// ```
    ///
    /// # PostgreSQL nulls example
    /// ```swift
    /// .orderBy(.asc(\User.email, nulls: .first), .desc(\User.firstName, nulls: .last))
    /// ```
    /// # Raw SQL
    /// ```sql
    /// ORDER BY "User"."email" ASC NULLS FIRST, "User"."firstName" DESC NULLS LAST
    /// ```
    ///
    /// # MySQL nulls example
    /// ```swift
    /// .orderBy(.asc(\User.email == nil, \User.email), .desc(\User.firstName != nil, \User.firstName))
    /// ```
    /// # Raw SQL
    /// ```sql
    /// ORDER BY User.email IS NULL, User.email ASC, User.firstName IS NOT NULL, User.firstName DESC
    /// ```
    ///
    public func orderBy(_ fields: OrderByItem...) -> SwifQLable {
        return orderBy(fields)
    }
    
    public func orderBy(_ fields: [OrderByItem]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .orderBy)
        parts.append(o: .space)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return SwifQLableParts(parts: parts)
    }
}
