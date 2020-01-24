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
    public static var group: Result { return "GROUP".operator }
    public static var order: Result { return "ORDER".operator }
    public static var by: Result { return "BY".operator }
    public static var insert: Result { return "INSERT".operator }
    public static var into: Result { return "INTO".operator }
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
    public static var nulls: Result { return "NULLS".operator }
    public static var first: Result { return "FIRST".operator }
    public static var last: Result { return "LAST".operator }
    public static var create: Result { return "CREATE".operator }
    public static var type: Result { return "TYPE".operator }
    public static var function: Result { return "FUNCTION".operator }
    public static var table: Result { return "TABLE".operator }
    public static var `enum`: Result { return "ENUM".operator }
    public static var range: Result { return "RANGE".operator }
    public static var subtype: Result { return "SUBTYPE".operator }
    public static var subtypeOpClass: Result { return "SUBTYPE_OPCLASS".operator }
    public static var collate: Result { return "COLLATE".operator }
    public static var collation: Result { return "COLLATION".operator }
    public static var collatable: Result { return "COLLATABLE".operator }
    public static var canonical: Result { return "CANONICAL".operator }
    public static var subtypeDiff: Result { return "SUBTYPE_DIFF".operator }
    public static var input: Result { return "INPUT".operator }
    public static var output: Result { return "OUTPUT".operator }
    public static var receive: Result { return "RECEIVE".operator }
    public static var send: Result { return "SEND".operator }
    public static var typmodIn: Result { return "TYPMOD_IN".operator }
    public static var typmodOut: Result { return "TYPMOD_OUT".operator }
    public static var analyze: Result { return "ANALYZE".operator }
    public static var internalLength: Result { return "INTERNALLENGTH".operator }
    public static var variable: Result { return "VARIABLE".operator }
    public static var passedByValue: Result { return "PASSEDBYVALUE".operator }
    public static var alignment: Result { return "ALIGNMENT".operator }
    public static var storage: Result { return "STORAGE".operator }
    public static var category: Result { return "CATEGORY".operator }
    public static var preferred: Result { return "PREFERRED".operator }
    public static var `default`: Result { return "DEFAULT".operator }
    public static var element: Result { return "ELEMENT".operator }
    public static var delimiter: Result { return "DELIMITER".operator }
    public static var returns: Result { return "RETURNS".operator }
    public static var setOf: Result { return "SETOF".operator }
    public static var begin: Result { return "BEGIN".operator }
    public static var commit: Result { return "COMMIT".operator }
    public static var rollback: Result { return "ROLLBACK".operator }
    public static var `return`: Result { return "RETURN".operator }
    public static var raise: Result { return "RAISE".operator }
    public static var exception: Result { return "EXCEPTION".operator }
    public static var replace: Result { return "REPLACE".operator }
    public static var semicolon: Result { return ";".operator }
    public static var openBracket: Result { return "(".operator }
    public static var closeBracket: Result { return ")".operator }
    public static var openSquareBracket: Result { return "[".operator }
    public static var closeSquareBracket: Result { return "]".operator }
    public static var comma: Result { return ",".operator }
    public static var space: Result { return `_` }
    public static var `_`: Result { return " ".operator }
    public static var owner: Result { return "OWNER".operator }
    public static var to: Result { return "TO".operator }
    public static var currentUser: Result { return "CURRENT_USER".operator }
    public static var sessionUser: Result { return "SESSION_USER".operator }
    public static var rename: Result { return "RENAME".operator }
    public static var attribute: Result { return "ATTRIBUTE".operator }
    public static var cascade: Result { return "CASCADE".operator }
    public static var restrict: Result { return "RESTRICT".operator }
    public static var schema: Result { return "SCHEMA".operator }
    public static var value: Result { return "VALUE".operator }
    public static var before: Result { return "BEFORE".operator }
    public static var after: Result { return "AFTER".operator }
    public static var drop: Result { return "DROP".operator }
    public static var update: Result { return "UPDATE".operator }
    public static var alter: Result { return "ALTER".operator }
    public static var set: Result { return "SET".operator }
    public static var data: Result { return "DATA".operator }
    public static func custom(_ v: String) -> Result { return v.operator }
    
    public var select: Result { return concatWith(.select) }
    public var distinct: Result { return concatWith(.distinct) }
    public var `as`: Result { return concatWith(.as) }
    public var delete: Result { return concatWith(.delete) }
    public var from: Result { return concatWith(.from) }
    public var join: Result { return concatWith(.join) }
    public var `where`: Result { return concatWith(.where) }
    public var having: Result { return concatWith(.having) }
    public var group: Result { return concatWith(.group) }
    public var order: Result { return concatWith(.order) }
    public var by: Result { return concatWith(.by) }
    public var insert: Result { return concatWith(.insert) }
    public var into: Result { return concatWith(.into) }
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
    public var nulls: Result { return concatWith(.nulls) }
    public var first: Result { return concatWith(.first) }
    public var last: Result { return concatWith(.last) }
    public var create: Result { return concatWith(.create) }
    public var type: Result { return concatWith(.type) }
    public var function: Result { return concatWith(.function) }
    public var table: Result { return concatWith(.table) }
    public var `enum`: Result { return concatWith(.enum) }
    public var range: Result { return concatWith(.range) }
    public var subtype: Result { return concatWith(.subtype) }
    public var subtypeOpClass: Result { return concatWith(.subtypeOpClass) }
    public var collate: Result { return concatWith(.collate) }
    public var collation: Result { return concatWith(.collation) }
    public var collatable: Result { return concatWith(.collatable) }
    public var canonical: Result { return concatWith(.canonical) }
    public var subtypeDiff: Result { return concatWith(.subtypeDiff) }
    public var input: Result { return concatWith(.input) }
    public var output: Result { return concatWith(.output) }
    public var receive: Result { return concatWith(.receive) }
    public var send: Result { return concatWith(.send) }
    public var typmodIn: Result { return concatWith(.typmodIn) }
    public var typmodOut: Result { return concatWith(.typmodOut) }
    public var analyze: Result { return concatWith(.analyze) }
    public var internalLength: Result { return concatWith(.internalLength) }
    public var variable: Result { return concatWith(.variable) }
    public var passedByValue: Result { return concatWith(.passedByValue) }
    public var alignment: Result { return concatWith(.alignment) }
    public var storage: Result { return concatWith(.storage) }
    public var category: Result { return concatWith(.category) }
    public var preferred: Result { return concatWith(.preferred) }
    public var `default`: Result { return concatWith(.default) }
    public var element: Result { return concatWith(.element) }
    public var delimiter: Result { return concatWith(.delimiter) }
    public var returns: Result { return concatWith(.returns) }
    public var setOf: Result { return concatWith(.setOf) }
    public var begin: Result { return concatWith(.begin) }
    public var commit: Result { return concatWith(.commit) }
    public var rollback: Result { return concatWith(.rollback) }
    public var `return`: Result { return concatWith(.return) }
    public var raise: Result { return concatWith(.raise) }
    public var exception: Result { return concatWith(.exception) }
    public var replace: Result { return concatWith(.replace) }
    public var semicolon: Result { return concatWith(.semicolon) }
    public var openBracket: Result { return concatWith(.openBracket) }
    public var closeBracket: Result { return concatWith(.closeBracket) }
    public var openSquareBracket: Result { return concatWith(.openSquareBracket) }
    public var closeSquareBracket: Result { return concatWith(.closeSquareBracket) }
    public var comma: Result { return concatWith(.comma) }
    public var space: Result { return concatWith(.space) }
    public var `_`: Result { return concatWith(._) }
    public var owner: Result { return concatWith(.owner) }
    public var to: Result { return concatWith(.to) }
    public var currentUser: Result { return concatWith(.currentUser) }
    public var sessionUser: Result { return concatWith(.sessionUser) }
    public var rename: Result { return concatWith(.rename) }
    public var attribute: Result { return concatWith(.attribute) }
    public var cascade: Result { return concatWith(.cascade) }
    public var restrict: Result { return concatWith(.restrict) }
    public var schema: Result { return concatWith(.schema) }
    public var value: Result { return concatWith(.value) }
    public var before: Result { return concatWith(.before) }
    public var after: Result { return concatWith(.after) }
    public var drop: Result { return concatWith(.drop) }
    public var update: Result { return concatWith(.update) }
    public var alter: Result { return concatWith(.alter) }
    public var set: Result { return concatWith(.set) }
    public var data: Result { return concatWith(.data) }
    public func custom(_ v: String) -> Result { return concatWith(.custom(v)) }
    
    private func concatWith(_ operator: Result) -> Result {
        return (_value + `operator`._value).operator
    }
}

extension String {
    fileprivate var `operator`: SwifQLPartOperator {
        return SwifQLPartOperator(self)
    }
}
