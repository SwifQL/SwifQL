//
//  SafeValuePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartSafeValue: SwifQLPart {
    public var safeValue: Any?

    public init (_ value: Any?) {
        safeValue = value
    }
}


extension SwifQLPartSafeValue {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    return dialect.safeValue(safeValue)
  }

}
