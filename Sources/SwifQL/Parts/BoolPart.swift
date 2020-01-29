//
//  BoolPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public typealias SwifQLBool = SwifQLPartBool

public struct SwifQLPartBool: SwifQLPart, SwifQLable {
    public var parts: [SwifQLPart] { [self] }
    
    let value: Bool
    
    public init (_ value: Bool) {
        self.value = value
    }
}
