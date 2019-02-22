//
//  SwifQLable+Types.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

extension String: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UUID: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Decimal: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Double: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Float: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UInt: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UInt8: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UInt16: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UInt32: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension UInt64: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Int: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Int8: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Int16: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Int32: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
extension Int64: SwifQLable {
    public var parts: [SwifQLPart] { return [SwifQLPartUnsafeValue(self)] }
}
public protocol SwifQLRawRepresentable: RawRepresentable, SwifQLable {}
extension SwifQLRawRepresentable {
    public var parts: [SwifQLPart] {
        if let a = self.rawValue as? SwifQLable {
            return a.parts
        }
        return []
    }
}
