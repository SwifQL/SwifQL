//
//  Decodable+Table.swift
//  
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

extension Decodable {
    public static var table: SwifQLable {
        if let model = Self.self as? Tableable.Type {
            return SwifQLableParts(parts: SwifQLPartTable(model.entity))
        }
        return SwifQLableParts(parts: SwifQLPartTable(String(describing: Self.self)))
    }
}
