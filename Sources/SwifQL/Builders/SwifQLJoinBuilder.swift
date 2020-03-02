//
//  SwifQLJoinBuilder.swift
//  App
//
//  Created by Mihael Isaev on 22/02/2019.
//

import Foundation

public struct JoinMode {
    let parts: [SwifQLPartOperator]
    
    public init (_ parts: SwifQLPartOperator...) {
        self.parts = parts
    }
    
    public init (_ parts: [SwifQLPartOperator]) {
        self.parts = parts
    }
    
    public static var none: JoinMode { .init(.join) }
    
    public static var left: JoinMode { .init(.left, .space, .join) }
    public static var leftLateral: JoinMode { .init(.left, .space, .join, .space, .lateral) }
    
    public static var leftOuter: JoinMode { .init(.left, .space, .outer, .space, .join) }
    public static var leftOuterLateral: JoinMode { .init(.left, .space, .outer, .space, .join, .space, .lateral) }

    public static var right: JoinMode { .init(.right, .space, .join) }
    public static var rightLateral: JoinMode { .init(.right, .space, .join, .space, .lateral) }

    public static var rightOuter: JoinMode { .init(.right, .space, .outer, .space, .join) }
    public static var rightOuterLateral: JoinMode { .init(.right, .space, .outer, .space, .join, .space, .lateral) }

    public static var inner: JoinMode { .init(.inner, .space, .join) }
    public static var outer: JoinMode { .init(.outer, .space, .join) }
    
    public static var cross: JoinMode { .init(.cross, .space, .join) }
    public static var crossLateral: JoinMode { .init(.cross, .space, .join, .space, .lateral) }
}

public struct SwifQLJoinBuilder: SwifQLable {
    let mode: JoinMode
    let table: SwifQLable
    let predicates: SwifQLable?
    
    public init (_ mode: JoinMode? = nil, _ table: SwifQLable, on predicates: SwifQLable? = nil) {
        self.mode = mode ?? .none
        self.table = table
        self.predicates = predicates
    }
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        parts.appendSpaceIfNeeded()
        parts.append(contentsOf: mode.parts)
        parts.append(o: .space)
        parts.append(contentsOf: table.parts)
        if let predicates = predicates {
            parts.append(o: .space)
            parts.append(o: .on)
            parts.append(o: .space)
            parts.append(contentsOf: predicates.parts)
        }
        return parts
    }
}
