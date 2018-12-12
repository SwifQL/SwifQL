//
//  Table.swift
//  SwifQLReflectable
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation

public protocol Table: Codable, Reflectable {}

/// Default `Reflectable` implementation for types that are also `Decodable`.
extension Reflectable where Self: Decodable {
    /// Default `Reflectable` implementation for types that are also `Decodable`.
    ///
    /// See `Reflectable.reflectProperties(depth:)`
    public static func reflectProperties(depth: Int) throws -> [ReflectedProperty] {
        return try decodeProperties(depth: depth)
    }
    
    /// Default `Reflectable` implementation for types that are also `Decodable`.
    ///
    /// See `AnyReflectable`.
    public static func anyReflectProperty(valueType: Any.Type, keyPath: AnyKeyPath) throws -> ReflectedProperty? {
        return try anyDecodeProperty(valueType: valueType, keyPath: keyPath)
    }
}

extension Reflectable {
    static var tableName: String {
//        #if canImport(Fluent)
//        if let model = self as? AnyModel.Type {
//            return model.entity
//        }
//        #endif
        return String(describing: Self.self)
    }
}
