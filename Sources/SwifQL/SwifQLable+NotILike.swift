//
//  SwifQLable+NotILike.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: NOT ILIKE

extension SwifQLable {
    public func notILike(_ part: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .notILike)
        parts.append(o: .space)
        parts.append(contentsOf: part.parts)
        return SwifQLableParts(parts: parts)
    }
}
