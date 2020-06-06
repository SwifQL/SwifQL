//
//  Dialect.swift
//
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

open class SQLDialect {
    open var id: String? { nil }
    
    public static var mysql: SQLDialect {
        MySQLDialect()
    }
    
    public static var psql: SQLDialect {
        PostgreSQLDialect()
    }
    
    public static var all: [SQLDialect] {
        [.psql, .mysql]
    }
    
    /// Good choice only for super short and universal queries like `BEGIN;`, `ROLLBACK;`, `COMMIT;`
    public static var any: SQLDialect {
        .init()
    }
    
    init () {}
    
    open func boolValue(_ value: Bool) -> String {
        value ? "TRUE" : "FALSE"
    }
    
    open var arrayStart: String { "" }
    open var emptyArrayStart: String { arrayStart }
    
    open var arraySeparator: String { Operator.comma._value }
    
    open var arrayEnd: String { "" }
    open var emptyArrayEnd: String { arrayEnd }
    
    open func schemaName(_ value: String) -> String { value }
    
    open func tableName(_ value: String) -> String { value }
    
    open func alias(_ value: String) -> String { value }
    
    open func column(_ value: String) -> String { value }
    
    open func stringValue(_ value: String) -> String { value.singleQuotted }
    
    open func uuidValue(_ value: UUID) -> String { stringValue(value.uuidString) }
    
    open func jsonField(_ value: String) -> String { value }
    
    open func tableName(_ tableName: String, andAlias alias: String) -> String {
        self.tableName(tableName) + " AS " + self.alias(alias)
    }
    
    open func keyPath(_ keyPath: SwifQLPartKeyPath) -> String {
        "<key_path_should_be_here: override dialect function to fix>"
    }
    
    open func date(_ value: Date) -> String {
        "<date_should_be_here: override dialect function to fix>"
    }
    
    open var null: String { "NULL" }
    
    open func safeValue(_ value: Any?) -> String {
        guard let value = value else { return null }
        switch value {
        case let v as String: return stringValue(v)
        case let v as UUID: return uuidValue(v)
        case let v as Bool: return boolValue(v)
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
        default: return stringValue(String(describing: "<unsafe value>")) // TODO:
        }
    }
    
    // MARK: - Binding (for formatter)
    
    open var bindSymbol: String { "§§§" }
    
    open func bindKey(_ i: Int) -> String { "?" }
}

extension SQLDialect: Equatable {
    public static func == (lhs: SQLDialect, rhs: SQLDialect) -> Bool {
        lhs.id == rhs.id
    }
}
