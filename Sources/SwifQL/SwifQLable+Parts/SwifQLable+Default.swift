//
//  SwifQLable+Default.swift
//  SwifQL
//
//  Created by Mihael Isaev on 29.01.2020.
//

import Foundation

//MARK: DEFAULT

extension SwifQLable {
    public var `default`: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .default)
        return SwifQLableParts(parts: parts)
    }
}
