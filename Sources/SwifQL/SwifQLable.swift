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
    public var description: String { return prepare(.psql).plain }
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
    public var parts: [SwifQLPart] {
        return [self]
    }
    
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
    public var mysql: String {
        return Fn.from_unixtime(date.timeIntervalSince1970).prepare(.mysql).plain
    }
    public var psql: String {
        let interval = Fn.make_interval(secs: date.timeIntervalSince1970)
        let epoch = SwifQL.epoch(with: interval)
        let timestamp = SwifQL.timestamp(epoch)
        let result = |timestamp|
        return result.prepare(.psql).plain
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
        return SwifQLableParts(parts: self).parts
    }
}
public struct SwifQLPartAlias: SwifQLPart {
    var alias: String
    init (_ alias: String) {
        self.alias = alias
    }
}
public struct SwifQLPartOperator: SwifQLPart, Equatable {
    var value: String
    public init (_ value: String) { self.value = value }
}
public struct SwifQLPartUnsafeValue: SwifQLPart {
    var unsafeValue: Encodable
    public init (_ value: Encodable) { unsafeValue = value }
}
public struct SwifQLPartSafeValue: SwifQLPart {
    var safeValue: Any?
    public init (_ value: Any?) { safeValue = value }
}

public enum SQLDialect {
    case mysql, psql
}

public struct SwifQLSplittedQuery {
    public var query: String
    public var values: [Encodable]
    init (query: String, values: [Encodable]) {
        self.query = query
        self.values = values
    }
}

struct SwifQLFormatter {
    static var valueSymbol = "§§§"
    
    struct BindKeys {
        // returns $1 $2 $3 binding keys for PostgreSQL
        static func postgres(_ i: Int) -> String { return "$\(i)" }
        // returns ? binding key for MySQL
        static var mysql = "?"
    }
    
    static func mysql(_ query: String) -> String {
        var query = query
        while let r = query.range(of: valueSymbol) {
            query.replaceSubrange(r, with: BindKeys.mysql)
        }
        return query
    }
    
    static func psql(_ query: String) -> String {
        var query = query
        var i = 1
        while let r = query.range(of: valueSymbol) {
            query.replaceSubrange(r, with: BindKeys.postgres(i))
            i = i + 1
        }
        return query
    }
    
    static func plain(query: String, with formattedValues: [String]) -> String {
        var query = query
        var i = 0
        while let r = query.range(of: valueSymbol) {
            query.replaceSubrange(r, with: formattedValues[i])
            i = i + 1
        }
        return query
    }
}

public struct SwifQLPrepared {
    private var dialect: SQLDialect
    private var query: String
    private var values: [Encodable]
    private var formattedValues: [String]
    init (dialect: SQLDialect, query: String, values: [Encodable], formattedValues: [String]) {
        self.dialect = dialect
        self.query = query
        self.values = values
        self.formattedValues = formattedValues
    }
    
    public var plain: String {
        guard values.count > 0 else { return query }
        return SwifQLFormatter.plain(query: query, with: formattedValues)
    }
    
    public var splitted: SwifQLSplittedQuery {
        guard values.count > 0 else { return .init(query: query, values: values) }
        let result: String
        switch dialect {
        case .mysql:
            result = SwifQLFormatter.mysql(query)
        case .psql:
            result = SwifQLFormatter.psql(query)
        }
        return .init(query: result, values: values)
    }
}

extension SwifQLable {
    public func prepare(_ dialect: SQLDialect) -> SwifQLPrepared {
        var values: [Encodable] = []
        var formattedValues: [String] = []
        let query = parts.map { part in
            switch part {
            case let v as SwifQLPartBool:
                return v.value == true ? "TRUE" : "FALSE"
            case let v as SwifQLPartTable:
                switch dialect {
                case .mysql: return v.table
                case .psql: return v.table.doubleQuotted
                }
            case let v as SwifQLPartTableWithAlias:
                switch dialect {
                case .mysql: return v.table + " AS " + v.alias
                case .psql: return v.table.doubleQuotted + " AS " + v.alias.doubleQuotted
                }
            case let v as SwifQLPartAlias:
                switch dialect {
                case .mysql: return v.alias
                case .psql: return v.alias.doubleQuotted
                }
            case let v as SwifQLPartKeyPath:
                return format(keyPath: v, for: dialect)
            case let v as SwifQLPartKeyPathLastPart:
                return format(keyPathLastPart: v.lastPath, for: dialect)
            case let v as SwifQLPartOperator:
                return v.value
            case let v as SwifQLPartDate:
                switch dialect {
                case .mysql: return v.mysql
                case .psql: return v.psql
                }
            case let v as SwifQLPartSafeValue:
                return formatSafeValue(v.safeValue, for: dialect)
            case let v as SwifQLPartUnsafeValue:
                values.append(v.unsafeValue)
                formattedValues.append(formatSafeValue(v.unsafeValue, for: dialect))
                return SwifQLFormatter.valueSymbol
            default: return ""
            }
        }.joined(separator: "")
        return .init(dialect: dialect, query: query, values: values, formattedValues: formattedValues)
    }
    
    func format(keyPath: SwifQLPartKeyPath, for dialect: SQLDialect) -> String {
        var result = ""
        switch dialect {
        case .mysql:
            if let table = keyPath.table {
                result.append(table)
            }
            if let lastPath = keyPath.paths.last {
                if result.count > 0 {
                    result.append(".")
                }
                result.append(lastPath)
            }
        case .psql:
            if let table = keyPath.table {
                result.append(table.doubleQuotted)
            }
            for (i, v) in keyPath.paths.enumerated() {
                if i == 0 {
                    if result.count > 0 {
                        result.append(".")
                    }
                    result.append(v.doubleQuotted)
                } else {
                    if keyPath.asText, i == keyPath.paths.count - 1 {
                        result.append("->>")
                    } else {
                        result.append("->")
                    }
                    result.append(v.singleQuotted)
                }
            }
        }
        return result
    }
    
    func format(keyPathLastPart lastPath: String, for dialect: SQLDialect) -> String {
        var result = ""
        switch dialect {
        case .mysql:
            result.append(lastPath)
        case .psql:
            result.append(lastPath.doubleQuotted)
        }
        return result
    }
    
    func formatSafeValue(_ value: Any?, for dialect: SQLDialect) -> String {
        guard let value = value else { return formatNull(for: dialect) }
        switch value {
        case let v as String: return format(v, for: dialect)
        case let v as UUID: return format(v.uuidString, for: dialect)
        case let v as Bool: return formatBool(v, for: dialect)
        case let v as UInt: return String(describing: v)
        case let v as UInt8: return String(describing: v)
        case let v as UInt16: return String(describing: v)
        case let v as UInt32: return String(describing: v)
        case let v as UInt64: return String(describing: v)
        case let v as Int: return String(describing: v)
        case let v as Int8: return String(describing: v)
        case let v as Int16: return String(describing: v)
        case let v as Int32: return String(describing: v)
        case let v as Int64: return String(describing: v)
        case let v as Float: return String(describing: v)
        case let v as Double: return String(describing: v)
        case let v as Decimal: return String(describing: v)
        default: return format(String(describing: value), for: dialect)
        }
    }
    
    func formatNull(for dialect: SQLDialect) -> String {
        return "NULL"
    }
    
    func formatBool(_ v: Bool, for dialect: SQLDialect) -> String {
        return v ? "TRUE" : "FALSE"
    }
    
    func format(_ v: String, for dialect: SQLDialect) -> String {
        switch dialect {
        case .mysql: return v.singleQuotted
        case .psql: return v.singleQuotted
        }
    }
    
//    public var `as`: SwifQLable {
//        return FQP(queryString + " AS ", values: values)
//    }
//    
//    public func `as`(_ what: String) -> SwifQLable {
//        return FQP(queryString + " AS " + what.doubleQuotted, values: values)
//    }
//    
//    public func o(_ operator: String) -> SwifQLable {
//        return FQP(queryString + " " + `operator` + " ", values: values)
//    }
//    
//    public var factorial: SwifQLable {
//        return FQP(queryString + " ! ", values: values)
//    }
//    
//    public var comma: SwifQLable {
//        return FQP(queryString + ", ", values: values)
//    }
//    
//    public func field(_ field: SwifQLable) -> SwifQLable {
//        return FQP(queryString + field.queryString, values: [values, field.values].concat())
//    }
//    
    
//
//    public var Insert: SwifQLable { return FQP(queryString + " INSERT ", values: values) }
//    public var Into: SwifQLable { return FQP(queryString + " INTO ", values: values) }
//    

}

//extension SwifQLable {
//    public subscript (_ wrappedParts: SwifQLable...) -> SwifQLable {
//        var parts = self.parts
//        parts.appendSpaceIfNeeded()
//        for (i, v) in wrappedParts.enumerated() {
//            if i > 0 {
//                parts.append(o: .space)
//                parts.append(o: .comma)
//            }
//            parts.append(contentsOf: v.parts)
//        }
//        return SwifQLableParts(parts: parts)
//    }
//}
