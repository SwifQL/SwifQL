//
//  DatePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartDate: SwifQLPart {
    public var date: Date

    public init (_ date: Date) {
        self.date = date
    }
}

extension SwifQLPartDate {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    return dialect.date(date)
  }

}
