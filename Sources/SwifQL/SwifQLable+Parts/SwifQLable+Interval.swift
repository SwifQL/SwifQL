//
//  SwifQLable+Interval.swift
//  SwifQL
//
//  Created by Mihael Isaev on 02/08/2019.
//

import Foundation

//MARK: Interval

extension SwifQLable {
    public var interval: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .interval)
        return SwifQLableParts(parts: parts)
    }
    public func interval(_ expression: String) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .interval)
        parts.append(o: .space)
        parts.append(o: .custom(expression.singleQuotted))
        return SwifQLableParts(parts: parts)
    }
}
