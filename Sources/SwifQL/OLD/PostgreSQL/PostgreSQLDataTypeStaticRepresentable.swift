//import Foundation
//import Core
//
///// Statically representable as a `PostgreSQLDataType`.
//public protocol PostgreSQLDataTypeStaticRepresentable {
//    /// Appropriate PostgreSQL column type for storing this type.
//    static var postgreSQLDataType: PostgreSQLDataType { get }
//}
//
///// MARK: Default Implementations
//
//extension Data: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bytea }
//}
//
//extension UUID: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .uuid }
//}
//
//extension Date: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .timestamp }
//}
//
//extension Int: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bigint }
//}
//
//extension Int8: PostgreSQLDataTypeStaticRepresentable  {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType {
//        // PSQL has no single byte int type
//        return .smallint
//    }
//}
//
//extension Int16: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .smallint }
//}
//
//extension Int32: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .int }
//}
//
//extension Int64: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bigint }
//}
//
//extension UInt: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bigint }
//}
//
//extension UInt8: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType {
//        // PSQL has no single byte int type
//        return .smallint
//    }
//}
//
//extension UInt16: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .smallint }
//}
//
//extension UInt32: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .int }
//}
//
//extension UInt64: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bigint }
//}
//
//extension Float: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .real }
//}
//
//extension Double: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .doublePrecision }
//}
//
//extension String: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .text }
//}
//
//extension Bool: PostgreSQLDataTypeStaticRepresentable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .bool }
//}
//
//extension PostgreSQLPoint: PostgreSQLDataTypeStaticRepresentable, ReflectionDecodable {
//    /// See `PostgreSQLDataTypeStaticRepresentable`.
//    public static var postgreSQLDataType: PostgreSQLDataType { return .point }
//    
//    /// See `ReflectionDecodable`.
//    public static func reflectDecoded() throws -> (PostgreSQLPoint, PostgreSQLPoint) {
//        return (.init(x: 0, y: 0), .init(x: 1, y: 1))
//    }
//}
