//import Bits
//import Foundation
//import NIO
//import Debugging
//
//extension ByteBuffer {
//    mutating func write(nullTerminated string: String) {
//        write(string: string)
//        write(integer: 0, as: Byte.self)
//    }
//    
//    mutating func readEnum<E>(_ type: E.Type) -> E? where E: RawRepresentable, E.RawValue: FixedWidthInteger {
//        guard let rawValue = readInteger(as: E.RawValue.self) else {
//            return nil
//        }
//        return E.init(rawValue: rawValue)
//    }
//    
//    mutating func readNullableData() -> Data? {
//        guard let count: Int = readInteger(as: Int32.self).flatMap(numericCast) else {
//            return nil
//        }
//        switch count {
//        case -1:
//            // As a special case, -1 indicates a NULL parameter value. No value bytes follow in the NULL case.
//            return nil
//        default: return readData(length: count)
//        }
//    }
//    
//    mutating func write(nullableData: Data?) {
//        if let data = nullableData {
//            // The length of the parameter value, in bytes (this count does not include itself). Can be zero.
//            write(integer: numericCast(data.count), as: Int32.self)
//            // The value of the parameter, in the format indicated by the associated format code. n is the above length.
//            write(bytes: data)
//        } else {
//            // As a special case, -1 indicates a NULL parameter value. No value bytes follow in the NULL case.
//            write(integer: -1, as: Int32.self)
//        }
//    }
//    
//    mutating func readArray<T>(_ type: T.Type, _ closure: (inout ByteBuffer) throws -> (T)) rethrows -> [T]? {
//        guard let count: Int = readInteger(as: Int16.self).flatMap(numericCast) else {
//            return nil
//        }
//        var array: [T] = []
//        array.reserveCapacity(count)
//        for _ in 0..<count {
//            try array.append(closure(&self))
//        }
//        return array
//    }
//    
//    
//    mutating func write<T>(array: [T], closure: (inout ByteBuffer, T) -> ()) {
//        write(integer: numericCast(array.count), as: Int16.self)
//        for el in array {
//            closure(&self, el)
//        }
//    }
//    
//    mutating func write<T>(array: [T]) where T: FixedWidthInteger {
//        write(array: array) { buffer, el in
//            buffer.write(integer: el)
//        }
//    }
//}
//
//enum Regproc: PostgreSQLDataConvertible, Codable {
//    func convertToPostgreSQLData() throws -> PostgreSQLData {
//        switch self {
//        case .function(let string): return try string.convertToPostgreSQLData()
//        case .functionID(let id): return try id.convertToPostgreSQLData()
//        }
//    }
//    static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Regproc {
//        if data.binary != nil {
//            return try .functionID(.convertFromPostgreSQLData(data))
//        } else {
//            return try .function(.convertFromPostgreSQLData(data))
//        }
//    }
//    
//    init(from decoder: Decoder) throws {
//        let single = try decoder.singleValueContainer()
//        self = try .function(single.decode(String.self))
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var single = encoder.singleValueContainer()
//        switch self {
//        case .function(let string): try single.encode(string)
//        case .functionID(let int): try single.encode(int)
//        }
//    }
//    
//    case function(String)
//    case functionID(UInt32)
//}
//
//extension Data {
//    static func of<T>(_ value: T) -> Data {
//        var copy = value
//        return .init(bytes: &copy, count:  MemoryLayout<T>.size)
//    }
//    
//    func `as`<T>(_ type: T.Type, default: T) -> T {
//        return withUnsafeBytes { ptr -> T in
//            var copy = `default`
//            Swift.withUnsafeMutableBytes(of: &copy) { valuePtr -> Void in
//                valuePtr.copyMemory(from: UnsafeRawBufferPointer(start: ptr.baseAddress!, count: MemoryLayout<T>.size))
//            }
//            return copy
//        }
//    }
//}
//
//extension BinaryFloatingPoint {
//    /// Return's this floating point's bit width.
//    static var bitWidth: Int {
//        return exponentBitCount + significandBitCount + 1
//    }
//    
//    /// Bytes for this integer.
//    internal var data: Data {
//        var copy = self
//        return .init(bytes: &copy, count:  MemoryLayout<Self>.size)
//    }
//}
//
//extension FixedWidthInteger {
//    func cast<T>(to value: T.Type) -> T? where T: FixedWidthInteger {
//        if let existing = self as? T {
//            return existing
//        }
//        guard self <= T.max, self >= T.min else {
//            return nil
//        }
//        return T(self)
//    }
//}
//
//extension Data {
//    mutating func skip(_ n: Int) {
//        guard n < count else {
//            self = Data()
//            return
//        }
//        self = advanced(by: n)
//    }
//    
//    mutating func skip<T>(sizeOf: T.Type) {
//        skip(MemoryLayout<T>.size)
//    }
//    
//    /// Casts data to a supplied type.
//    mutating func extract<T>(_ type: T.Type = T.self) -> T {
//        assert(MemoryLayout<T>.size <= count, "Insufficient data to exctract: \(T.self)")
//        defer { skip(MemoryLayout<T>.size) }
//        return unsafeCast(to: T.self)
//    }
//    
//    mutating func extract(count: Int) -> Data {
//        assert(self.count >= count, "Insufficient data to extract bytes.")
//        defer { skip(count) }
//        return prefix(upTo: count)
//    }
//    
//    /// Casts data to a supplied type.
//    func unsafeCast<T>(to type: T.Type = T.self) -> T {
//        return withUnsafeBytes { (pointer: UnsafePointer<T>) -> T in
//            return pointer.pointee
//        }
//    }
//}
