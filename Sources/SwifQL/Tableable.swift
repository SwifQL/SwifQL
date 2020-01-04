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
    static var entity: String { get }
}

// MARK: Optional

extension Tableable {
    /// See `SwifQLTable`.
    static var entity: String {
        return String(describing: Self.self)
    }
    
    public static func column(_ paths: String...) -> Column {
        Column(entity, paths)
    }
}
