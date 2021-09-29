//
//  SwifQLable+All.swift
//  App
//
//  Created by Mihael Isaev on 30.09.2021.
//

import Foundation

//MARK: ALL

extension SwifQLable {
    public var all: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .all)
        return SwifQLableParts(parts: parts)
    }
}
