//
//  SwifQLable+Union.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: Union

extension SwifQLable {
    public var union: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .union)
        parts.append(o: .space)
        return SwifQLableParts(parts: parts)
    }
}
