//
//  OperatorPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartOperator: SwifQLPart, Equatable {
    public var _value: String

    public init (_ value: String) {
        self._value = value
    }
}

extension SwifQLPartOperator: SwifQLable {
    public var parts: [SwifQLPart] { [self] }
}


extension SwifQLPartOperator {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    return _value
  }

}

