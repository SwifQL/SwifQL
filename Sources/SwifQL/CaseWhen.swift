//
//  SwifQLable+Case.swift
//  SwifQL
//
//  Created by Mihael Isaev on 15/02/2019.
//

import Foundation

public struct Case: SwifQLable {
    public var parts: [SwifQLPart] = []
    public init (when: SwifQLable, then: SwifQLable?, else: SwifQLable) {
        parts.append(o: .case)
        parts.append(o: .space)
        parts.append(o: .when)
        parts.append(o: .space)
        parts.append(contentsOf: when.parts)
        parts.append(o: .space)
        parts.append(o: .then)
        parts.append(o: .space)
        if let then = then {
            parts.append(contentsOf: then.parts)
        } else {
            parts.append(o: .null)
        }
        parts.append(o: .space)
        parts.append(o: .else)
        parts.append(o: .space)
        parts.append(contentsOf: `else`.parts)
        parts.append(o: .space)
        parts.append(o: .end)
    }
}
