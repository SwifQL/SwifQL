//
//  FQP.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

struct FQP {
    static var key = "§§§"
    static func fKey(_ i: Int) -> String { return "$\(i)" }
}

//public struct FQP: SwifQLable {
//    
//    static var key = "§§§"
//    static func fKey(_ i: Int) -> String { return "$\(i)" }
//    
//    public var values: [SwifQLable]
//    public var queryString: String
//    public var plainQuery: String
//    public init (_ query: String, plainQuery: String? = nil, values: [SwifQLable]? = nil) {
//        self.values = values ?? []
//        queryString = query
//        self.plainQuery = plainQuery ?? query
//    }
//    
//    init (query: String, plain: String, _ queryPart: SwifQLable...) {
//        self.init(query: query, plain: plain, queryPart)
//    }
//    
//    init (query: String, plain: String, _ queryPart: [SwifQLable]) {
//        values = queryPart.map { $0.values }.concat()
//        queryString = query
//        plainQuery = plain
//    }
//    
//    init (_ operator: Operator) {
//        values = []
//        queryString = `operator`.rawValue + space
//        plainQuery = queryString
//    }
//    
//    init (_ operator: Operator, _ queryPart: SwifQLable...) {
//        self.init(`operator`, queryPart)
//    }
//    
//    init (_ operator: Operator, _ queryParts: [SwifQLable]) {
//        self.init(`operator`, queryBody:
//                    queryParts.map { $0.queryString },
//                    plainBody: queryParts.map { $0.plainQuery },
//                    values: queryParts.map { $0.values }.concat())
//    }
//    
////    convenience init (_ operator: Operator, queryBody: String..., plainBody: String..., values: [SwifQLable]) {
////        self.init(`operator`, queryBody: queryBody, plainBody: plainBody, values: values)
////    }
//    
//    init (_ operator: Operator, queryBody: [String], plainBody: [String], values: [SwifQLable]) {
//        self.values = values
//        queryString = buildFn(`operator`, queryBody)
//        plainQuery = buildFn(`operator`, plainBody)
//    }
//}
