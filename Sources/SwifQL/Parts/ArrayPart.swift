//
//  ArrayPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 06.06.2020.
//

import Foundation

public protocol SwifQLPartArray: SwifQLPart {
    var elements: [SwifQLable] { get }
}

extension SwifQLPartArray {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    guard elements.count > 0 else {
      return dialect.emptyArrayStart + dialect.emptyArrayEnd
    }

    var string = dialect.arrayStart

    elements.enumerated().forEach { i, subPart in
      if i > 0 { string += dialect.arraySeparator }
      let prepared = subPart.prepare(dialect)

      preparator._values.append(contentsOf: prepared._values)
      preparator._formattedValues.append(contentsOf: prepared._formattedValues)
      string += prepared._query
    }

    return string + dialect.arrayEnd
  }

}
