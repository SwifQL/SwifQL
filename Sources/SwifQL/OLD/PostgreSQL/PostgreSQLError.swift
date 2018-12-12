//import Debugging
//
///// Errors that can be thrown while working with PostgreSQL.
//public struct PostgreSQLError: Debuggable {
//    /// See `Debuggable`.
//    public static let readableName = "PostgreSQL Error"
//    
//    /// Error communicating with PostgreSQL wire-protocol
//    static func `protocol`(reason: String) -> PostgreSQLError {
//        return .init(identifier: "protocol", reason: reason)
//    }
//    
//    /// Error communicating with PostgreSQL wire-protocol
//    static func decode<T>(_ type: T.Type, from data: PostgreSQLData) -> PostgreSQLError {
//        return .init(identifier: "decode", reason: "Could not decode \(T.self): \(data).")
//    }
//    
//    /// See `Debuggable`.
//    public let identifier: String
//    
//    /// See `Debuggable`.
//    public var reason: String
//    
//    /// See `Debuggable`.
//    public var sourceLocation: SourceLocation
//    
//    /// See `Debuggable`.
//    public var stackTrace: [String]
//    
//    /// See `Debuggable`.
//    public var possibleCauses: [String]
//    
//    /// See `Debuggable`.
//    public var suggestedFixes: [String]
//
//    /// Create a new `PostgreSQLError`.
//    public init(
//        identifier: String,
//        reason: String,
//        possibleCauses: [String] = [],
//        suggestedFixes: [String] = [],
//        file: String = #file,
//        function: String = #function,
//        line: UInt = #line,
//        column: UInt = #column
//    ) {
//        self.identifier = identifier
//        self.reason = reason
//        self.sourceLocation = SourceLocation(file: file, function: function, line: line, column: column, range: nil)
//        self.stackTrace = PostgreSQLError.makeStackTrace()
//        self.possibleCauses = possibleCauses
//        self.suggestedFixes = suggestedFixes
//    }
//}
//
///// Only includes the supplied closure in non-release builds.
//internal func debugOnly(_ body: () -> Void) {
//    assert({ body(); return true }())
//}
//
///// Logs a runtime warning.
//internal func WARNING(_ string: @autoclosure () -> String) {
//    print("[WARNING] [PostgreSQL] \(string())")
//}
//
///// Logs a runtime error.
//internal func ERROR(_ string: @autoclosure () -> String) {
//    print("[Error] [PostgreSQL] \(string())")
//}
//
//func VERBOSE(_ string: @autoclosure () -> (String)) {
//    #if VERBOSE
//    print("[VERBOSE] [PostgreSQL] \(string())")
//    #endif
//}
