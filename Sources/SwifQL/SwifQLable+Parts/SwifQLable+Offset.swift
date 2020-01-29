//
//  SwifQLable+Offset.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: OFFSET

extension SwifQLable {
    public func offset(_ value: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .offset)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return SwifQLableParts(parts: parts)
    }
}
