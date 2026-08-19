//
//  TableFunction.swift
//  SwifQL
//

import Foundation

/// A structured, caller-extensible table-function named parameter.
public struct TableFunctionOption: SwifQLable {
    /// An open identity for a native table-function parameter name.
    public struct Name: Hashable, Sendable {
        public let rawValue: String

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let name: Name
    public let value: SwifQLable

    public init(name: Name, value: SwifQLable) {
        self.name = name
        self.value = value
    }

    public init(_ name: Name, value: SwifQLable) {
        self.init(name: name, value: value)
    }

    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = [SwifQLPartOperator.custom(name.rawValue)]
        parts.append(o: .space, .equal, .space)
        parts.append(contentsOf: value.parts)
        return parts
    }

    public static func header(_ value: SwifQLable) -> Self {
        Self(name: Name("header"), value: value)
    }

    public static func header(_ value: Bool) -> Self {
        header(SwifQLBool(value))
    }

    public static func delimiter(_ value: SwifQLable) -> Self {
        Self(name: Name("delim"), value: value)
    }

    public static func sampleSize(_ value: SwifQLable) -> Self {
        Self(name: Name("sample_size"), value: value)
    }

    public static func unionByName(_ value: SwifQLable) -> Self {
        Self(name: Name("union_by_name"), value: value)
    }

    public static func unionByName(_ value: Bool) -> Self {
        unionByName(SwifQLBool(value))
    }

    public static func filename(_ value: SwifQLable) -> Self {
        Self(name: Name("filename"), value: value)
    }

    public static func filename(_ value: Bool) -> Self {
        filename(SwifQLBool(value))
    }

    public static func hivePartitioning(_ value: SwifQLable) -> Self {
        Self(name: Name("hive_partitioning"), value: value)
    }

    public static func hivePartitioning(_ value: Bool) -> Self {
        hivePartitioning(SwifQLBool(value))
    }

    public static func format(_ value: SwifQLable) -> Self {
        Self(name: Name("format"), value: value)
    }
}
