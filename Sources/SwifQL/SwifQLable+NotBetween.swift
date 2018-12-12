//
//  SwifQLable+NotBetween.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: NOT BETWEEN

extension SwifQLable {
    public func notBetween(_ part: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .notBetween)
        parts.append(o: .space)
        parts.append(contentsOf: part.parts)
        return SwifQLableParts(parts: parts)
    }
}
