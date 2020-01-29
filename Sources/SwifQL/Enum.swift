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
    public static var name: String { String(describing: self).lowercased() }
}

/// See `SwifQLable`
extension SwifQLEnum {
    public var parts: [SwifQLPart] { [SwifQLPartOperator("'\(rawValue)'")] }
}
