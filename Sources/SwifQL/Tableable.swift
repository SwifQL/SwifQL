//
//  Tableable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation

public protocol Tableable: Codable {
    /// This model's unique name. By default, this property is set to a `String` describing the type.
    /// Override this property to change the model's table / collection name for all of Fluent.
    static var tableName: String { get }
    
    static var schemaName: String? { get }
}

// MARK: Optional

extension Tableable {
    /// See `SwifQLTable`.
    public static var tableName: String {
        String(describing: Self.self)
    }
    
    public static var schemaName: String? {
        nil
    }
    
    public static func column(_ paths: String...) -> Path.TableWithColumn {
        Path.Table(tableName, schema: schemaName).column(paths)
    }
}
