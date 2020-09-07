//
//  Enum.swift
//  SwifQL
//
//  Created by Mihael Isaev on 27.01.2020.
//

import Foundation

public protocol AnySwifQLEnum {
    static var name: String { get }
}

public protocol SwifQLEnum: AnySwifQLEnum, RawRepresentable, Codable, CaseIterable, SwifQLable {
    static var name: String { get }
}

extension SwifQLEnum {
    public static var name: String { String(describing: Self.self).lowercased() }
}

/// See `SwifQLable`
extension SwifQLEnum {
    public var parts: [SwifQLPart] { [SwifQLPartOperator("'\(rawValue)'")] }
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
