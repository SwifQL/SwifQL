//import Foundation
//import Fluent
//
//public class FQOrderBy: FQPart {
//    public enum Mode {
//        case descending, ascending, desc, asc
//        
//        var query: String {
//            switch self {
//            case .descending: fallthrough
//            case .desc: return "DESC"
//            case .ascending: fallthrough
//            case .asc: return "ASC"
//            }
//        }
//    }
//    
//    public struct Data: FQPart, OrderByDataProtocol {
//        var path: String
//        var mode: Mode
//        
//        public init<T>(_ kp: T, _ mode: Mode) where T: FQUniversalKeyPath {
//            self.path = kp.queryValue
//            self.mode = mode
//        }
//        
//        public init(_ rawKP: String, _ mode: Mode) {
//            self.path = rawKP
//            self.mode = mode
//        }
//        
//        public var query: String {
//            return "\(path) \(mode.query)"
//        }
//    }
//    
//    var parts: [OrderByDataProtocol] = []
//    
//    public init(copy from: FQOrderBy? = nil) {
//        if let from = from {
//            parts = from.parts.map { $0 }
//        }
//    }
//    
//    public init<T>(_ kp: T, _ mode: Mode) where T: FQUniversalKeyPath {
//        add(kp, mode)
//    }
//    
//    public init(_ enums: OrderByEnum...) {
//        parts.append(contentsOf: enums)
//    }
//    
//    public init(_ enums: [OrderByEnum]) {
//        parts.append(contentsOf: enums)
//    }
//    
//    @discardableResult
//    public func add<T>(_ kp: T, _ mode: Mode) -> Self where T: FQUniversalKeyPath {
//        parts.append(Data(kp, mode))
//        return self
//    }
//    
//    @discardableResult
//    public func add(_ enums: OrderByEnum...) -> Self {
//        parts.append(contentsOf: enums)
//        return self
//    }
//    
//    @discardableResult
//    public func add(_ enums: [OrderByEnum]) -> Self {
//        parts.append(contentsOf: enums)
//        return self
//    }
//    
//    @discardableResult
//    public func and<T>(_ kp: T, _ mode: Mode) -> Self where T: FQUniversalKeyPath {
//        return add(kp, mode)
//    }
//    
//    @discardableResult
//    public func and(_ enums: OrderByEnum...) -> Self {
//        return add(enums)
//    }
//    
//    @discardableResult
//    public func and(_ enums: [OrderByEnum]) -> Self {
//        return add(enums)
//    }
//    
//    //MARK: Allow to use raw keypaths
//    
//    public init(_ rawKP: String, _ mode: Mode) {
//        add(rawKP, mode)
//    }
//    
//    @discardableResult
//    public func add(_ rawKP: String, _ mode: Mode) -> Self {
//        parts.append(Data(rawKP, mode))
//        return self
//    }
//    
//    @discardableResult
//    public func and(_ rawKP: String, _ mode: Mode) -> Self {
//        return add(rawKP, mode)
//    }
//    
//    public var query: String {
//        return parts.map { $0.query }.joined(separator: ", ")
//    }
//    
//    public func joinAnotherInstance(_ inst: FQOrderBy) {
//        if inst.parts.count > 0 {
//            parts.append(contentsOf: inst.parts)
//        }
//    }
//}
//
//protocol OrderByDataProtocol {
//    var query: String { get }
//}
//
//public enum OrderByEnum: CustomStringConvertible, Equatable, OrderByDataProtocol {
//    public static func == (lhs: OrderByEnum, rhs: OrderByEnum) -> Bool {
//        return lhs.description == rhs.description
//    }
//    
//    case asc(FQUniversalKeyPathSimple)
//    case desc(FQUniversalKeyPathSimple)
//    
//    public var description: String {
//        switch self {
//        case .asc(let v): return "\(v.queryValue) ASC"
//        case .desc(let v): return "\(v.queryValue) DESC"
//        }
//    }
//    
//    public var query: String {
//        return description
//    }
//}
