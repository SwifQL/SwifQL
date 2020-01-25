//
//  SplittedQuery.swift
//  
//
//  Created by Mihael Isaev on 25.01.2020.
//

import Foundation

public struct SwifQLSplittedQuery {
    public var query: String
    public var values: [Encodable]
    
    init (query: String, values: [Encodable]) {
        self.query = query
        self.values = values
    }
}
