//
//  UnsafeValuePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartUnsafeValue: SwifQLPart {
   public var unsafeValue: Encodable

    public init (_ value: Encodable) {
        unsafeValue = value
    }
}

extension SwifQLPartUnsafeValue {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    preparator._values.append(unsafeValue)
    preparator._formattedValues.append(dialect.safeValue(unsafeValue))
    return dialect.bindSymbol
  }

}
