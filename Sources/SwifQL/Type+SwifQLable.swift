//
//  SwifQLable+Types.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

// MARK: - Types

extension String: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UUID: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Decimal: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Double: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Float: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UInt: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UInt8: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UInt16: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UInt32: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension UInt64: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Int: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Int8: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Int16: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Int32: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Int64: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartUnsafeValue(self)] }
}

extension Date: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartDate(self)] }
}

extension Data: SwifQLable {
    public var parts: [SwifQLPart] {
        return [
            SwifQLPartOperator("decode"),
            SwifQLPartOperator.openBracket,
            SwifQLPartSafeValue(base64EncodedString()),
            SwifQLPartOperator.comma,
            SwifQLPartOperator.space,
            SwifQLPartSafeValue("base64"),
            SwifQLPartOperator.closeBracket
        ]
    }
}

// MARK: - Protocols & Delegates
// MARK: - Optional

extension Optional: SwifQLable, CustomStringConvertible where Wrapped: SwifQLable {
  public var parts: [SwifQLPart] {
    switch self {
      case .none:
        return [SwifQLPartSafeValue(nil)]
      case .some(let value):
        return value.parts
    }
  }
}

// MARK: - RawRepresentable

public protocol SwifQLRawRepresentable: RawRepresentable, SwifQLable {}

extension SwifQLRawRepresentable {

    public var parts: [SwifQLPart] {
      guard let a = self.rawValue as? SwifQLable else { return [] }
      return a.parts
    }

}
