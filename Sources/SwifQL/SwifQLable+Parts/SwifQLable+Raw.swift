//
//  SwifQLable+Raw.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: Ability to append anything to query as a raw string

extension SwifQLable {
    public func raw(_ anything: String) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom(anything))
        return SwifQLableParts(parts: parts)
    }
    
    public static func raw(_ anything: String) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(o: .space)
        parts.append(safe: value)
        return SwifQLableParts(parts: parts)
    }
}

extension String {
    public var raw: SwifQLable {
        SwifQL.raw(self)
    }
}
