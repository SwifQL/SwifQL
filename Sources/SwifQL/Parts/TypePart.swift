//
//  TypePart.swift
//  SwifQL
//

import Foundation

/// A semantic SQL type value that remains available to the dialect renderer.
public struct SwifQLPartType: SwifQLPart {
    public let type: Type

    public init(_ type: Type) {
        self.type = type
    }
}
