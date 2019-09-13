//
//  Operator.swift
//  SwifQL
//
//  Created by Mihael Isaev on 02/08/2019.
//

import Foundation

public typealias Op = Operator
public typealias Operator = SwifQLPartOperator

extension SwifQLPartOperator {
    public typealias Result = SwifQLPartOperator
    
    public static var select: Result { return "SELECT".operator }
    public static var distinct: Result { return "DISTINCT".operator }
    public static var `as`: Result { return "as".operator }
    public static var delete: Result { return "DELETE".operator }
    public static var from: Result { return "FROM".operator }
    public static var join: Result { return "JOIN".operator }
    public static var `where`: Result { return "WHERE".operator }
    public static var having: Result { return "HAVING".operator }
    public static var groupBy: Result { return "GROUP BY".operator }
    public static var orderBy: Result { return "ORDER BY".operator }
    public static var insertInto: Result { return "INSERT INTO".operator }
    public static var values: Result { return "VALUES".operator }
    public static var union: Result { return "UNION".operator }
    public static var returning: Result { return "RETURNING".operator }
    public static var exists: Result { return "EXISTS".operator }
    public static var and: Result { return "AND".operator }
    public static var or: Result { return "OR".operator }
    public static var greaterThan: Result { return ">".operator }
    public static var lessThan: Result { return "<".operator }
    public static var greaterThanOrEqual: Result { return ">=".operator }
    public static var lessThanOrEqual: Result { return "<=".operator }
    public static var equal: Result { return "=".operator }
    public static var notEqual: Result { return "!=".operator }
    public static var `in`: Result { return "IN".operator }
    public static var notIn: Result { return "NOT IN".operator }
    public static var like: Result { return "LIKE".operator }
    public static var notLike: Result { return "NOT LIKE".operator }
    public static var ilike: Result { return "ILIKE".operator }
    public static var notILike: Result { return "NOT ILIKE".operator }
    public static var fulltext: Result { return "@@".operator }
    public static var isNull: Result { return "IS NULL".operator }
    public static var isNotNull: Result { return "IS NOT NULL".operator }
    public static var contains: Result { return "@>".operator }
    public static var containedBy: Result { return "<@".operator }
    public static var on: Result { return "ON".operator }
    public static var `case`: Result { return "CASE".operator }
    public static var when: Result { return "WHEN".operator }
    public static var then: Result { return "THEN".operator }
    public static var `else`: Result { return "ELSE".operator }
    public static var end: Result { return "END".operator }
    public static var null: Result { return "NULL".operator }
    public static var `do`: Result { return "DO".operator }
    public static var conflict: Result { return "CONFLICT".operator }
    public static var constraint: Result { return "CONSTRAINT".operator }
    public static var nothing: Result { return "NOTHING".operator }
    public static var asc: Result { return "ASC".operator }
    public static var desc: Result { return "DESC".operator }
    public static var limit: Result { return "LIMIT".operator }
    public static var offset: Result { return "OFFSET".operator }
    public static var `for`: Result { return "FOR".operator }
    public static var filter: Result { return "FILTER".operator }
    public static var array: Result { return "ARRAY".operator }
    public static var doubleDollar: Result { return "$$".operator }
    public static var between: Result { return "BETWEEN".operator }
    public static var notBetween: Result { return "NOT BETWEEN".operator }
    public static var not: Result { return "NOT".operator }
    public static var timestamp: Result { return "TIMESTAMP".operator }
    public static var with: Result { return "WITH".operator }
    public static var timeZone: Result { return "TIME ZONE".operator }
    public static var epoch: Result { return "EPOCH".operator }
    public static var interval: Result { return "INTERVAL".operator }
    public static var date: Result { return "DATE".operator }
    public static var millenium: Result { return "MILLENNIUM".operator }
    public static var microseconds: Result { return "MICROSECONDS".operator }
    public static var milliseconds: Result { return "MILLISECONDS".operator }
    public static var isoYear: Result { return "ISOYEAR".operator }
    public static var isoDoW: Result { return "ISODOW".operator }
    public static var hour: Result { return "HOUR".operator }
    public static var time: Result { return "TIME".operator }
    public static var minute: Result { return "MINUTE".operator }
    public static var month: Result { return "MONTH".operator }
    public static var quarter: Result { return "QUARTER".operator }
    public static var second: Result { return "SECOND".operator }
    public static var week: Result { return "WEEK".operator }
    public static var year: Result { return "YEAR".operator }
    public static var decade: Result { return "DECADE".operator }
    public static var century: Result { return "CENTURY".operator }
    public static var overlaps: Result { return "OVERLAPS".operator }
    public static var doublePrecision: Result { return "DOUBLE PRECISION".operator }
    public static var openBracket: Result { return "(".operator }
    public static var closeBracket: Result { return ")".operator }
    public static var openSquareBracket: Result { return "[".operator }
    public static var closeSquareBracket: Result { return "]".operator }
    public static var comma: Result { return ",".operator }
    public static var space: Result { return `_` }
    public static var `_`: Result { return " ".operator }
    public static func custom(_ v: String) -> Result { return v.operator }
    
    public var select: Result { return concatWith(.select) }
    public var distinct: Result { return concatWith(.distinct) }
    public var `as`: Result { return concatWith(.as) }
    public var delete: Result { return concatWith(.delete) }
    public var from: Result { return concatWith(.from) }
    public var join: Result { return concatWith(.join) }
    public var `where`: Result { return concatWith(.where) }
    public var having: Result { return concatWith(.having) }
    public var groupBy: Result { return concatWith(.groupBy) }
    public var orderBy: Result { return concatWith(.orderBy) }
    public var insertInto: Result { return concatWith(.insertInto) }
    public var values: Result { return concatWith(.values) }
    public var union: Result { return concatWith(.union) }
    public var returning: Result { return concatWith(.returning) }
    public var exists: Result { return concatWith(.exists) }
    public var and: Result { return concatWith(.and) }
    public var or: Result { return concatWith(.or) }
    public var greaterThan: Result { return concatWith(.greaterThan) }
    public var lessThan: Result { return concatWith(.lessThan) }
    public var greaterThanOrEqual: Result { return concatWith(.greaterThanOrEqual) }
    public var lessThanOrEqual: Result { return concatWith(.lessThanOrEqual) }
    public var equal: Result { return concatWith(.equal) }
    public var notEqual: Result { return concatWith(.notEqual) }
    public var `in`: Result { return concatWith(.in) }
    public var notIn: Result { return concatWith(.notIn) }
    public var like: Result { return concatWith(.like) }
    public var notLike: Result { return concatWith(.notLike) }
    public var ilike: Result { return concatWith(.ilike) }
    public var notILike: Result { return concatWith(.notILike) }
    public var fulltext: Result { return concatWith(.fulltext) }
    public var isNull: Result { return concatWith(.isNull) }
    public var isNotNull: Result { return concatWith(.isNotNull) }
    public var contains: Result { return concatWith(.contains) }
    public var containedBy: Result { return concatWith(.containedBy) }
    public var on: Result { return concatWith(.on) }
    public var `case`: Result { return concatWith(.case) }
    public var when: Result { return concatWith(.when) }
    public var then: Result { return concatWith(.then) }
    public var `else`: Result { return concatWith(.else) }
    public var end: Result { return concatWith(.end) }
    public var null: Result { return concatWith(.null) }
    public var `do`: Result { return concatWith(.do) }
    public var conflict: Result { return concatWith(.conflict) }
    public var constraint: Result { return concatWith(.constraint) }
    public var nothing: Result { return concatWith(.nothing) }
    public var asc: Result { return concatWith(.asc) }
    public var desc: Result { return concatWith(.desc) }
    public var limit: Result { return concatWith(.limit) }
    public var offset: Result { return concatWith(.offset) }
    public var `for`: Result { return concatWith(.for) }
    public var filter: Result { return concatWith(.filter) }
    public var array: Result { return concatWith(.array) }
    public var doubleDollar: Result { return concatWith(.doubleDollar) }
    public var between: Result { return concatWith(.between) }
    public var notBetween: Result { return concatWith(.notBetween) }
    public var not: Result { return concatWith(.not) }
    public var timestamp: Result { return concatWith(.timestamp) }
    public var with: Result { return concatWith(.with) }
    public var timeZone: Result { return concatWith(.timeZone) }
    public var epoch: Result { return concatWith(.epoch) }
    public var interval: Result { return concatWith(.interval) }
    public var date: Result { return concatWith(.date) }
    public var millenium: Result { return concatWith(.millenium) }
    public var microseconds: Result { return concatWith(.microseconds) }
    public var milliseconds: Result { return concatWith(.milliseconds) }
    public var isoYear: Result { return concatWith(.isoYear) }
    public var isoDoW: Result { return concatWith(.isoDoW) }
    public var hour: Result { return concatWith(.hour) }
    public var time: Result { return concatWith(.time) }
    public var minute: Result { return concatWith(.minute) }
    public var month: Result { return concatWith(.month) }
    public var quarter: Result { return concatWith(.quarter) }
    public var second: Result { return concatWith(.second) }
    public var week: Result { return concatWith(.week) }
    public var year: Result { return concatWith(.year) }
    public var decade: Result { return concatWith(.decade) }
    public var century: Result { return concatWith(.century) }
    public var overlaps: Result { return concatWith(.overlaps) }
    public var doublePrecision: Result { return concatWith(.doublePrecision) }
    public var openBracket: Result { return concatWith(.openBracket) }
    public var closeBracket: Result { return concatWith(.closeBracket) }
    public var openSquareBracket: Result { return concatWith(.openSquareBracket) }
    public var closeSquareBracket: Result { return concatWith(.closeSquareBracket) }
    public var comma: Result { return concatWith(.comma) }
    public var space: Result { return concatWith(.space) }
    public var `_`: Result { return concatWith(._) }
    public func custom(_ v: String) -> Result { return concatWith(.custom(v)) }
    
    private func concatWith(_ operator: Result) -> Result {
        return (value + `operator`.value).operator
    }
}

extension String {
    fileprivate var `operator`: SwifQLPartOperator {
        return SwifQLPartOperator(self)
    }
}
