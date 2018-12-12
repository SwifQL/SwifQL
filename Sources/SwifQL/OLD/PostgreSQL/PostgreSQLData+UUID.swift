//import Foundation
//
//extension UUID: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> UUID {
//        guard case .uuid = data.type else {
//            throw PostgreSQLError.decode(self, from: data)
//        }
//        switch data.storage {
//        case .text(let string):
//            guard let uuid = UUID(uuidString: string) else {
//                throw PostgreSQLError.decode(self, from: data)
//            }
//            return uuid
//        case .binary(let value): return UUID(uuid: value.unsafeCast())
//        case .null: throw PostgreSQLError.decode(self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        var uuid = self.uuid
//        let size = MemoryLayout.size(ofValue: uuid)
//        return PostgreSQLData(.uuid, binary: withUnsafePointer(to: &uuid) {
//            Data(bytes: $0, count: size)
//        })
//    }
//}
