//
//  UnsafeValuePart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public struct SwifQLPartUnsafeValue: SwifQLPart {
   public var unsafeValue: Encodable

    public init (_ value: Encodable) {
        unsafeValue = value
    }
}
