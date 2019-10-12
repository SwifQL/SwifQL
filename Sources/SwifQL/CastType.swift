//
//  CastType.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12/10/2019.
//

public struct CastType {
    let name: String
    
    public init (_ name: String) {
        self.name = name
    }
    
    public static var uuid: CastType = .init("uuid")
    public static var uuidArray: CastType = .init("uuid[]")
    public static var char: CastType = .init("char")
    public static var charArray: CastType = .init("char[]")
    public static var varchar: CastType = .init("varchar")
    public static var varcharArray: CastType = .init("varchar[]")
    public static var text: CastType = .init("text")
    public static var textArray: CastType = .init("text[]")
    public static var integer: CastType = .init("integer")
    public static var integerArray: CastType = .init("integer[]")
    public static var numeric: CastType = .init("numeric")
    public static var numericArray: CastType = .init("numeric[]")
    public static func numeric(_ p: Int, _ s: Int) -> CastType { return .init("numeric(\(p), \(s))") }
    public static var bigint: CastType = .init("bigint")
    public static var bigintArray: CastType = .init("bigint[]")
    public static func float(_ v: Int) -> CastType { return .init("float(\(v))") }
    public static var real: CastType = .init("real")
    public static var realArray: CastType = .init("real[]")
    public static var float8: CastType = .init("float8")
    public static var float8Array: CastType = .init("float8[]")
    public static var bool: CastType = .init("bool")
    public static var boolArray: CastType = .init("bool[]")
    public static var json: CastType = .init("json")
    public static var jsonArray: CastType = .init("json[]")
    public static var jsonb: CastType = .init("jsonb")
    public static var jsonbArray: CastType = .init("jsonb[]")
    public static var date: CastType = .init("date")
    public static var time: CastType = .init("time")
    public static var timestamp: CastType = .init("timestamp")
    public static var interval: CastType = .init("interval")
    public static var doublePrecision: CastType = .init("double precision")
    public static var regconfig: CastType = .init("regconfig")
    
    public static func custom(_ name: String) -> CastType { return .init(name) }
}
