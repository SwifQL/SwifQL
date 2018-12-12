//
//  Case.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

//CASE
//WHEN condition1 THEN result1
//WHEN condition2 THEN result2
//WHEN conditionN THEN resultN
//ELSE result
//END;

class FQWhen {
    
}

class FQCase {
    var queryString: String = ""
    
    var plainQuery: String = ""
    
    var values: [SwifQLable] = []
    
    func when(_ condition: SwifQLable, then: SwifQLable) {
        
    }
    
//    func end() -> SwifQLable {
//        return FQP("CASE ")
//    }
}

//public func `case`() -> FQCase {
//    return FQCase()
//}

struct TTT: Decodable {
    var name: String
}
