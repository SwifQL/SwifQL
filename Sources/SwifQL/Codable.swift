//
//  Codable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 25.04.2020.
//

import Foundation

public protocol SwifQLCodable: Codable, SwifQLable {}

extension SwifQLCodable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

public protocol SwifQLEncodable: Encodable, SwifQLable {}

extension SwifQLEncodable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Array: SwifQLCodable where Element: SwifQLCodable {}
