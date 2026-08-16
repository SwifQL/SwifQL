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

    public convenience init (all selection: SwifQLable...) {
        self.init(selection, all: true)
    }
    
    public init (_ selections: [SwifQLable], all: Bool = false) {
        var children: [SwifQLPart] = [SwifQLPartOperator.openBracket]
        for (i, v) in selections.enumerated() {
            if i > 0 {
                children.append(o: .space)
                children.append(o: .union)
                if all {
                    children.append(o: .space)
                    children.append(o: .all)
                }
                children.append(o: .space)
                children.append(o: .openBracket)
            }
            children.append(_SwifQLStructuralComposition.statementFrame(for: v))
            children.append(o: .closeBracket)
        }
        parts = [SwifQLStructuralFramePart(region: .setResult, children: children)]
    }
}
