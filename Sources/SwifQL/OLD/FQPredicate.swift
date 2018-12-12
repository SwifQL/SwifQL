//import Foundation
//import Fluent
//
//protocol FQPredicateValueProtocol : CustomStringConvertible, Equatable {
//    var value: Any? { get }
//}
//
//public protocol FQPredicateGenericType: FQPart {
//    var query: String { get }
//}
//
//public class FQJoinPredicate<T, U>: FQPart, FQPredicateGenericType where T: FQUniversalKeyPath, U: FQUniversalKeyPath {
//    public var query: String
//    
//    public init(lhs: T, operation: FluentQueryPredicateOperator, rhs: U) {
//        query = "\(lhs.queryValue) \(operation.rawValue) \(rhs.queryValue)"
//    }
//    
//    //Aggreagate
//    public init (lhs: FQAggregate.FunctionWithKeyPath<T>, operation: FluentQueryPredicateOperator, rhs: U) {
//        query = "\(lhs.func) \(operation.rawValue) \(rhs.queryValue)"
//    }
//}
//
//public class FQPredicate<T>: FQPart, FQPredicateGenericType  where T: FQUniversalKeyPath {
//    public enum FQPredicateValue: FQPredicateValueProtocol {
//        case simple(T.AType)
//        case simpleOptional(T.AType?)
//        case simpleAny(Any)
//        case array([T.AType])
//        case arrayOfOptionals([T.AType?])
//        case arrayOfAny([Any])
//        case string(String)
//        
//        public var description: String {
//            let description: String
//            switch self {
//            case .simple:
//                description = "simple"
//            case .simpleOptional:
//                description = "simpleOptional"
//            case .simpleAny:
//                description = "simpleAny"
//            case .array:
//                description = "array"
//            case .arrayOfOptionals:
//                description = "arrayOfOptionals"
//            case .arrayOfAny:
//                description = "arrayOfAny"
//            case .string:
//                description = "string"
//            }
//            return description
//        }
//        
//        var value: Any? {
//            let value: Any?
//            switch self {
//            case let .simple(v):
//                value = v
//            case let .simpleOptional(v):
//                value = v
//            case let .simpleAny(v):
//                value = v
//            case let .array(v):
//                value = v
//            case let .arrayOfOptionals(v):
//                value = v
//            case let .arrayOfAny(v):
//                value = v
//            case let .string(v):
//                value = v
//            }
//            return value
//        }
//        
//        public static func ==(lhs: FQPredicateValue, rhs: FQPredicateValue) -> Bool {
//            return lhs.description == rhs.description
//        }
//    }
//    var operation: FluentQueryPredicateOperator
//    var value: FQPredicateValue
//    var property: String
//    public init (kp: T, operation: FluentQueryPredicateOperator, value: FQPredicateValue) {
//        self.property = kp.queryValue
//        self.operation = operation
//        self.value = value
//    }
//    
//    public init (kp func: FQAggregate.FunctionWithKeyPath<T>, operation: FluentQueryPredicateOperator, value: FQPredicateValue) {
//        self.property = `func`.func
//        self.operation = operation
//        self.value = value
//    }
//    
//    private func formatValue(_ v: Any?) -> String {
//        guard let v = v else {
//            return "NULL"
//        }
//        switch v {
//        case is String:
//            if let v = v as? String {
//                if let first = v.first {
//                    if "\(first)" == "(" {
//                        return v
//                    }
//                }
//            }
//            return String.singleQuotted(v)
//        case is UUID: if let v = v as? UUID { return v.uuidString.singleQuotted } else { fallthrough }
//        case is Bool: if let v = v as? Bool { return v ? "TRUE" : "FALSE" } else { fallthrough }
//        case is Date: if let date = v as? Date {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            return String.singleQuotted(formatter.string(from: date))
//        } else { fallthrough }
//        case is Int: if let v = v as? Int { return "\(v)" } else { fallthrough }
//        case is Int8: if let v = v as? Int8 { return "\(v)" } else { fallthrough }
//        case is Int16: if let v = v as? Int16 { return "\(v)" } else { fallthrough }
//        case is Int32: if let v = v as? Int32 { return "\(v)" } else { fallthrough }
//        case is Int64: if let v = v as? Int64 { return "\(v)" } else { fallthrough }
//        case is UInt: if let v = v as? UInt { return "\(v)" } else { fallthrough }
//        case is UInt8: if let v = v as? UInt8 { return "\(v)" } else { fallthrough }
//        case is UInt16: if let v = v as? UInt16 { return "\(v)" } else { fallthrough }
//        case is UInt32: if let v = v as? UInt32 { return "\(v)" } else { fallthrough }
//        case is UInt64: if let v = v as? UInt64 { return "\(v)" } else { fallthrough }
//        case is Float: if let v = v as? Float { return "\(v)" } else { fallthrough }
//        case is Double: if let v = v as? Double { return "\(v)" } else { fallthrough }
//        default: return "\(v)"
//        }
//    }
//    
//    public func formatProperty() -> String {
//        if T.AType.self is [String].Type{
//            return "array_to_string(".appending(property).appending(", ',') ")
//        }
//        return property
//    }
//    
//    public var query: String {
//        var result = "\(formatProperty()) \(operation.rawValue) "
//        switch value {
//        case .simpleAny(let v):
//            result.append(formatValue(v))
//        case .simple(let v):
//            result.append(formatValue(v))
//        case .simpleOptional(let v):
//            result.append(formatValue(v))
//        case .array(let v):
//            result.append( v.map { "\(formatValue($0))" }.joined(separator: ",").roundBracketted )
//        case .arrayOfOptionals(let v):
//            result.append( v.map { "\(formatValue($0))" }.joined(separator: ",").roundBracketted )
//        case .arrayOfAny(let v):
//            if operation == .inFulltext {
//                result.append("to_tsquery")
//            }
//            result.append( v.map { "\(formatValue($0))" }.joined(separator: ",").roundBracketted )
//        case .string(let v):
//            result.append(formatValue(v))
//        }
//        return result
//            .replacingOccurrences(of: "!= NULL", with: "IS NOT NULL")
//            .replacingOccurrences(of: "= NULL", with: "IS NULL")
//            .replacingOccurrences(of: "!= nil", with: "IS NOT NULL")
//            .replacingOccurrences(of: "= nil", with: "IS NULL")
//    }
//}
//
//// AND
//public func && (lhs: FQPredicateGenericType, rhs: FQPredicateGenericType) -> FQWhere {
//    return FQWhere(lhs).and(rhs)
//}
//public func && (lhs: FQPredicateGenericType, rhs: FQWhere) -> FQWhere {
//    return FQWhere(lhs).and(rhs)
//}
//public func && (lhs: FQWhere, rhs: FQPredicateGenericType) -> FQWhere {
//    return lhs.and(rhs)
//}
//public func && (lhs: FQWhere, rhs: FQWhere) -> FQWhere {
//    return lhs.and(rhs)
//}
//
//// OR
//public func || (lhs: FQPredicateGenericType, rhs: FQPredicateGenericType) -> FQWhere {
//    return FQWhere(lhs).or(rhs)
//}
//public func || (lhs: FQPredicateGenericType, rhs: FQWhere) -> FQWhere {
//    return FQWhere(lhs).or(rhs)
//}
//public func || (lhs: FQWhere, rhs: FQPredicateGenericType) -> FQWhere {
//    return lhs.or(rhs)
//}
//public func || (lhs: FQWhere, rhs: FQWhere) -> FQWhere {
//    return lhs.or(rhs)
//}
//
//// ==
//public func == <T>(lhs: T, rhs:T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .equal, value: .simpleOptional(rhs))
//}
//public func == <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .equal, value: .simpleAny(rhs.rawValue))
//}
//public func == <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .equal, value: .simpleAny(rhs))
//}
//// == for join
//public func == <T, U>(lhs: T, rhs: U) -> FQPredicateGenericType where T: FQUniversalKeyPath, U: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .equal, rhs: rhs)
//}
//// == aggregate function
//public func == <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .equal, value: .simpleAny(rhs))
//}
//public func == <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .equal, value: .string(rhs.query.roundBracketted))
//}
//public func == <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .equal, rhs: rhs)
//}
//
//// !=
//public func != <T>(lhs: T, rhs: T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notEqual, value: .simpleOptional(rhs))
//}
//public func != <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .notEqual, value: .simpleAny(rhs.rawValue))
//}
//public func != <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .notEqual, value: .simpleAny(rhs))
//}
//// != for join
//public func != <T, U>(lhs: T, rhs: U) -> FQPredicateGenericType where T: FQUniversalKeyPath, U: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .notEqual, rhs: rhs)
//}
//// != aggregate function
//public func != <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .notEqual, value: .simpleAny(rhs))
//}
//public func != <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notEqual, value: .string(rhs.query.roundBracketted))
//}
//public func != <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .notEqual, rhs: rhs)
//}
//
//// >
//public func > <T>(lhs: T, rhs: T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .greaterThan, value: .simpleOptional(rhs))
//}
//public func > <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .greaterThan, value: .simpleAny(rhs.rawValue))
//}
//public func > <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .greaterThan, value: .simpleAny(rhs))
//}
//// > aggregate function
//public func > <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .greaterThan, value: .simpleAny(rhs))
//}
//public func > <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .greaterThan, value: .string(rhs.query.roundBracketted))
//}
//public func > <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .greaterThan, rhs: rhs)
//}
//
//// <
//public func < <T>(lhs: T, rhs: T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .lessThan, value: .simpleOptional(rhs))
//}
//public func < <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .lessThan, value: .simpleAny(rhs.rawValue))
//}
//public func < <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .lessThan, value: .simpleAny(rhs))
//}
//// < aggregate function
//public func < <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .lessThan, value: .simpleAny(rhs))
//}
//public func < <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .lessThan, value: .string(rhs.query.roundBracketted))
//}
//public func < <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .lessThan, rhs: rhs)
//}
//
//// >=
//public func >= <T>(lhs: T, rhs: T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .greaterThanOrEqual, value: .simpleOptional(rhs))
//}
//public func >= <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .greaterThanOrEqual, value: .simpleAny(rhs.rawValue))
//}
//public func >= <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .greaterThanOrEqual, value: .simpleAny(rhs))
//}
//// >= aggregate function
//public func >= <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .greaterThanOrEqual, value: .simpleAny(rhs))
//}
//public func >= <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .greaterThanOrEqual, value: .string(rhs.query.roundBracketted))
//}
//public func >= <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .greaterThanOrEqual, rhs: rhs)
//}
//
//// <=
//public func <= <T>(lhs: T, rhs: T.AType?) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .lessThanOrEqual, value: .simpleOptional(rhs))
//}
//public func <= <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .lessThanOrEqual, value: .simpleAny(rhs.rawValue))
//}
//public func <= <T>(lhs: T, rhs: T.AType.RawValue) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .lessThanOrEqual, value: .simpleAny(rhs))
//}
//
//// <= aggregate function
////TODO: should be implemented in reverse way too, like lhs: K, rhs: FQAggregate.FunctionWithKeyPath
//public func <= <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: K) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .lessThanOrEqual, value: .simpleAny(rhs))
//}
//public func <= <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .lessThanOrEqual, value: .string(rhs.query.roundBracketted))
//}
//public func <= <M, T>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: T) -> FQPredicateGenericType where M: FQUniversalKeyPath, T: FQUniversalKeyPath {
//    return FQJoinPredicate(lhs: lhs, operation: .lessThanOrEqual, rhs: rhs)
//}
//
//// IN
//infix operator ~~ : AdditionPrecedence
//public func ~~ <T>(lhs: T, rhs: [T.AType?]) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .in, value: .arrayOfOptionals(rhs))
//}
//public func ~~ <T>(lhs: T, rhs: [T.AType]) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .in, value: .arrayOfAny(rhs.map { $0.rawValue }))
//}
//public func ~~ <T>(lhs: T, rhs: [T.AType.RawValue]) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .in, value: .arrayOfAny(rhs.map { $0 }))
//}
//// IN SUBQUERY
//public func ~~ <T>(lhs: T, rhs: FluentQuery) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .in, value: .string(rhs.query.roundBracketted))
//}
//// IN aggregate function
//public func ~~ <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: [K]) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .in, value: .arrayOfAny(rhs))
//}
//public func ~~ <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .in, value: .string(rhs.query.roundBracketted))
//}
//// FULLTEXT SEARCH
//infix operator ~~~ : AdditionPrecedence
//public func ~~~ <T>(lhs: T, rhs: [T.AType]) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .inFulltext, value: .arrayOfAny(rhs))
//}
//
//// NOT IN
//infix operator !~ : AdditionPrecedence
//public func !~ <T>(lhs: T, rhs: [T.AType?]) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .arrayOfOptionals(rhs))
//}
//public func !~ <T>(lhs: T, rhs: [T.AType]) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .arrayOfAny(rhs.map { $0.rawValue }))
//}
//public func !~ <T>(lhs: T, rhs: [T.AType.RawValue]) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: RawRepresentable {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .arrayOfAny(rhs.map { $0 }))
//}
//// NOT IN SUBQUERY
//public func !~ <T>(lhs: T, rhs: FluentQuery) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .string(rhs.query.roundBracketted))
//}
//// NOT IN aggregate function
//public func !~ <M, K>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: [K]) -> FQPredicateGenericType where M: FQUniversalKeyPath, K: Numeric {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .arrayOfAny(rhs))
//}
//public func !~ <M>(lhs: FQAggregate.FunctionWithKeyPath<M>, rhs: FluentQuery) -> FQPredicateGenericType where M: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notIn, value: .string(rhs.query.roundBracketted))
//}
//
//// LIKE
//infix operator ~= : AdditionPrecedence
//public func ~= <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("%\(rhs)"))
//}
//public func ~= <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("%\(rhs)"))
//}
//infix operator =~ : AdditionPrecedence
//public func =~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("\(rhs)%"))
//}
//public func =~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("\(rhs)%"))
//}
//public func ~~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("%\(rhs)%"))
//}
//public func ~~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .like, value: .string("%\(rhs)%"))
//}
//
//// ILIKE
//infix operator ~% : AdditionPrecedence
//public func ~% <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("%\(rhs)"))
//}
//public func ~% <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("%\(rhs)"))
//}
//infix operator %~ : AdditionPrecedence
//public func %~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("\(rhs)%"))
//}
//public func %~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("\(rhs)%"))
//}
//infix operator %% : AdditionPrecedence
//public func %% <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("%\(rhs)%"))
//}
//public func %% <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .ilike, value: .string("%\(rhs)%"))
//}
//
//// NOT LIKE
//infix operator !~= : AdditionPrecedence
//public func !~= <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("%\(rhs)"))
//}
//public func !~= <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("%\(rhs)"))
//}
//infix operator !=~ : AdditionPrecedence
//public func !=~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("\(rhs)%"))
//}
//public func !=~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("\(rhs)%"))
//}
//infix operator !~~ : AdditionPrecedence
//public func !~~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("%\(rhs)%"))
//}
//public func !~~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notLike, value: .string("%\(rhs)%"))
//}
//
//// NOT ILIKE
//infix operator !~% : AdditionPrecedence
//public func !~% <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("%\(rhs)"))
//}
//public func !~% <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("%\(rhs)"))
//}
//infix operator !%~ : AdditionPrecedence
//public func !%~ <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("\(rhs)%"))
//}
//public func !%~ <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("\(rhs)%"))
//}
//infix operator !%% : AdditionPrecedence
//public func !%% <T>(lhs: T, rhs: T.AType) -> FQPredicateGenericType where T: FQUniversalKeyPath {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("%\(rhs)%"))
//}
//public func !%% <T, E>(lhs: T, rhs: E) -> FQPredicateGenericType where T: FQUniversalKeyPath, T.AType: Collection, T.AType.Element: StringProtocol {
//    return FQPredicate(kp: lhs, operation: .notILike, value: .string("%\(rhs)%"))
//}
//
////FUTURE: create method which can handle two predicates
////FUTURE: generate paths like this `(r."carEquipment"->>'interior')::uuid` with type casting
////FUTURE: allow to pass array of functions like (lhs: T..., rhs: T)
