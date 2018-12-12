//import Foundation
//
//extension Data: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Data {
//        guard case .bytea = data.type else {
//            throw PostgreSQLError.decode(self, from: data)
//        }
//        switch data.storage{
//        case .text(let string): return Data(hexString: .init(string.dropFirst(2)))
//        case .binary(let value): return value
//        case .null: throw PostgreSQLError.decode(self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return PostgreSQLData(.bytea, binary: self)
//    }
//}
//
//extension Data {
//    /// Initialize data from a hex string.
//    internal init(hexString: String) {
//        var data = Data()
//
//        var gen = hexString.makeIterator()
//        while let c1 = gen.next(), let c2 = gen.next() {
//            let s = String([c1, c2])
//            guard let d = UInt8(s, radix: 16) else {
//                break
//            }
//
//            data.append(d)
//        }
//
//        self.init(data)
//    }
//}
