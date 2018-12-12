///// Capable of being converted to/from `PostgreSQLData`
//public protocol PostgreSQLDataConvertible {
//    /// Creates a `Self` from the supplied `PostgreSQLData`
//    static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Self
//
//    /// Converts `Self` to a `PostgreSQLData`
//    func convertToPostgreSQLData() throws -> PostgreSQLData
//}
//
//extension PostgreSQLData {
//    /// Gets a `String` from the supplied path or throws a decoding error.
//    public func decode<T>(_ type: T.Type) throws -> T where T: PostgreSQLDataConvertible {
//        return try T.convertFromPostgreSQLData(self)
//    }
//}
//
//extension PostgreSQLData: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> PostgreSQLData {
//        return data
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return self
//    }
//}
//
//extension RawRepresentable where RawValue: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Self {
//        let aRawValue = try RawValue.convertFromPostgreSQLData(data)
//        guard let enumValue = Self(rawValue: aRawValue) else {
//            throw PostgreSQLError(identifier: "invalidRawValue", reason: "Unable to decode RawRepresentable from the database value.")
//        }
//        return enumValue
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return try self.rawValue.convertToPostgreSQLData()
//    }
//}
