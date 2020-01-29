//
//  SwifQLable+WhereNotExists.swift
//  SwifQL
//
//  Created by Mihael Isaev on 23/07/2019.
//

import Foundation

//MARK: Where Not Exists

extension SwifQLable {
    public func whereNotExists(_ predicates: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .where)
        parts.append(o: .space)
        parts.append(o: .not)
        parts.append(o: .space)
        parts.append(o: .exists)
        parts.append(o: .space)
        parts.append(o: .openBracket)
        parts.append(contentsOf: predicates.parts)
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
