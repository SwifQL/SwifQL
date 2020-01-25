//
//  Formatter.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

struct SwifQLFormatter {
    private let dialect: SQLDialect
    private let mode: Mode
    
    init (_ dialect: SQLDialect, mode: Mode) {
        self.dialect = dialect
        self.mode = mode
    }
    
    enum Mode {
        case binded
        case plain
    }
    
    func string(from query: String, with formattedValues: [String]) -> String {
        switch mode {
        case .binded:
            return binded(query)
        case .plain:
            return plain(query: query, with: formattedValues)
        }
    }
    
    private func binded(_ query: String) -> String {
        var query = query
        var i = 1
        while let r = query.range(of: dialect.bindSymbol) {
            query.replaceSubrange(r, with: dialect.bindKey(i))
            i = i + 1
        }
        return query
    }
    
    private func plain(query: String, with formattedValues: [String]) -> String {
        var query = query
        var i = 0
        while let r = query.range(of: dialect.bindSymbol) {
            query.replaceSubrange(r, with: formattedValues[i])
            i = i + 1
        }
        return query
    }
}
