//
//  SwifQLable+Asterisk.swift
//  SwifQL
//
//  Created by Mihael Isaev on 31.01.2020.
//

import Foundation

//MARK: *

extension SwifQLable {
    public var asterisk: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("*"))
        return SwifQLableParts(parts: parts)
    }
}
