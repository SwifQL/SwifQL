//
//  AliasPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartAlias: SwifQLPart {
    public var alias: String

    init (_ alias: String) {
        self.alias = alias
    }
}

extension SwifQLPartAlias {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    return dialect.alias(alias)
  }

}
