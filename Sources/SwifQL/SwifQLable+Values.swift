//
//  SwifQLable+Values.swift
//  App
//
//  Created by Mihael Isaev on 25/11/2018.
//

import Foundation

extension SwifQLable {
    public func values(_ items: SwifQLable...) -> SwifQLable {
        return values(items)
    }
    public func values(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .values)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
    
    /// e.g. INSERT INTO CarBrands (name) VALUES ("Acura"), ("Audi"), ("BMW")
    public func values(array: [SwifQLable]...) -> SwifQLable {
        return values(array: array)
    }
    /// e.g. INSERT INTO CarBrands (name) VALUES ("Acura"), ("Audi"), ("BMW")
    public func values(array: [[SwifQLable]]) -> SwifQLable {
        var parts: [SwifQLPart] = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .values)
        parts.append(o: .space)
        for (i, v) in array.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(o: .openBracket)
            for (i, v) in v.enumerated() {
                if i > 0 {
                    parts.append(o: .comma)
                    parts.append(o: .space)
                }
                parts.append(contentsOf: v.parts)
            }
            parts.append(o: .closeBracket)
        }
        return SwifQLableParts(parts: parts)
    }
}
