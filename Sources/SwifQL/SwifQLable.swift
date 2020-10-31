//
//  SwifQLable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public protocol SwifQLable: CustomStringConvertible {
    var parts: [SwifQLPart] { get }
}

extension SwifQLable {
    public var description: String { prepare(.psql).plain }
}

public struct SwifQLableParts: SwifQLable {
    public var parts: [SwifQLPart]
    public init (parts: SwifQLPart...) {
        self.init(parts: parts)
    }
    public init (parts: [SwifQLPart]) {
        self.parts = parts
    }
}

public protocol SwifQLPart {}

public protocol SwifQLKeyPathable: SwifQLPart {
    var schema: String? { get }
    var table: String? { get }
    var paths: [String] { get }
}

extension SwifQLable {
    /// Good choice only for super short and universal queries like `BEGIN;`, `ROLLBACK;`, `COMMIT;`
    public func prepare() -> SwifQLPrepared {
        prepare(.any)
    }
    
    public func prepare(_ dialect: SQLDialect) -> SwifQLPrepared {
        var values: [Encodable] = []
        var formattedValues: [String] = []
        let query = parts.map { part in
            switch part {
            case let v as SwifQLPartArray:
                guard v.elements.count > 0 else {
                    return dialect.emptyArrayStart + dialect.emptyArrayEnd
                }
                var string = dialect.arrayStart
                v.elements.enumerated().forEach { i, v in
                    if i > 0 {
                        string += dialect.arraySeparator
                    }
                    let prepared = v.prepare(dialect)
                    values.append(contentsOf: prepared._values)
                    formattedValues.append(contentsOf: prepared._formattedValues)
                    string += prepared._query
                }
                return string + dialect.arrayEnd
            case let v as SwifQLPartBool:
                return dialect.boolValue(v.value)
            case is SwifQLPartNull:
                return dialect.null
            case let v as SwifQLPartSchema:
                guard let schema = v.schema else { return "" }
                return dialect.schemaName(schema)
            case let v as SwifQLPartTable:
                if let schema = v.schema {
                    return dialect.schemaName(schema) + "." + dialect.tableName(v.table)
                }
                return dialect.tableName(v.table)
            case let v as SwifQLPartTableWithAlias:
                if let schema = v.schema {
                    return dialect.schemaName(schema) + "." + dialect.tableName(v.table, andAlias: v.alias)
                }
                return dialect.tableName(v.table, andAlias: v.alias)
            case let v as SwifQLPartAlias:
                return dialect.alias(v.alias)
            case let v as SwifQLPartKeyPath:
                return dialect.keyPath(v)
            case let v as SwifQLPartColumn:
                return dialect.column(v.name)
            case let v as SwifQLPartOperator:
                return v._value
            case let v as SwifQLPartDate:
                return dialect.date(v.date)
            case let v as SwifQLPartSafeValue:
                return dialect.safeValue(v.safeValue)
            case let v as SwifQLPartUnsafeValue:
                values.append(v.unsafeValue)
                formattedValues.append(dialect.safeValue(v.unsafeValue))
                return dialect.bindSymbol
            default: return ""
            }
        }.joined(separator: "")
        return .init(dialect: dialect, query: query, values: values, formattedValues: formattedValues)
    }
}
