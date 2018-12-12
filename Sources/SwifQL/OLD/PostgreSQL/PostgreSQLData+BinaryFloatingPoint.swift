//import Foundation
//
//extension BinaryFloatingPoint where Self: LosslessStringConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Self {
//        switch data.storage {
//        case .binary(let value):
//            let f: Self?
//            switch data.type {
//            case .char: f = Self(value.as(Int8.self, default: 0).bigEndian)
//            case .int2: f = Self(value.as(Int16.self, default: 0).bigEndian)
//            case .int4: f = Self(value.as(Int32.self, default: 0).bigEndian)
//            case .int8: f = Self(value.as(Int64.self, default: 0).bigEndian)
//            case .float4: f = Self(Data(value.reversed()).as(Float.self, default: 0))
//            case .float8: f = Self(Data(value.reversed()).as(Double.self, default: 0))
//            case .numeric:
//                let string = try String.convertFromPostgreSQLData(data)
//                f = Self(string)
//            default: throw PostgreSQLError.decode(self, from: data)
//            }
//            guard let value = f else {
//                throw PostgreSQLError.decode(self, from: data)
//            }
//            return value
//        case .text(let string):
//            guard let converted = Self(string) else {
//                throw PostgreSQLError.decode(self, from: data)
//            }
//            return converted
//        case .null: throw PostgreSQLError.decode(self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        let type: PostgreSQLDataFormat
//        switch Self.bitWidth {
//        case 32: type = .float4
//        case 64: type = .float8
//        default: fatalError("Floating point bit width not supported: \(Self.bitWidth)")
//        }
//        return PostgreSQLData(type, binary: .init(Data.of(self).reversed()))
//    }
//}
//
//extension Double: PostgreSQLDataConvertible { }
//extension Float: PostgreSQLDataConvertible { }
