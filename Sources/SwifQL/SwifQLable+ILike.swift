//
//  SwifQLable+iLike.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: ILIKE

extension SwifQLable {
    public func iLike(_ part: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .ilike)
        parts.append(o: .space)
        parts.append(contentsOf: part.parts)
        return SwifQLableParts(parts: parts)
    }
}
