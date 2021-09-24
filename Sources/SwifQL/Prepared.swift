//
//  Prepared.swift
//
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

public struct SwifQLPrepared {

  // MARK: - Properties

    public var _dialect: SQLDialect
    public var _query: String
    public var _values: [Encodable]
    public var _formattedValues: [String]


  // MARK: - Computed Properties

  public var plain: String {
    guard _values.count > 0 else { return _query }
    let formatter = SwifQLFormatter(_dialect, mode: .plain)
    return formatter.string(from: _query, with: _formattedValues)
  }

  public var splitted: SwifQLSplittedQuery {
    guard _values.count > 0 else { return .init(query: _query, values: _values) }
    let formatter = SwifQLFormatter(_dialect, mode: .binded)
    let result = formatter.string(from: _query, with: _formattedValues)
    return .init(query: result, values: _values)
  }

  // MARK: - Initialiers

    public init(dialect: SQLDialect, query: String = "", values: [Encodable] = [], formattedValues: [String] = []) {
        _dialect = dialect
        _query = query
        _values = values
        _formattedValues = formattedValues
    }

  // MARK: - Prepare

  public init(_ container: SwifQLable, _ dialect: SQLDialect) {
    self.init(dialect: dialect)
    self._query = container.parts.map({ return $0.prepare(dialect, preparator: &self)}).joined()
  }

}


