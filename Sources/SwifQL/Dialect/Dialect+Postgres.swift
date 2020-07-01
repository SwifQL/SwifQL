//
//  Dialect+Postgres.swift
//
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

class PostgreSQLDialect: SQLDialect {
    override var id: String? { "psql" }
    
    override func schemaName(_ value: String) -> String { value.doubleQuotted }
    
    override func tableName(_ value: String) -> String { value.doubleQuotted }
    
    override func alias(_ value: String) -> String { value.doubleQuotted }
    
    override func column(_ value: String) -> String { value.doubleQuotted }
    
    override func jsonField(_ value: String) -> String { value.singleQuotted }
    
    override func keyPath(_ keyPath: SwifQLPartKeyPath) -> String {
        var result = ""
        if let schema = keyPath.schema {
            result.append(schemaName(schema))
        }
        if let table = keyPath.table {
            if result.count > 0 {
                result.append(".")
            }
            result.append(tableName(table))
        }
        for (i, v) in keyPath.paths.enumerated() {
            if i == 0 {
                if result.count > 0 {
                    result.append(".")
                }
                result.append(column(v))
            } else {
                if keyPath.asText, i == keyPath.paths.count - 1 {
                    result.append("->>")
                } else {
                    result.append("->")
                }
                result.append(jsonField(v))
            }
        }
        return result
    }
    
    private lazy var _dateFormatter = PostgresDateFormatter()
    
    override func date(_ value: Date) -> String {
        let date = _dateFormatter.string(from: value) => .timestamptz
        let result = |date|
        return result.prepare(self).plain
    }
    
    // returns $1 $2 $3 binding keys for PostgreSQL
    override func bindKey(_ i: Int) -> String { "$\(i)" }
    
    override var arrayStart: String { Operator.array._value + Operator.openSquareBracket._value }
    override var emptyArrayStart: String { "'" + Operator.openBrace._value }
    
    override var arrayEnd: String { Operator.closeSquareBracket._value }
    override var emptyArrayEnd: String { Operator.closeBrace._value + "'" }
}

class PostgresDateFormatter: DateFormatter {
    override init() {
        super.init()
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone.current
        dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
