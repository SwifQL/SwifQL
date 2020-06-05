//
//  StringWithoutQuotesPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 06.06.2020.
//

import Foundation

struct SwifQLPartStringWithoutQuotes: SwifQLPart, SwifQLable {
    var parts: [SwifQLPart] { [self] }
    
    let value: String
    
    init (_ value: String) {
        self.value = value
    }
}
