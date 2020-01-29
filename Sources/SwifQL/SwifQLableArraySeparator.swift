//
//  SwifQLableArraySeparator.swift
//  
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

public enum SwifQLableArraySeparator {
    case comma
    
    var `operator`: SwifQLPartOperator {
        switch self {
        case .comma: return .comma
        }
    }
}
