//
//  Union.swift
//  SwifQL
//
//  Created by Taylor McIntyre on 2020-01-15.
//

import Foundation

//MARK: UNION

public class Union: SwifQLable {
    public var parts: [SwifQLPart]
    
    public convenience init (_ selection: SwifQLable...) {
        self.init(selection)
    }
    
    public init (_ selections: [SwifQLable]) {
        parts = [SwifQLPartOperator.openBracket]
        for (i, v) in selections.enumerated() {
            if i > 0 {
                parts.append(o: .space)
                parts.append(o: .union)
                parts.append(o: .space)
                parts.append(o: .openBracket)
            }
            parts.append(contentsOf: v.parts)
            parts.append(o: .closeBracket)
        }
    }
}
