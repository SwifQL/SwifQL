//
//  SwifQLable+Returning.swift
//  SwifQL
//
//  Created by Mihael Isaev on 11/07/2019.
//

import Foundation

extension SwifQLable {
    public var returning: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .returning)
        return SwifQLableParts(parts: parts)
    }
    
    public func returning(_ paths: KeyPathLastPath...) -> SwifQLable {
        returning(paths)
    }
    
    public func returning(_ paths: [KeyPathLastPath]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .returning)
        parts.append(o: .space)
        for (i, p) in paths.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(SwifQLPartAlias(p.lastPath))
        }
        return SwifQLableParts(parts: parts)
    }
}
