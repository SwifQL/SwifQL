//
//  HybridOperatorPart.swift
//  
//
//  Created by TierraCero on 5/30/23.
//

import Foundation

public struct SwifQLHybridOperator: SwifQLPart, Equatable {
    
    var _psql: SwifQLPartOperator
    
    var _mysql: SwifQLPartOperator

    var _duck: SwifQLPartOperator?
    
    public init (_ psql: SwifQLPartOperator, _ mysql: SwifQLPartOperator) {
        self.init(psql, mysql, nil)
    }

    public init (
        _ psql: SwifQLPartOperator,
        _ mysql: SwifQLPartOperator,
        _ duck: SwifQLPartOperator?
    ) {
        self._psql = psql
        self._mysql = mysql
        self._duck = duck
    }
}

extension SwifQLHybridOperator: SwifQLable {
    public var parts: [SwifQLPart] {
        [self]
    }
}
