//import Foundation
//import Fluent
//
//public class FQGroupBy: FQPart {
//    var parts: [FQPart] = []
//    
//    public init(_ keyPaths: FQUniversalKeyPathSimple...) {
//        parts = keyPaths.map { $0.queryValue }
//    }
//    
//    public init(_ keyPaths: [FQUniversalKeyPathSimple]) {
//        parts = keyPaths.map { $0.queryValue }
//    }
//    
//    public init(copy from: FQGroupBy? = nil) {
//        if let from = from {
//            parts = from.parts.map { $0 }
//        }
//    }
//    
//    public init<T>(_ kp: T) where T: FQUniversalKeyPath {
//        add(kp)
//    }
//    
//    @discardableResult
//    public func add<T>(_ kp: T) -> Self where T: FQUniversalKeyPath {
//        parts.append(kp.queryValue)
//        return self
//    }
//    
//    @discardableResult
//    public func and<T>(_ kp: T) -> Self where T: FQUniversalKeyPath {
//        return add(kp)
//    }
//    
//    public var query: String {
//        return parts.map { $0.query }.joined(separator: ", ")
//    }
//    
//    public func joinAnotherInstance(_ inst: FQGroupBy) {
//        if inst.parts.count > 0 {
//            parts.append(contentsOf: inst.parts)
//        }
//    }
//}
