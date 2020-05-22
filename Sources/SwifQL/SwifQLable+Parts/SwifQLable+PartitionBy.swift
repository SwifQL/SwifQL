//
//  SwifQLable+PartitionBy.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

import Foundation

//MARK: Partition By

extension SwifQLable {
    public var partition: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .partition)
        return SwifQLableParts(parts: parts)
    }
    
    public var by: SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .by)
        return SwifQLableParts(parts: parts)
    }
    
    public func partition(by expression: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .partition)
        parts.append(o: .space)
        parts.append(o: .by)
        parts.append(o: .space)
        parts.append(contentsOf: expression.parts)
        return SwifQLableParts(parts: parts)
    }
}
