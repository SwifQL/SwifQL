//
//  SwifQLable+On.swift
//  SwifQL
//
//  Created by Mihael Isaev on 24/07/2019.
//

import Foundation

//MARK: On

extension SwifQLable {
    public var on: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .on)
        return SwifQLableParts(parts: parts)
    }
}
