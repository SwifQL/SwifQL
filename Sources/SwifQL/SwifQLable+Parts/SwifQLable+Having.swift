//
//  SwifQLable+Having.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: Having

extension SwifQLable {
    public func having(_ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .having)
        parts.append(o: .space)
        parts.append(contentsOf: predicates.parts)
        return SwifQLableParts(parts: parts)
    }
}
