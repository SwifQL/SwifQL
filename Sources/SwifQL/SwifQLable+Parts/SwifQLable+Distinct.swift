//
//  SwifQLable+Distinct.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

//MARK: DISTINCT

extension SwifQLable {
    public var distinct: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .distinct)
        return SwifQLableParts(parts: parts)
    }
}

