//
//  Column.swift
//  SwifQL
//
//  Created by Mihael Isaev on 26.01.2020.
//

import Foundation

public protocol AnyColumn {
    var name: String { get }
    var type: SwifQL.`Type` { get }
    var `default`: ColumnDefault? { get }
    var constraints: [Constraint] { get }
    var inputValue: Encodable? { get }
    var isChanged: Bool { get }
    func encode(to encoder: Encoder) throws
    func decode(from decoder: Decoder) throws
}

public protocol ColumnRepresentable {
    associatedtype Value: Codable
    var column: Column<Value> { get }
}

@propertyWrapper
public final class Column<Value>: AnyColumn, ColumnRepresentable, ColumnRootNameable, Encodable where Value: Codable {
    public let name: String
    public let type: SwifQL.`Type`
    public let `default`: ColumnDefault?
    public let constraints: [Constraint]
    
    var outputValue: Value?
    public internal(set) var inputValue: Encodable?
    public var isChanged: Bool = false
    
    public var column: Column<Value> { self }
    public var columnName: String { column.name }
    
    public var projectedValue: Column<Value> { self }
    
    public var wrappedValue: Value {
        get {
            if let value = self.inputValue {
                return value as! Value
            } else if let value = self.outputValue {
                return value
            } else {
                fatalError("Cannot access field before it is initialized or fetched")
            }
        }
        set {
            self.inputValue = newValue
            self.isChanged = true
        }
    }
    
    /// Type will be selected automatically based on Swift type
    public init(_ name: String, default: ColumnDefault? = nil, constraints: Constraint...) {
        let autoType = Self.autoType(constraints)
        self.name = name
        self.type = autoType.type
        self.default = `default`
        var constraints = constraints
        if !autoType.isOptional, !constraints.contains(where: { $0.isNotNull || $0.isPrimaryKey }) {
            constraints.append(.notNull)
        }
        self.constraints = constraints
    }
    
    public init(name: String, type: SwifQL.`Type`, default: ColumnDefault? = nil, constraints: Constraint...) {
        self.name = name
        self.type = type
        self.default = `default`
        self.constraints = constraints
    }
    
    /// See `Codable`
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public func decode(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let valueType = Value.self as? _Optional.Type {
            if container.decodeNil() {
                self.wrappedValue = (valueType._none as! Value)
            } else {
                self.wrappedValue = try container.decode(Value.self)
            }
        } else {
            self.wrappedValue = try container.decode(Value.self)
        }
        self.isChanged = false
    }
}

public struct ColumnDefault {
    let query: SwifQLable
    
    init (_ query: SwifQLable) {
        self.query = query
    }
    
    public static func `default`(_ v: Any) -> ColumnDefault {
        var parts: [SwifQLPart] = []
        parts.append(o: .default)
        parts.append(o: .space)
        parts.append(safe: v)
        return .init(SwifQLableParts(parts: parts))
    }
    
    public static func `default`(_ expression: SwifQLable) -> ColumnDefault {
        var parts: [SwifQLPart] = []
        parts.append(o: .default)
        parts.append(o: .space)
        parts.append(contentsOf: expression.parts)
        return .init(SwifQLableParts(parts: parts))
    }
    
    public static func `default`(sequence name: String) -> ColumnDefault {
        .init(SwifQLableParts(parts: Op.custom(name)))
    }
}

public protocol ColumnRoot {
    init ()
    
    static func key<C>(for column: KeyPath<Self, C>) -> String where C: ColumnRootNameable
}

extension ColumnRoot {
    public static func key<Column>(for column: KeyPath<Self, Column>) -> String where Column: ColumnRootNameable {
        Self.init()[keyPath: column].columnName
    }
}

public protocol ColumnRootNameable {
    var columnName: String { get }
}
