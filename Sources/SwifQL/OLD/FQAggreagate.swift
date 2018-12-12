//import Foundation
//import Fluent
//
//protocol FQAggregateFuncOption : CustomStringConvertible, Equatable {
//    var value: Any { get }
//}
//
//public protocol FQAggregateFuncOptionKP {
//    associatedtype Root: FQUniversalKeyPath
//}
//
//public class FQAggregate {
//    static let valueKey = "%"
//    
//    //MARK: Original functions
//    public enum Functions: FQAggregateFuncOption {
//        // Aggregate
//        case count(String) //kp
//        case sum(String) //kp
//        case average(String) //kp
//        case min(String) //kp
//        case max(String) //kp
//        // Date/Time
//        case extract(ExtractField, ExtractType, String) //kp
//        
//        public var description: String {
//            let description: String
//            switch self {
//            case .count:
//                description = "COUNT\(FQAggregate.valueKey.roundBracketted)"
//            case .sum:
//                description = "SUM\(FQAggregate.valueKey.roundBracketted)"
//            case .average:
//                description = "AVG\(FQAggregate.valueKey.roundBracketted)"
//            case .min:
//                description = "MIN\(FQAggregate.valueKey.roundBracketted)"
//            case .max:
//                description = "MAX\(FQAggregate.valueKey.roundBracketted)"
//            case .extract:
//                description = "EXTRACT\(FQAggregate.valueKey.roundBracketted)"
//            }
//            return description
//        }
//        
//        var `func`: String {
//            return description.replacingOccurrences(of: FQAggregate.valueKey, with: "\(value)")
//        }
//        
//        var value: Any {
//            let value: Any
//            switch self {
//            case let .count(v):
//                value = v
//            case let .sum(v):
//                value = v
//            case let .average(v):
//                value = v
//            case let .min(v):
//                value = v
//            case let .max(v):
//                value = v
//            case let .extract(f, t, v):
//                value = f.rawValue+" FROM "+t.rawValue+" "+v
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
//    public enum FunctionWithKeyPath<UKP>: FQAggregateFuncOption, FQAggregateFuncOptionKP where UKP: FQUniversalKeyPath {
//        public typealias Root = UKP
//        
//        case count(UKP)
//        case sum(UKP)
//        case average(UKP)
//        case min(UKP)
//        case max(UKP)
//        case extract(ExtractField, ExtractType, UKP)
//        
//        var mirror: Functions {
//            switch self {
//            case let .count(kp): return .count(kp.queryValue)
//            case let .sum(kp): return .sum(kp.queryValue)
//            case let .average(kp): return .average(kp.queryValue)
//            case let .min(kp): return .min(kp.queryValue)
//            case let .max(kp): return .max(kp.queryValue)
//            case let .extract(f, t, kp): return .extract(f, t, kp.queryValue)
//            }
//        }
//        
//        public var description: String {
//            return mirror.description
//        }
//        
//        var kp: UKP {
//            switch self {
//            case let .count(kp): return kp
//            case let .sum(kp): return kp
//            case let .average(kp): return kp
//            case let .min(kp): return kp
//            case let .max(kp): return kp
//            case let .extract(_, _, kp): return kp
//            }
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
//        public static func ==(lhs: FunctionWithKeyPath, rhs: FunctionWithKeyPath) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//    
//    //MARK: Mirror for Model only based functions
//    public enum FunctionWithModel: FQAggregateFuncOption {
//        case count(FluentQuery)
//        case sum(FluentQuery)
//        case average(FluentQuery)
//        case min(FluentQuery)
//        case max(FluentQuery)
//        case extract(ExtractField, ExtractType, FluentQuery)
//        
//        var mirror: Functions {
//            switch self {
//            case .count: return .count(String.roundBracketted(value))
//            case .sum: return .sum(String.roundBracketted(value))
//            case .average: return .average(String.roundBracketted(value))
//            case .min: return .min(String.roundBracketted(value))
//            case .max: return .max(String.roundBracketted(value))
//            case let .extract(f, t, _): return .extract(f, t, String.roundBracketted(value))
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
//            let value: Any
//            switch self {
//            case let .count(v):
//                value = v.query
//            case let .sum(v):
//                value = v.query
//            case let .average(v):
//                value = v.query
//            case let .min(v):
//                value = v.query
//            case let .max(v):
//                value = v.query
//            case let .extract(_, _, v):
//                value = v.query
//            }
//            return value
//        }
//        
//        public static func ==(lhs: FunctionWithModel, rhs: FunctionWithModel) -> Bool {
//            return lhs.func == rhs.func
//        }
//    }
//}
//
