//
//  Prepared.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

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
        let formatter = SwifQLFormatter(dialect, mode: .plain)
        return formatter.string(from: query, with: formattedValues)
    }
    
    public var splitted: SwifQLSplittedQuery {
        guard values.count > 0 else { return .init(query: query, values: values) }
        let formatter = SwifQLFormatter(dialect, mode: .binded)
        let result = formatter.string(from: query, with: formattedValues)
        return .init(query: result, values: values)
    }
}
