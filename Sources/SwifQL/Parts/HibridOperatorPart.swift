//
//  HibridOperatorPart.swift
//  
//
//  Created by TierraCero on 5/30/23.
//

import Foundation

public struct SwifQLHibridOperator: SwifQLPart, Equatable {
    
    var _psql: SwifQLPartOperator
    
    var _mysql: SwifQLPartOperator
    
    public init (_ psql: SwifQLPartOperator, _ mysql: SwifQLPartOperator) {
        self._psql = psql
        self._mysql = mysql
    }
}

extension SwifQLHibridOperator: SwifQLable {
    public var parts: [SwifQLPart] {
        [self]
    }
}
