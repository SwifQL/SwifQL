//
//  Dialect+MySQL.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

class MySQLDialect: SQLDialect {
    override func keyPath(_ keyPath: SwifQLPartKeyPath) -> String {
        var result = ""
        if let table = keyPath.table {
            result.append(table)
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
}
