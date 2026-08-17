//
//  SwifQLable+Limit.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

//MARK: LIMIT

extension SwifQLable {
    public func limit(_ value: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .limit)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return SwifQLableParts(parts: parts)
    }

    /// Appends DuckDB's exact percentage LIMIT form without changing the
    /// established row-count overload.
    public func limit(percent value: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .limit, .space)
        parts.append(contentsOf: value.parts)
        parts.append(o: .custom("%"))
        return SwifQLableParts(parts: parts)
    }
}
