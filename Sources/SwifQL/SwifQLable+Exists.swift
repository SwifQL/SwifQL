//
//  SwifQLable+Exists.swift
//  SwifQL
//
//  Created by Mihael Isaev on 23/07/2019.
//

import Foundation

//MARK: Exists

extension SwifQLable {
    public func exists(_ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .exists)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        parts.append(contentsOf: predicates.parts)
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
