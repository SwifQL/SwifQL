//
//  Dialect+Postgres.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

class PostgreSQLDialect: SQLDialect {
    override func tableName(_ value: String, schema: String? = nil) -> String {
        if let schema = schema {
            return "\(schema.doubleQuotted).\(value.doubleQuotted)"
        }
        return value.doubleQuotted
    }
    
    override func alias(_ value: String) -> String { value.doubleQuotted }
    
    override func column(_ value: String) -> String { value.doubleQuotted }
    
    override func jsonField(_ value: String) -> String { value.singleQuotted }
    
    override func keyPath(_ keyPath: SwifQLPartKeyPath) -> String {
        var result = ""
        if let table = keyPath.table {
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
    
    override func date(_ value: Date) -> String {
        let interval = Fn.make_interval(secs: value.timeIntervalSince1970)
        let epoch = SwifQL.epoch(with: interval)
        let timestamp = SwifQL.timestamp(epoch)
        let result = |timestamp|
        return result.prepare(self).plain
    }
    
    // returns $1 $2 $3 binding keys for PostgreSQL
    override func bindKey(_ i: Int) -> String { "$\(i)" }
}
