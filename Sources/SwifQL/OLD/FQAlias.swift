//import Foundation
////import Fluent
////import Crypto
////
////extension Model {
////    /// Helper method for generating random string
////    private static func shuffledAlphabet(_ length: Int) -> String {
////        let letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
////        var randomString = ""
////        for _ in 0...length - 1 {
////            if let random = try? CryptoRandom().generate(UInt32.self) {
////                let rand = random % UInt32(letters.count)
////                let ind = Int(rand)
////                let character = letters[letters.index(letters.startIndex, offsetBy: ind)]
////                randomString.append(character)
////            }
////        }
////        return randomString
////    }
////
////    /// It will return alias named: Model.name + randomString
////    /// it will return new alias every time you call it
////    public static var randomAlias: FQAlias<Self> {
////        return alias(shuffledAlphabet(3))
////    }
////
////    /// It will return alias named: Model.name + number
////    public static func alias(_ number: Int) -> FQAlias<Self> {
////        return alias("\(number)")
////    }
////
////    /// It will return alias named: Model.name + "Alias"
////    public static var alias: FQAlias<Self> {
////        return alias()
////    }
////
////    /// By default it will return alias named: Model.name + "Alias"
////    /// as .alias lazy property
////    /// or you can provide your own string
////    /// and it will return alias named: Model.name + yourString
////    /// If you want to set your own short alias please use `alias(short:)` method
////    public static func alias(_ additionalString: String? = nil) -> FQAlias<Self> {
////        return FQAlias<Self>(entity + (additionalString ?? "Alias"))
////    }
////
////    /// It will return alias named: your own string
////    public static func alias(short: String) -> FQAlias<Self> {
////        return FQAlias<Self>(short)
////    }
////}
//
//class FluentQuery {}
//
//#if canImport(Fluent)
//import Fluent
//
//////
//public class FQTable<T>: SwifQLable where T: Model {
//    public var queryString: String {
//        return "\(FQTable.name.doubleQuotted) as \(FQTable.alias.doubleQuotted)"
//    }
//    
//    public var plainQuery: String {
//        return queryString
//    }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    static var name: String {
//        return T.entity
//    }
//    static var alias: String {
//        return "_\(name.lowercased())_"
//    }
//}
//////
//
///////
//extension FluentQuery {
//    static func formattedPath<T, V>(_ table: T.Type, _ kp: KeyPath<T, V>) -> String where T: Model {
//        return FluentQuery.formattedPath(table.FQType.alias, kp)
//    }
//
//    static func formattedPath<T, V>(_ table: String, _ kp: KeyPath<T, V>) -> String where T: Model {
//        var formattedPath = ""
//        let values: [String] = T.describeKeyPath(kp)
//        for (index, p) in values.enumerated() {
//            if index == 0 {
//                formattedPath.append("\(p.doubleQuotted)")
//            } else {
//                formattedPath.append("->")
//                formattedPath.append("\(p.singleQuotted)")
//            }
//        }
//        return "\(table.doubleQuotted).\(formattedPath)"
//    }
//}
//
//extension Model {
//    typealias FQType = FQTable<Self>
//
//    static func describeKeyPath<V>(_ kp: KeyPath<Self, V>) -> [String] {
//        if let pathParts = try? Self.reflectProperty(forKey: kp)?.path {
//            return pathParts ?? []
//        }
//        return []
//    }
//
//    static func property<T, V>(_ kp: KeyPath<T, V>) -> String where T: Model {
//        return FluentQuery.formattedPath(T.self, kp)
//    }
//}
//
//public func FQGetKeyPath<T, V>(_ kp: KeyPath<T, V>) -> String where T: Model {
//    return FluentQuery.formattedPath(T.self, kp)
//}
//
//public func FQGetKeyPath<T, V>(_ alias: AliasedKeyPath<T, V>) -> String where T: Model {
//    return alias.queryString
//}
///////
//
//public class AliasedKeyPath<M, V>: SwifQLable where M: Model {
//    public var queryString: String { return FluentQuery.formattedPath(alias, kp) }
//    
//    public var plainQuery: String { return queryString }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    var alias: String
//    var kp: KeyPath<M, V>
//    init(_ alias: String, _ kp: KeyPath<M, V>) {
//        self.alias = alias
//        self.kp = kp
//    }
//}
//
//public class FQAlias<M>: SwifQLable where M: Model {
//    public var queryString: String { return name.doubleQuotted.as(alias.doubleQuotted) }
//    
//    public var plainQuery: String { return queryString }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    var name: String {
//        return M.entity
//    }
//    var alias: String
//
//    public init(_ alias: String) {
//        self.alias = alias
//    }
//
//    //MARK: SQLQueryPart
//
//    public func k<V>(_ kp: KeyPath<M, V>) -> AliasedKeyPath<M, V> {
//        return AliasedKeyPath(alias, kp)
//    }
//}
//
//
//
//
//
//
//#else
//
/////
//public class FQTable<T>: SwifQLable where T: Codable {
//    public var queryString: String {
//        return "\(FQTable.name.doubleQuotted) as \(FQTable.alias.doubleQuotted)"
//    }
//    
//    public var plainQuery: String {
//        return queryString
//    }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    static var name: String {
//        return T.entity
//    }
//    static var alias: String {
//        return "_\(name.lowercased())_"
//    }
//}
/////
//
///////
//extension FluentQuery {
//    static func formattedPath<T, V>(_ table: T.Type, _ kp: KeyPath<T, V>) -> String where T: Codable {
//        return FluentQuery.formattedPath(table.FQType.alias, kp)
//    }
//    
//    static func formattedPath<T, V>(_ table: String, _ kp: KeyPath<T, V>) -> String where T: Codable {
//        var formattedPath = ""
//        let values: [String] = T.describeKeyPath(kp)
//        for (index, p) in values.enumerated() {
//            if index == 0 {
//                formattedPath.append("\(p.doubleQuotted)")
//            } else {
//                formattedPath.append("->")
//                formattedPath.append("\(p.singleQuotted)")
//            }
//        }
//        return "\(table.doubleQuotted).\(formattedPath)"
//    }
//}
//
//extension Decodable {
//    typealias FQType = FQTable<Self>
//    
//    static func describeKeyPath<V>(_ kp: KeyPath<Self, V>) -> [String] {
//        if let pathParts = try? Self.reflectProperty(forKey: kp)?.path {
//            return pathParts ?? []
//        }
//        return []
//    }
//    
//    static func property<T, V>(_ kp: KeyPath<T, V>) -> String where T: Codable {
//        return FluentQuery.formattedPath(T.self, kp)
//    }
//}
//
//public func FQGetKeyPath<T, V>(_ kp: KeyPath<T, V>) -> String where T: Codable {
//    return FluentQuery.formattedPath(T.self, kp)
//}
//
//public func FQGetKeyPath<T, V>(_ alias: AliasedKeyPath<T, V>) -> String where T: Codable {
//    return alias.queryString
//}
///////
//
//public class AliasedKeyPath<M, V>: SwifQLable where M: Codable {
//    public var queryString: String { return FluentQuery.formattedPath(alias, kp) }
//    
//    public var plainQuery: String { return queryString }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    var alias: String
//    var kp: KeyPath<M, V>
//    init(_ alias: String, _ kp: KeyPath<M, V>) {
//        self.alias = alias
//        self.kp = kp
//    }
//}
//
//public class FQAlias<M>: SwifQLable where M: Codable {
//    public var queryString: String { return name.doubleQuotted.as(alias.doubleQuotted) }
//    
//    public var plainQuery: String { return queryString }
//    
//    public var values: [SwifQLable] { return [] }
//    
//    var name: String {
//        return M.entity
//    }
//    var alias: String
//    
//    public init(_ alias: String) {
//        self.alias = alias
//    }
//    
//    //MARK: SQLQueryPart
//    
//    public func k<V>(_ kp: KeyPath<M, V>) -> AliasedKeyPath<M, V> {
//        return AliasedKeyPath(alias, kp)
//    }
//}
//
//extension KeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple  where Root: Codable {
//    public typealias AType = Value
//    public typealias AModel = Root
//    public typealias ARoot = KeyPath
//    
//    public var queryValue: String {
//        return FQGetKeyPath(self)
//    }
//    
//    public var originalKeyPath: KeyPath<Root, Value> {
//        return self
//    }
//}
//
//#endif
//

//
//
//public protocol FQUniversalModel {
//    var queryValue: String { get }
//}
//
//extension AliasedKeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple {
//    public typealias AType = V
//    public typealias AModel = M
//    public typealias ARoot = AliasedKeyPath
//    
//    public var queryValue: String {
//        return FQGetKeyPath(self)
//    }
//    
//    public var originalKeyPath: KeyPath<M, V> {
//        return kp
//    }
//}
