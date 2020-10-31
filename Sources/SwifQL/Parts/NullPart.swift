//
//  NullPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 31.10.2020.
//

import Foundation

public var SwifQLNull: SwifQLPartNull { .init() }

public struct SwifQLPartNull: SwifQLPart, SwifQLable {
    public var parts: [SwifQLPart] { [self] }
    public init () {}
}
