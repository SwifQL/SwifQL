//
//  Enum.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public protocol AnySwifQLEnum: Codable, SwifQLable {
    static var name: String { get }
    var anyRawValue: Any { get }
}

protocol AnySwifQLEnumArray {
    var items: [AnySwifQLEnum] { get }
}

extension Array: AnySwifQLEnumArray where Element: AnySwifQLEnum {
    var items: [AnySwifQLEnum] { self }
}

public protocol SwifQLEnum: AnySwifQLEnum, RawRepresentable, CaseIterable {
    static var name: String { get }
}

extension SwifQLEnum {
    public static var name: String { String(describing: Self.self).lowercased() }
    public var anyRawValue: Any { rawValue }
}

/// See `SwifQLable`
extension SwifQLEnum {
    public var parts: [SwifQLPart] { [SwifQLPartSafeValue(rawValue)] }
}

/// Allows to compare enum with enum column
///
/// Usage:
/// 
/// ```swift
/// \User.$status == UserStatus.banned
/// ```
public func == <A, B>(lhs: KeyPath<A, B>, rhs: B.Value.RawValue) -> SwifQLable
    where A: Table, B: ColumnRepresentable, B: ColumnRootNameable, B.Value: SwifQLEnum {
    SwifQLPredicate(operator: .equal, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartSafeValue(rhs)))
}
