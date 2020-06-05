//
//  StringWithoutQuotes.swift
//  SwifQL
//
//  Created by Mihael Isaev on 06.06.2020.
//

import Foundation

struct StringWithoutQuotes: Encodable {
    let originalString: String
    
    init (_ v: String) {
        originalString = v
    }
}

extension StringWithoutQuotes: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartStringWithoutQuotes(originalString)] }
}
