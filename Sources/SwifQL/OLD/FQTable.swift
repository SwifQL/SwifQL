//import Foundation
//import Fluent
//
//public class FQTable<T>: FQPart where T: Model {
//    static var name: String {
//        return T.entity
//    }
//    static var alias: String {
//        return "_\(name.lowercased())_"
//    }
//    public static var query: String {
//        return "\(FQTable.name.doubleQuotted) as \(FQTable.alias.doubleQuotted)"
//    }
//    
//    //MARK: SQLQueryPart
//    
//    public var query: String {
//        return FQTable.query
//    }
//}
