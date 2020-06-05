//
//  Dialect+MySQL.swift
//
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

class MySQLDialect: SQLDialect {
    override var id: String? { "mysql" }
    
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
        if let lastPath = keyPath.paths.last {
            if result.count > 0 {
                result.append(".")
            }
            result.append(lastPath)
        }
        return result
    }
    
    override func date(_ value: Date) -> String {
        Fn.from_unixtime(value.timeIntervalSince1970).prepare(self).plain
    }
    
    override func bindKey(_ i: Int) -> String { "?" }
    
    override var arrayStart: String { "'" }
    
    override var arrayEnd: String { "'" }
}
