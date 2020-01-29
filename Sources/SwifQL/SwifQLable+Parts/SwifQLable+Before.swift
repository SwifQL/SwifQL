//
//  SwifQLable+Before.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

//MARK: BEFORE

extension SwifQLable {
    public var before: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .before)
        return SwifQLableParts(parts: parts)
    }
}
