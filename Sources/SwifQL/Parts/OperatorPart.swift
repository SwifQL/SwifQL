//
//  OperatorPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartOperator: SwifQLPart, Equatable {
    var _value: String
    
    public init (_ value: String) {
        self._value = value
    }
}

extension SwifQLPartOperator: SwifQLable {
    public var parts: [SwifQLPart] {
        [self]
    }
}
