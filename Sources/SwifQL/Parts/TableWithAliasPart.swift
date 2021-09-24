//
//  TableWithAliasPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartTableWithAlias: SwifQLPart {
    public var schema: String?
    public var table, alias: String

    public init (schema: String?, table: String, alias: String) {
        self.schema = schema
        self.table = table
        self.alias = alias
    }
}

extension SwifQLPartTableWithAlias {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    guard let schema = schema else { return dialect.tableName(table, andAlias: alias) }
    return dialect.schemaName(schema) + "." + dialect.tableName(table, andAlias: alias)
  }

}
