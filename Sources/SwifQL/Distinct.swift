//
//  Distinct.swift
//  SwifQL
//
//  Created by Mihael Isaev on 02/03/2019.
//

import Foundation

//MARK: DISTINCT

public class Distinct: SwifQLable {
    public var parts: [SwifQLPart]
    
    public convenience init (_ field: SwifQLable...) {
        self.init(field)
    }
    
    public init (_ fields: [SwifQLable]) {
        parts = []
        parts.append(o: .distinct)
        parts.append(o: .space)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
    }
    
    public convenience init (on field: SwifQLable...) {
        self.init(on: field)
    }
    
    public init (on fields: [SwifQLable]) {
        parts = []
        parts.append(o: .distinct)
        parts.append(o: .space)
        parts.append(o: .on)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        parts.append(o: .closeBracket)
    }
    
    public func andAlso(_ fields: SwifQLable...) -> Distinct {
        andAlso(fields)
    }
    
    public func andAlso(_ fields: [SwifQLable]) -> Distinct {
        parts.append(o: .space)
        for (i, v) in fields.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return self
    }
}
