//
//  SwifQLable+Case.swift
//  SwifQL
//
//  Created by Mihael Isaev on 15/02/2019.
//

import Foundation

public class Case {
    var parts: [SwifQLPart] = []
    
    public init (_ expression: SwifQLable? = nil) {
        parts.append(o: .case)
        if let expression = expression {
            parts.append(o: .space)
            parts.append(contentsOf: expression.parts)
        }
    }
    
    public static func when(_ expression: SwifQLable) -> Case {
        Case().when(expression)
    }
    
    public func when(_ expression: SwifQLable) -> Case {
        parts.appendSpaceIfNeeded()
        parts.append(o: .when)
        parts.append(o: .space)
        parts.append(contentsOf: expression.parts)
        return self
    }
    
    public func then(_ expression: SwifQLable?) -> Case {
        parts.appendSpaceIfNeeded()
        parts.append(o: .then)
        parts.append(o: .space)
        if let expression = expression {
            parts.append(contentsOf: expression.parts)
        } else {
            parts.append(o: .null)
        }
        return self
    }
    
    public func `else`(_ expression: SwifQLable?) -> Case {
        parts.appendSpaceIfNeeded()
        parts.append(o: .else)
        parts.append(o: .space)
        if let expression = expression {
            parts.append(contentsOf: expression.parts)
        } else {
            parts.append(o: .null)
        }
        return self
    }
    
    public var end: SwifQLable {
        parts.appendSpaceIfNeeded()
        parts.append(o: .end)
        return SwifQLableParts(parts: parts)
    }
}
