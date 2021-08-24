//
//  TablePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

// MARK: Schema Part

public struct SwifQLPartSchema: SwifQLPart {

    public var schema: String?

    public init (_ schema: String?) {
        self.schema = schema
    }
}

extension SwifQLPartSchema {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    guard let schema = schema else { return "" }
    return dialect.schemaName(schema)
  }

}

// MARK: - Table Part

public struct SwifQLPartTable: SwifQLPart {

    public var table: String
    public var schema: String?

    public init (_ table: String) {
        self.table = table
    }

    public init (schema: String?, table: String) {
        self.schema = schema
        self.table = table
    }
}

extension SwifQLPartTable {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    guard let schema = schema else { return dialect.tableName(table) }
    return dialect.schemaName(schema) + "." + dialect.tableName(table)
  }

}
