//import Foundation
//
//struct PostgreSQLDataDecoder {
//    /// Creates a new `PostgreSQLDataDecoder`.
//    init() {}
//    
//    func decode<D>(_ type: D.Type, from data: PostgreSQLData) throws -> D where D: Decodable {
//        if let convertible = type as? PostgreSQLDataConvertible.Type {
//            return try convertible.convertFromPostgreSQLData(data) as! D
//        }
//        return try D(from: _Decoder(data: data))
//    }
//    
//    // MARK: Private
//    
//    private struct _Decoder: Decoder {
//        let codingPath: [CodingKey] = []
//        var userInfo: [CodingUserInfoKey: Any] = [:]
//        let data: PostgreSQLData
//        
//        init(data: PostgreSQLData) {
//            self.data = data
//        }
//        
//        struct DecoderUnwrapper: Decodable {
//            let decoder: Decoder
//            init(from decoder: Decoder) throws {
//                self.decoder = decoder
//            }
//        }
//        
//        struct JSON { }
//        
//        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
//            let json: Data
//            switch data.type {
//            case .jsonb, .json:
//                switch data.storage {
//                case .binary(let data):
//                    assert(data[data.startIndex] == 0x01, "invalid JSONB data format")
//                    json = data.advanced(by: 1)
//                case .text(let string): json = Data(string.utf8)
//                default: throw PostgreSQLError.decode(JSON.self, from: data)
//                }
//            default: throw PostgreSQLError.decode(JSON.self, from: data)
//            }
//            let unwrapper = try JSONDecoder().decode(DecoderUnwrapper.self, from: json)
//            return try unwrapper.decoder.container(keyedBy: Key.self)
//        }
//        
//        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
//            switch data.storage {
//            case .binary(var value):
//                /// Extract and convert each element.
//                var array: [PostgreSQLData] = []
//                let hasData = value.extract(Int32.self).bigEndian
//                if hasData == 1 {
//                    /// Unknown
//                    let _ = value.extract(Int32.self).bigEndian
//                    /// The big-endian array element type
//                    let type: PostgreSQLDataFormat = .init(value.extract(Int32.self).bigEndian)
//                    /// The big-endian length of the array
//                    let count = value.extract(Int32.self).bigEndian
//                    /// The big-endian number of dimensions
//                    let _ = value.extract(Int32.self).bigEndian
//                    for _ in 0..<count {
//                        let count = Int(value.extract(Int32.self).bigEndian)
//                        let subValue = value.extract(count: count)
//                        let psqlData = PostgreSQLData(type, binary: subValue)
//                        array.append(psqlData)
//                    }
//                } else {
//                    array = []
//                }
//                return _UnkeyedDecodingContainer(data: array)
//            default: throw PostgreSQLError(identifier: "array", reason: "Cannot decode array from: \(data).")
//            }
//        }
//        
//        func singleValueContainer() throws -> SingleValueDecodingContainer {
//            return _SingleValueDecodingContainer(data: data)
//        }
//    }
//    
//    private struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
//        let codingPath: [CodingKey] = []
//        let data: [PostgreSQLData]
//        var count: Int? {
//            return data.count
//        }
//        var isAtEnd: Bool {
//            return currentIndex >= data.count
//        }
//        var currentIndex: Int
//        
//        init(data: [PostgreSQLData]) {
//            self.data = data
//            self.currentIndex = 0
//        }
//        
//        mutating func decodeNil() throws -> Bool {
//            defer { currentIndex += 1 }
//            return data[currentIndex].isNull
//        }
//        
//        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
//            defer { currentIndex += 1 }
//            return try PostgreSQLDataDecoder().decode(T.self, from: data[currentIndex])
//        }
//        
//        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
//            fatalError()
//        }
//        
//        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
//            fatalError()
//        }
//        
//        mutating func superDecoder() throws -> Decoder {
//            fatalError()
//        }
//        
//    }
//    
//    private struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
//        let codingPath: [CodingKey] = []
//        let data: PostgreSQLData
//        
//        init(data: PostgreSQLData) {
//            self.data = data
//        }
//        
//        public func decodeNil() -> Bool {
//            switch data.storage {
//            case .null: return true
//            default: return false
//            }
//        }
//        
//        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
//            guard let convertible = type as? PostgreSQLDataConvertible.Type else {
//                return try T(from: _Decoder(data: data))
//            }
//            return try convertible.convertFromPostgreSQLData(data) as! T
//        }
//    }
//}
