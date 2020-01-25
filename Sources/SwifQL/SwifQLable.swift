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

public typealias SwifQLBool = SwifQLPartBool

public struct SwifQLPartBool: SwifQLPart, SwifQLable {
    public var parts: [SwifQLPart] { [self] }
    
    let value: Bool
    
    public init (_ value: Bool) {
        self.value = value
    }
}

public struct SwifQLPartTable: SwifQLPart {
    public var table: String
    public init (_ table: String) {
        self.table = table
    }
}

public struct SwifQLPartTableWithAlias: SwifQLPart {
    public var table: String
    public var alias: String
    public init (_ table: String, _ alias: String) {
        self.table = table
        self.alias = alias
    }
}

public protocol SwifQLKeyPathable: SwifQLPart {
    var table: String? { get }
    var paths: [String] { get }
}

public struct SwifQLPartKeyPathLastPart: SwifQLPart {
    public var lastPath: String
    
    public init (_ lastPath: String) {
        self.lastPath = lastPath
    }
}

public struct SwifQLPartDate: SwifQLPart {
    public var date: Date
    
    public init (_ date: Date) {
        self.date = date
    }
}

public struct SwifQLPartKeyPath: SwifQLKeyPathable {
    public var table: String?
    public var paths: [String]
    public var asText: Bool
    // FIXME: instead of `asText` here create some protocol for path which will support `asText` for each part of path
    public init (table: String? = nil, paths: String..., asText: Bool = false) {
        self.init(table: table, paths: paths, asText: asText)
    }
    public init (table: String? = nil, paths: [String], asText: Bool = false) {
        self.table = table
        self.paths = paths
        self.asText = asText
    }
}

extension SwifQLPartKeyPath: SwifQLable{
    public var parts: [SwifQLPart] {
        SwifQLableParts(parts: self).parts
    }
}

public struct SwifQLPartAlias: SwifQLPart {
    var alias: String
    
    init (_ alias: String) {
        self.alias = alias
    }
}

public struct SwifQLPartOperator: SwifQLPart, Equatable {
    var _value: String
    
    public init (_ value: String) {
        self._value = value
    }
}

public struct SwifQLPartUnsafeValue: SwifQLPart {
    var unsafeValue: Encodable
    
    public init (_ value: Encodable) {
        unsafeValue = value
    }
}

public struct SwifQLPartSafeValue: SwifQLPart {
    var safeValue: Any?
    
    public init (_ value: Any?) {
        safeValue = value
    }
}

extension SwifQLable {
    public func prepare(_ dialect: SQLDialect) -> SwifQLPrepared {
        var values: [Encodable] = []
        var formattedValues: [String] = []
        let query = parts.map { part in
            switch part {
            case let v as SwifQLPartBool:
                return dialect.boolValue(v.value)
            case let v as SwifQLPartTable:
                return dialect.tableName(v.table)
            case let v as SwifQLPartTableWithAlias:
                return dialect.tableName(v.table, andAlias: v.alias)
            case let v as SwifQLPartAlias:
                return dialect.alias(v.alias)
            case let v as SwifQLPartKeyPath:
                return dialect.keyPath(v)
            case let v as SwifQLPartKeyPathLastPart:
                return dialect.column(v.lastPath)
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
