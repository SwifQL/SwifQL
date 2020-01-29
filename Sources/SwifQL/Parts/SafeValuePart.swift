//
//  SafeValuePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartSafeValue: SwifQLPart {
    var safeValue: Any?
    
    public init (_ value: Any?) {
        safeValue = value
    }
}
