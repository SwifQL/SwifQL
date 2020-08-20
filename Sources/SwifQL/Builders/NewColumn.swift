//
//  NewColumn.swift
//  
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

public class NewColumn: SwifQLable {
    var name: String
    var type: Type
    var `default`: SwifQLable?
    var constraints: [SwifQLable] = []
    
    public init(_ name: String, _ type: Type) {
        self.name = name
        self.type = type
    }
    
    @discardableResult
    public func `default`(constant v: Any) -> Self {
        `default` = SwifQLableParts(parts: SwifQLPartSafeValue(v))
        return self
    }
    
    @discardableResult
    public func `default`(expression: SwifQLable) -> Self {
        `default` = expression
        return self
    }
    
    @discardableResult
    public func `default`(sequence name: String) -> Self {
        `default` = SwifQLableParts(parts: Op.custom(name))
        return self
    }
    
    @discardableResult
    public func constraint(expression: SwifQLable) -> Self {
        constraints.append(expression)
        return self
    }
    
    @discardableResult
    public func primaryKey() -> Self {
        constraints.append(SwifQL.primary.key)
        return self
    }
    
    @discardableResult
    public func unique() -> Self {
        constraints.append(SwifQL.unique)
        return self
    }
    
    @discardableResult
    public func notNull() -> Self {
        constraints.append(SwifQL.not.null)
        return self
    }
    
    @discardableResult
    public func check(name: String? = nil, _ expression: SwifQLable) -> Self {
        guard expression.parts.count > 0 else { return self }
        var parts: [SwifQLPart] = []
        if let name = name {
            parts.append(o: .constraint)
            parts.append(o: .space)
            parts.append(SwifQLPartColumn(name))
        }
        parts.appendSpaceIfNeeded()
        parts.append(o: .check)
        parts.append(o: .openBracket)
        parts.append(contentsOf: expression.parts)
        parts.append(o: .closeBracket)
        constraints.append(SwifQLableParts(parts: parts))
        return self
    }
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        parts.append(SwifQLPartColumn(name))
        parts.append(o: .space)
        parts.append(o: .custom(type.name))
        if let expression = `default` {
            parts.append(o: .space)
            parts.append(contentsOf: expression.parts)
        }
        constraints.forEach { expression in
            parts.append(o: .space)
            parts.append(contentsOf: expression.parts)
        }
        return parts
    }
}

