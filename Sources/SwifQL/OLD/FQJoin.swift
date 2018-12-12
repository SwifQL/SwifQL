//import Foundation
//import Fluent
//
//public protocol FQJoinGenericType: FQPart {
//    var query: String { get }
//}
//
//public enum FQJoinMode: String {
//    case left = "LEFT"
//    case right = "RIGHT"
//    case inner = "INNER"
//    case outer = "OUTER"
//}
//
//public class FQJoin<T>: FQPart, FQJoinGenericType where T: Model {
//    public var query: String
//    
//    public init(_ mode: FQJoinMode, table: T.Type, where: FQWhere) {
//        query = FQJoin.build(mode, T.FQType.query, `where`)
//    }
//    
//    public convenience init(_ mode: FQJoinMode, table: T.Type, where: FQPredicateGenericType) {
//        self.init(mode, table: table, where: FQWhere(`where`))
//    }
//    
//    public init(_ mode: FQJoinMode, table: FQAlias<T>, where: FQWhere) {
//        query = FQJoin.build(mode, table.query, `where`)
//    }
//    
//    public convenience init(_ mode: FQJoinMode, table: FQAlias<T>, where: FQPredicateGenericType) {
//        self.init(mode, table: table, where: FQWhere(`where`))
//    }
//    
//    public init(_ mode: FQJoinMode, subquery: FluentQuery, alias: FQAlias<T>, where: FQWhere) {
//        query = FQJoin.build(mode, subquery.query.roundBracketted.as(alias.alias.doubleQuotted), `where`)
//    }
//    
//    public convenience init(_ mode: FQJoinMode, subquery: FluentQuery, alias: FQAlias<T>, where: FQPredicateGenericType) {
//        self.init(mode, subquery: subquery, alias: alias, where: FQWhere(`where`))
//    }
//    
//    static func build(_ mode: FQJoinMode,_ value: String, _ where: FQWhere) -> String {
//        var result = mode.rawValue
//        result.append(" ")
//        result.append("JOIN")
//        result.append(" ")
//        result.append("\(value)")
//        result.append(" ")
//        result.append("ON")
//        result.append(" ")
//        result.append(`where`.query)
//        return result
//    }
//}
