//import Foundation
//import Fluent
//
//public class FQJSON: FQPart {
//    class ForSelectField: FQPart {
//        var object: FQJSON
//        var asKey: String?
//        init (_ object: FQJSON, as asKey: String? = nil) {
//            self.object = object
//            self.asKey = asKey
//        }
//        var query: String {
//            var result = object.query
//            if let asKey = asKey {
//                result.append(" as \(asKey.doubleQuotted)")
//            }
//            return result
//        }
//    }
//
//    public init() {}
//    
//    var fields: [FQPart] = []
//
//    @discardableResult
//    public func field(_ key: String, raw: String) -> Self {
//        fields.append("\(key.singleQuotted), \(raw.roundBracketted)")
//        return self
//    }
//
//    @discardableResult
//    public func field(_ key: String, _ value: String) -> Self {
//        fields.append("\(key.singleQuotted), \(value.singleQuotted)")
//        return self
//    }
//
//    @discardableResult
//    public func field(_ key: String, _ value: Int) -> Self {
//        fields.append("\(key.singleQuotted), \(String(describing: value))")
//        return self
//    }
//
//    @discardableResult
//    public func field(_ key: String, _ value: Bool) -> Self {
//        fields.append("\(key.singleQuotted), \(String(describing: value))")
//        return self
//    }
//
//    @discardableResult
//    public func field(_ key: String, _ value: FQPart) -> Self {
//        fields.append("\(key.singleQuotted), \(value.query)")
//        return self
//    }
//
//    @discardableResult
//    public func field<T>(_ key: String, _ value: FQPart, checkIfModelNull: T.Type) -> Self where T: Model {
//        fields.append("\(key.singleQuotted), CASE WHEN \(checkIfModelNull.FQType.alias.doubleQuotted) IS NULL THEN NULL ELSE \(value.query) END")
//        return self
//    }
//
//    @discardableResult
//    public func field<T>(_ key: String, _ value: FQPart, checkIfModelNull: FQAlias<T>) -> Self where T: Model {
//        fields.append("\(key.singleQuotted), CASE WHEN \(checkIfModelNull.alias.doubleQuotted) IS NULL THEN NULL ELSE \(value.query) END")
//        return self
//    }
//
//    @discardableResult
//    public func field<T, V>(_ key: String, _ kp: KeyPath<T, V>) -> Self where T: Model {
//        return field(key, T.self, kp)
//    }
//
//    @discardableResult
//    public func field<T, V>(_ key: String, _ aliased: AliasedKeyPath<T, V>) -> Self where T: Model {
//        fields.append("\(key.singleQuotted), \(FluentQuery.formattedPath(aliased.query, aliased.kp))")
//        return self
//    }
//
//    //MARK: Func
//    @discardableResult
//    public func field<T, V>(_ key: String, func: FuncOptionKP<T, V>) -> Self where T: Model {
//        return field(key, raw: `func`.func)
//    }
//    @discardableResult
//    public func field<T, V>(_ key: String, func: FuncOptionAKP<T, V>) -> Self where T: Model {
//        return field(key, raw: `func`.func)
//    }
//    @discardableResult
//    public func field<T>(_ key: String, func: FunctionWithModelAlias<T>) -> Self where T: Model {
//        return field(key, raw: `func`.func)
//    }
//    @discardableResult
//    public func field<T>(_ key: String, func: FunctionWithModel<T>) -> Self where T: Model {
//        return field(key, raw: `func`.func)
//    }
//    @discardableResult
//    public func field<T>(_ key: String, func: FunctionWithSubquery<T>) -> Self where T: Model {
//        return field(key, raw: `func`.func)
//    }
//
//    @discardableResult
//    public func field<T, V>(_ key: String, _ kp: KeyPath<T, V>, func: String, valueKey: String = "%") -> Self where T: Model {
//        return field(key, T.self, kp, func: `func`, valueKey: valueKey)
//    }
//
//    @discardableResult
//    public func field<T, V>(_ key: String, _ table: T.Type, _ kp: KeyPath<T, V>, func: String, valueKey: String = "%") -> Self where T: Model {
//        return field(key, raw: `func`.replacingOccurrences(of: valueKey, with: FluentQuery.formattedPath(table, kp)))
//    }
//
//    //MARK: Count with filter
//    @discardableResult
//    public func field<T, V>(_ key: String, count kp: KeyPath<T, V>, _ wheres: FQWhere...) -> Self where T: Model {
//        return field(key, T.self, kp) //TODO: implement JSON field COUNT(_) filter (where _)
//    }
//
//    @discardableResult
//    public func field<T, V>(_ key: String, _ table: T.Type, _ kp: KeyPath<T, V>) -> Self where T: Model {
//        fields.append("\(key.singleQuotted), \(FluentQuery.formattedPath(table, kp))")
//        return self
//    }
//
//    public var query: String {
//        var result = "jsonb_build_object"
//        result.append("(")
//        for (index, field) in fields.enumerated() {
//            if index > 0 {
//                result.append(",")
//            }
//            result.append(field.query)
//        }
//        result.append(")")
//        return result
//    }
//}
//
//protocol FQJSONFuncOption : CustomStringConvertible, Equatable {
//    var value: Any { get }
//}
//
//extension FQJSON {
//    //MARK: Original functions
//    public enum Functions: FQJSONFuncOption {
//        typealias KPAndWheres = (kp: String, wheres: String)
//
//        case row(String) //m
//        case rows(String) //m
//        case toJSON(String) //m
//        case jsonAgg(String) //m
//        case extractEpochFromTime(String) //kp
//        case count(String) //kp
//        case countWhere(String, String) //kp, w
//        case empty() //temporary
//
//        public var description: String {
//            let description: String
//            switch self {
//            case .row:
//                description = "SELECT to_jsonb(%)"
//            case .rows:
//                description = "SELECT COALESCE(jsonb_agg(%) FILTER (WHERE % IS NOT NULL), $$[]$$::JSONB)"
//                //description = "SELECT COALESCE(jsonb_agg(%) FILTER (WHERE % IS NOT NULL), $$[]$$::JSONB)"
//            case .toJSON:
//                description = "to_jsonb(%)"
//            case .jsonAgg:
//                description = "SELECT COALESCE(jsonb_agg(%) FILTER (WHERE % IS NOT NULL), $$[]$$::JSONB)"//"jsonb_agg(%)"
//            case .extractEpochFromTime:
//                description = "extract(epoch from %)"
//            case .count:
//                description = "COUNT(%)"
//            case .countWhere:
//                description = "COUNT(%) filter (where $)"
//            case .empty:
//                description = ""
//            }
//            return description
//        }
//
//        var `func`: String {
//            let valueKey = "%"
//            let whereKey = "$"
//            switch self {
//            case .row: fallthrough
//            case .rows: fallthrough
//            case .toJSON: fallthrough
//            case .jsonAgg: fallthrough
//            case .extractEpochFromTime: fallthrough
//            case .count:
//                return description.replacingOccurrences(of: valueKey, with: "\(value)")
//            case .countWhere:
//                if let sss = value as? KPAndWheres {
//                    return description
//                        .replacingOccurrences(of: valueKey, with: sss.kp)
//                        .replacingOccurrences(of: whereKey, with: sss.wheres)
//                }
//                return "<error>"
//            case .empty: return "<empty>"
//            }
//        }
//
//        var value: Any {
//            let value: Any
//            switch self {
//            case let .row(b):
//                value = b
//            case let .rows(b):
//                value = b
//            case let .toJSON(b):
//                value = b
//            case let .jsonAgg(b):
//                value = b
//            case let .extractEpochFromTime(t):
//                value = t
//            case let .count(v):
//                value = v
//            case let .countWhere(v):
//                value = KPAndWheres(kp: v.0, wheres: v.1)
//            case .empty:
//                value = ""
//            }
//            return value
//        }
//
//        public static func ==(lhs: Functions, rhs: Functions) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror KeyPath based functions
//    public enum FuncOptionKP<T, V>: FQJSONFuncOption where T: Model {
//        typealias KPAndWheres = (kp: KeyPath<T, V>, wheres: FQWhere)
//
//        case extractEpochFromTime(KeyPath<T, V>)
//        case count(KeyPath<T, V>)
//        case countWhere(KeyPath<T, V>, FQWhere)
//
//        private func formattedPath(_ kp: KeyPath<T, V>) -> String {
//            return FluentQuery.formattedPath(T.self, kp)
//        }
//
//        var mirror: Functions {
//            switch self {
//            case .extractEpochFromTime(let kp): return .extractEpochFromTime(formattedPath(kp))
//            case .count(let kp): return .count(formattedPath(kp))
//            case .countWhere(let v): return .countWhere(formattedPath(v.0), v.1.query)
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FuncOptionKP, rhs: FuncOptionKP) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror AliasedKeyPath based functions
//    public enum FuncOptionAKP<T, V>: FQJSONFuncOption where T: Model {
//        typealias KPAndWheres = (kp: AliasedKeyPath<T, V>, wheres: FQWhere)
//
//        case extractEpochFromTime(AliasedKeyPath<T, V>)
//        case count(AliasedKeyPath<T, V>)
//        case countWhere(AliasedKeyPath<T, V>, FQWhere)
//
//        var mirror: Functions {
//            switch self {
//            case .extractEpochFromTime(let kp): return .extractEpochFromTime(kp.query)
//            case .count(let kp): return .count(kp.query)
//            case .countWhere(let v): return .countWhere(v.0.query, v.1.query)
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FuncOptionAKP, rhs: FuncOptionAKP) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror for ModelAlias only based functions
//    public enum FunctionWithModelAlias<T>: FQJSONFuncOption where T: Model {
//        case row(FQAlias<T>)
//        case rows(FQAlias<T>)
//        case toJSON(FQAlias<T>)
//        case none()
//
//        var mirror: Functions {
//            switch self {
//            case .row(let v): return .row("\(v.alias.doubleQuotted)")
//            case .rows(let v): return .rows("\(v.alias.doubleQuotted)")
//            case .toJSON(let v): return .toJSON("\(v.alias.doubleQuotted)")
//            case .none: return .empty()
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FunctionWithModelAlias, rhs: FunctionWithModelAlias) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror for Model only based functions
//    public enum FunctionWithModel<T>: FQJSONFuncOption where T: Model {
//        case row(T.Type)
//        case rows(T.Type)
//        case none()
//
//        var mirror: Functions {
//            switch self {
//            case .row: return .row("\(T.FQType.alias.doubleQuotted)")
//            case .rows: return .rows("\(T.FQType.alias.doubleQuotted)")
//            case .none: return .empty()
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FunctionWithModel, rhs: FunctionWithModel) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror for Model only based functions
//    public enum FunctionWithSubquery<T>: FQJSONFuncOption where T: FQPart {
//        case row(T)
//        case rows(T)
//        case jsonAgg(T)
//
//        var mirror: Functions {
//            switch self {
//            case .row(let v): return .row("\(v.query.roundBracketted)")
//            case .rows(let v): return .rows("\(v.query.roundBracketted)")
//            case .jsonAgg(let v): return .jsonAgg("\(v.query.roundBracketted)")
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FunctionWithSubquery, rhs: FunctionWithSubquery) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//
//    //MARK: Mirror for FunctionWithModelAlias functions
//    public enum FunctionWithFunctionWithModelAlias<T>: FQJSONFuncOption where T: Model {
//        case toJSON(FunctionWithModelAlias<T>)
//        case jsonAgg(FunctionWithModelAlias<T>)
//
//        var mirror: Functions {
//            switch self {
//            case .toJSON(let v): return .toJSON("\(v.func.query.roundBracketted)")
//            case .jsonAgg(let v): return .jsonAgg("\(v.func.query.roundBracketted)")
//            }
//        }
//
//        public var description: String {
//            return mirror.description
//        }
//
//        var `func`: String {
//            return mirror.func
//        }
//
//        var value: Any {
//            return mirror.value
//        }
//
//        public static func ==(lhs: FunctionWithFunctionWithModelAlias, rhs: FunctionWithFunctionWithModelAlias) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//}
