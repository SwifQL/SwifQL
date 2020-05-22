//
//  Functions.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public struct Fn {}

extension Fn {
    public struct Name {
        let name: String
        
        public init (_ name: String) {
            self.name = name
        }
        
        public static func custom(_ name: String) -> Name { .init(name) }
        
        var part: SwifQLPartOperator { .init(name) }
    }
}

//MARK: Function builders

extension Fn {
    public static func build(_ fn: Name) -> SwifQLable {
        build(fn, body: nil)
    }
    public static func build(_ fn: Name, body: SwifQLPart...) -> SwifQLable {
        build(fn, body: body)
    }
    public static func build(_ fn: Name, body: [SwifQLPart]? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(f: fn)
        if let body = body {
            parts.append(o: .openBracket)
            parts.append(contentsOf: body)
            parts.append(o: .closeBracket)
        }
        return SwifQLableParts(parts: parts)
    }
}

public func Select(_ queryPart: SwifQLable...) -> SwifQLable {
    Select(queryPart)
}

public func Select(_ queryParts: [SwifQLable]) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .select)
    parts.append(o: .space)
    for (i, q) in queryParts.enumerated() {
        if i > 0 {
            parts.append(o: .comma)
            parts.append(o: .space)
        }
        parts.append(contentsOf: q.parts)
    }
    return SwifQLableParts(parts: parts)
}

public var Select: SwifQLable { Fn.build(.custom("SELECT")) }

//MARK: [SwifQLPart] extension

extension Array where Element == SwifQLPart {
    public mutating func appendSpaceIfNeeded() {
        if count == 0 { return }
        if let last = last as? SwifQLPartOperator, last._value == " " {
            return
        }
        append(o: .space)
    }
    public mutating func append(f: Fn.Name) {
        append(f.part)
    }
    public mutating func append(o: SwifQLPartOperator...) {
        o.forEach { append($0) }
    }
    public mutating func append(safe value: Any) {
        append(SwifQLPartSafeValue(value))
    }
}
