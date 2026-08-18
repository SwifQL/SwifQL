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

    public static var full: JoinMode { .init(.custom("FULL"), .space, .join) }
    public static var fullOuter: JoinMode { .init(.custom("FULL"), .space, .outer, .space, .join) }

    public static var semi: JoinMode { .init(.custom("SEMI"), .space, .join) }
    public static var anti: JoinMode { .init(.custom("ANTI"), .space, .join) }

    public static var asOf: JoinMode { .init(.custom("ASOF"), .space, .join) }
    public static var asOfLeft: JoinMode { .init(.custom("ASOF"), .space, .left, .space, .join) }
}

public struct SwifQLJoinBuilder: SwifQLable {
    let mode: JoinMode
    let table: SwifQLable
    let predicates: SwifQLable?
    private let usingColumns: [String]?
    
    public init (_ mode: JoinMode? = nil, _ table: SwifQLable, on predicates: SwifQLable? = nil) {
        self.mode = mode ?? .none
        self.table = table
        self.predicates = predicates
        self.usingColumns = nil
    }

    init (_ mode: JoinMode, _ table: SwifQLable, using columns: [KeyPathLastPath]) {
        self.mode = mode
        self.table = table
        self.predicates = nil
        self.usingColumns = columns.map(\.lastPath)
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
        } else if let usingColumns = usingColumns {
            parts.append(o: .space)
            parts.append(o: .using)
            parts.append(o: .space)
            parts.append(o: .openBracket)
            for (index, column) in usingColumns.enumerated() {
                if index > 0 {
                    parts.append(o: .comma)
                    parts.append(o: .space)
                }
                parts.append(SwifQLPartColumn(column))
            }
            parts.append(o: .closeBracket)
        }
        return parts
    }
}
