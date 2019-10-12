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
    
    public static var uuid: Self = .init("uuid")
    public static var uuidArray: Self = .init("uuid[]")
    public static var char: Self = .init("char")
    public static var charArray: Self = .init("char[]")
    public static var varchar: Self = .init("varchar")
    public static var varcharArray: Self = .init("varchar[]")
    public static var text: Self = .init("text")
    public static var textArray: Self = .init("text[]")
    public static var integer: Self = .init("integer")
    public static var integerArray: Self = .init("integer[]")
    public static var numeric: Self = .init("numeric")
    public static var numericArray: Self = .init("numeric[]")
    public static func numeric(_ p: Int, _ s: Int) -> Self { return .init("numeric(\(p), \(s))") }
    public static var bigint: Self = .init("bigint")
    public static var bigintArray: Self = .init("bigint[]")
    public static func float(_ v: Int) -> Self { return .init("float(\(v))") }
    public static var real: Self = .init("real")
    public static var realArray: Self = .init("real[]")
    public static var float8: Self = .init("float8")
    public static var float8Array: Self = .init("float8[]")
    public static var bool: Self = .init("bool")
    public static var boolArray: Self = .init("bool[]")
    public static var json: Self = .init("json")
    public static var jsonArray: Self = .init("json[]")
    public static var jsonb: Self = .init("jsonb")
    public static var jsonbArray: Self = .init("jsonb[]")
    public static var date: Self = .init("date")
    public static var time: Self = .init("time")
    public static var timestamp: Self = .init("timestamp")
    public static var interval: Self = .init("interval")
    public static var doublePrecision: Self = .init("double precision")
    public static var regconfig: Self = .init("regconfig")
    
    public static func custom(_ name: String) -> Self { return .init(name) }
}
