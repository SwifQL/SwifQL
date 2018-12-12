//import Foundation
//
///// A 2-dimenstional (double[2]) point.
//public struct PostgreSQLPoint: Codable, Equatable {
//    /// The point's x coordinate.
//    public var x: Double
//
//    /// The point's y coordinate.
//    public var y: Double
//
//    /// Create a new `Point`
//    public init(x: Double, y: Double) {
//        self.x = x
//        self.y = y
//    }
//}
//
//extension PostgreSQLPoint: CustomStringConvertible {
//    /// See `CustomStringConvertible`.
//    public var description: String {
//        return "(\(x),\(y))"
//    }
//}
//
//extension PostgreSQLPoint: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> PostgreSQLPoint {
//        guard case .point = data.type else {
//            throw PostgreSQLError.decode(self, from: data)
//        }
//        switch data.storage {
//        case .text(let string):
//            let parts = string.split(separator: ",")
//            var x = parts[0]
//            var y = parts[1]
//            let leftParen = x.popFirst()
//            assert(leftParen == "(")
//            let rightParen = y.popLast()
//            assert(rightParen == ")")
//            return .init(x: Double(x)!, y: Double(y)!)
//        case .binary(let value):
//            let x = value[0..<8]
//            let y = value[8..<16]
//            return .init(x: x.as(Double.self, default: 0), y: y.as(Double.self, default: 0))
//        case .null: throw PostgreSQLError.decode(self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return PostgreSQLData(.point, binary: Data.of(x) + Data.of(y))
//    }
//}
