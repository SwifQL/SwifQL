//
//  SwifQLable+Check.swift
//  SwifQL
//
//  Created by Mihael Isaev on 29.01.2020.
//

import Foundation

//MARK: CHECK

extension SwifQLable {
    public var check: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .check)
        return SwifQLableParts(parts: parts)
    }
}

