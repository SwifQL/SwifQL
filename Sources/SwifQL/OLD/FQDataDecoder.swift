//import Foundation
//import FluentPostgreSQL
//import Fluent
//
//public typealias PostgreSQLRow = [PostgreSQL.PostgreSQLColumn: PostgreSQL.PostgreSQLData]
//typealias PostgreSQLInternalRow = [PostgreSQLColumn: PostgreSQLData]
//
//protocol FQLErrorProtocol: LocalizedError {
//    var identifier: String { get }
//    var reason: String { get }
//}
//
//struct FQLError: FQLErrorProtocol {
//    var identifier: String
//    var reason: String {
//        return _description
//    }
//    var errorDescription: String? { return _description }
//    var failureReason: String? { return _description }
//    
//    private var _description: String
//    
//    init(identifier: String, reason: String) {
//        self.identifier = identifier
//        self._description = reason
//    }
//}
//
//extension EventLoopFuture where T == [PostgreSQLRow] {
//    public func decode<T>(_ to: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> EventLoopFuture<[T]> where T: Decodable {
//        return map { return try $0.decode(T.self, dateDecodingStrategy: dateDecodingStrategy) }
//    }
//}
//
//extension Array where Element == PostgreSQLRow {
//    func convert() throws -> [PostgreSQLInternalRow] {
//        return try map { try $0.convert() }
//    }
//    
//    public func decode<T>(_ to: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> [T] where T: Decodable {
//        return try map { try $0.convert().decode(T.self, dateDecodingStrategy: dateDecodingStrategy) }
//    }
//}
//
//extension Dictionary where Key == PostgreSQL.PostgreSQLColumn, Value == PostgreSQL.PostgreSQLData {
//    func convert() throws -> PostgreSQLInternalRow {
//        var internalRow: PostgreSQLInternalRow = [:]
//        try keys.forEach { column in
//            guard let data = self[column] else { throw FQLError(identifier: "internalServerError", reason: "") }
//            if let binary = data.binary {
//                internalRow[PostgreSQLColumn(tableOID: column.tableOID, name: column.name)] = PostgreSQLData(type: PostgreSQLDataFormat(data.type.raw), storage: PostgreSQLData.Storage.convert(binary) )
//            } else if let text = data.text {
//                internalRow[PostgreSQLColumn(tableOID: column.tableOID, name: column.name)] = PostgreSQLData(type: PostgreSQLDataFormat(data.type.raw), storage: PostgreSQLData.Storage.convert(text) )
//            }
//        }
//        return internalRow
//    }
//}
//
//extension Dictionary where Key == PostgreSQLColumn, Value == PostgreSQLData {
//    public func decode<T>(_ to: [T.Type], dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> T where T: Decodable {
//        return try decode(T.self, dateDecodingStrategy: dateDecodingStrategy)
//    }
//    
//    public func decode<T>(_ to: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> T where T: Decodable {
//        let convertedRowValues = map { (QueryField(name: $0.name), $1) }
//        let convertedRow = Dictionary<QueryField, PostgreSQLData>(uniqueKeysWithValues: convertedRowValues)
//        return try FQDataDecoder(PostgreSQLDatabase.self, entity: nil, dateDecodingStrategy: dateDecodingStrategy).decode(to, from: convertedRow)
//    }
//}
//
//// Renamed decoder from Fluent repo
//// copied it just to make it public to start using it
//// will remove it when Fluent will make it public
//
//public final class FQDataDecoder<Database> where Database: QuerySupporting {
//    var entity: String?
//    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
//    public init(_ database: Database.Type, entity: String? = nil, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
//        self.entity = entity
//        self.dateDecodingStrategy = dateDecodingStrategy
//    }
//    public func decode<D>(_ type: D.Type, from data: [QueryField: PostgreSQLData]) throws -> D where D: Decodable {
//        let decoder = _QueryDataDecoder<Database>(data: data, entity: entity, dateDecodingStrategy: dateDecodingStrategy)
//        return try D.init(from: decoder)
//    }
//}
//
///// MARK: Private
//
//fileprivate final class _QueryDataDecoder<Database>: Decoder where Database: QuerySupporting {
//    var codingPath: [CodingKey] { return [] }
//    var userInfo: [CodingUserInfoKey: Any] { return [:] }
//    var data: [QueryField: PostgreSQLData]
//    var entity: String?
//    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
//    init(data: [QueryField: PostgreSQLData], entity: String?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
//        self.data = data
//        self.entity = entity
//        self.dateDecodingStrategy = dateDecodingStrategy
//    }
//    
//    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
//        return KeyedDecodingContainer(_QueryDataKeyedDecoder<Key, Database>(decoder: self, entity: entity, dateDecodingStrategy: dateDecodingStrategy))
//    }
//    
//    func unkeyedContainer() throws -> UnkeyedDecodingContainer { throw unsupported() }
//    func singleValueContainer() throws -> SingleValueDecodingContainer { throw unsupported() }
//}
//
//private func unsupported() -> FQLError {
//    return FQLError(
//        identifier: "rowDecode",
//        reason: "PostgreSQL rows only support a flat, keyed structure `[String: T]` You can conform nested types to `PostgreSQLJSONType` or `PostgreSQLArrayType`. (Nested types must be `PostgreSQLDataCustomConvertible`.)"
//    )
//}
//
//
//fileprivate struct _QueryDataKeyedDecoder<K, Database>: KeyedDecodingContainerProtocol
//    where K: CodingKey, Database: QuerySupporting
//{
//    var allKeys: [K] {
//        return decoder.data.keys.compactMap { K(stringValue: $0.name) }
//    }
//    var codingPath: [CodingKey] { return [] }
//    let decoder: _QueryDataDecoder<Database>
//    var entity: String?
//    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
//    init(decoder: _QueryDataDecoder<Database>, entity: String?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
//        self.decoder = decoder
//        self.entity = entity
//        if let dateDecodingStrategy = dateDecodingStrategy {
//            self.dateDecodingStrategy = dateDecodingStrategy
//        } else {
//            let formatter = FQDateFormatter()
//            self.dateDecodingStrategy = .formatted(formatter)
//        }
//    }
//    
//    func _value(forEntity entity: String?, atField field: String) -> PostgreSQLData? {
//        guard let entity = entity else {
//            return decoder.data.firstValue(forField: field)
//        }
//        return decoder.data.value(forEntity: entity, atField: field) ?? decoder.data.firstValue(forField: field)
//    }
//    
//    func _parse<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
//        guard let data = _value(forEntity: entity, atField: key.stringValue)  else {
//            return nil
//        }
//        if data.isNull {
//            return nil
//        }
//        if data.type == .jsonb {
//            if let data = data.binary {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = dateDecodingStrategy
//                do {
//                    return try decoder.decode(T.self, from: data[1...])
//                } catch {
//                    throw FQLError(identifier: "decodingError", reason: "\(error) (\(type) nested model)")
//                }
//            } else {
//                return nil
//            }
//        }
//        
//        return try PostgreSQLDataDecoder().decode(T.self, from: data)//queryDataParse(T.self, from: data)
//    }
//    
//    func contains(_ key: K) -> Bool { return decoder.data.keys.contains { $0.name == key.stringValue } }
//    func decodeNil(forKey key: K) throws -> Bool { return _value(forEntity: entity, atField: key.stringValue) == nil }
//    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? { return try _parse(Int.self, forKey: key) }
//    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? { return try _parse(Int8.self, forKey: key) }
//    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? { return try _parse(Int16.self, forKey: key) }
//    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? { return try _parse(Int32.self, forKey: key) }
//    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? { return try _parse(Int64.self, forKey: key) }
//    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {  return try _parse(UInt.self, forKey: key) }
//    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? { return try _parse(UInt8.self, forKey: key) }
//    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? { return try _parse(UInt16.self, forKey: key) }
//    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? { return try _parse(UInt32.self, forKey: key) }
//    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? { return try _parse(UInt64.self, forKey: key) }
//    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? { return try _parse(Double.self, forKey: key) }
//    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? { return try _parse(Float.self, forKey: key) }
//    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? { return try _parse(Bool.self, forKey: key) }
//    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? { return try _parse(String.self, forKey: key) }
//    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable { return try _parse(T.self, forKey: key) }
//    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
//        guard let t = try _parse(T.self, forKey: key) else {
//            throw FQLError(identifier: "missingValue", reason: "No value found for key: \(key)")
//        }
//        return t
//    }
//    
//    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey>
//        where NestedKey : CodingKey { return try decoder.container(keyedBy: NestedKey.self) }
//    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer { return try decoder.unkeyedContainer() }
//    func superDecoder() throws -> Decoder { return decoder }
//    func superDecoder(forKey key: K) throws -> Decoder { return decoder }
//}
//
//
//////////////////////////////////////////////////////////////////////////
///// Copy of QueryField implementation from old version of Fluent
//////////////////////////////////////////////////////////////////////////
//
///// Represents a field and its optional entity in a query.
///// This is used mostly for query filters.
//public struct QueryField: Hashable {
//    /// See `Hashable.hashValue`
//    public var hashValue: Int {
//        return (entity ?? "<nil>" + "." + name).hashValue
//    }
//    
//    /// See `Equatable.==`
//    public static func ==(lhs: QueryField, rhs: QueryField) -> Bool {
//        return lhs.name == rhs.name && lhs.entity == rhs.entity
//    }
//    
//    /// The entity for this field.
//    /// If the entity is nil, the query's default entity will be used.
//    public var entity: String?
//    
//    /// The name of the field.
//    public var name: String
//    
//    /// Create a new query field.
//    public init(entity: String? = nil, name: String) {
//        self.entity = entity
//        self.name = name
//    }
//}
//
//extension QueryField: CustomStringConvertible {
//    /// See `CustomStringConvertible.description`
//    public var description: String {
//        return (entity ?? "<nil>") + "." + name
//    }
//}
//
//extension QueryField: ExpressibleByStringLiteral {
//    /// See `ExpressibleByStringLiteral.init(stringLiteral:)`
//    public init(stringLiteral value: String) {
//        self.init(name: value)
//    }
//}
//
//extension Dictionary where Key == QueryField {
//    /// Accesses the _first_ value from this dictionary with a matching field name.
//    public func firstValue(forField fieldName: String) -> Value? {
//        for (field, value) in self {
//            if field.name == fieldName {
//                return value
//            }
//        }
//        return nil
//    }
//    
//    /// Access a `Value` from this dictionary keyed by `QueryField`s
//    /// using a field (column) name and entity (table) name.
//    public func value(forEntity entity: String, atField field: String) -> Value? {
//        return self[QueryField(entity: entity, name: field)]
//    }
//    
//    /// Removes all values that have non-matching entities.
//    /// note: `QueryField`s with `nil` entities will still be included.
//    public func onlyValues(forEntity entity: String) -> [QueryField: Value] {
//        var result: [QueryField: Value] = [:]
//        for (field, value) in self {
//            if field.entity == nil || field.entity == entity {
//                result[field] = value
//            }
//        }
//        return result
//    }
//}
//
///// Conform key path's where the root is a model.
///// FIXME: conditional conformance
//extension KeyPath where Root: Model {
//    /// See QueryFieldRepresentable.makeQueryField()
//    public func makeQueryField() throws -> QueryField {
//        guard let key = try Root.reflectProperty(forKey: self) else {
//            throw FQLError(identifier: "reflectProperty", reason: "No property reflected for \(self)")
//        }
//        return QueryField(entity: Root.entity, name: key.path.first ?? "")
//    }
//}
//
///// Allow models to easily generate query fields statically.
//extension Model {
//    /// Generates a query field with the supplied name for this model.
//    ///
//    /// You can use this method to create static variables on your model
//    /// for easier access without having to repeat strings.
//    ///
//    ///     extension User: Model {
//    ///         static let nameField = User.field("name")
//    ///     }
//    ///
//    public static func field(_ name: String) -> QueryField {
//        return QueryField(entity: Self.entity, name: name)
//    }
//}
//
//// MARK: Coding key
//
///// Allow query fields to be used as coding keys.
//extension QueryField: CodingKey {
//    /// See CodingKey.stringValue
//    public var stringValue: String {
//        return name
//    }
//    
//    /// See CodingKey.intValue
//    public var intValue: Int? {
//        return nil
//    }
//    
//    /// See CodingKey.init(stringValue:)
//    public init?(stringValue: String) {
//        self.init(name: stringValue)
//    }
//    
//    /// See CodingKey.init(intValue:)
//    public init?(intValue: Int) {
//        return nil
//    }
//}
//
//extension Model {
//    /// Creates a query field decoding container for this model.
//    public static func decodingContainer(for decoder: Decoder) throws -> QueryFieldDecodingContainer<Self> {
//        let container = try decoder.container(keyedBy: QueryField.self)
//        return QueryFieldDecodingContainer(container: container)
//    }
//    
//    /// Creates a query field encoding container for this model.
//    public func encodingContainer(for encoder: Encoder) -> QueryFieldEncodingContainer<Self> {
//        let container = encoder.container(keyedBy: QueryField.self)
//        return QueryFieldEncodingContainer(container: container, model: self)
//    }
//}
//
///// A container for decoding model key paths.
//public struct QueryFieldDecodingContainer<Model> where Model: Fluent.Model {
//    /// The underlying container.
//    public var container: KeyedDecodingContainer<QueryField>
//    
//    /// Decodes a model key path to a type.
//    public func decode<T: Decodable>(key: KeyPath<Model, T>) throws -> T {
//        let field = try key.makeQueryField()
//        return try container.decode(T.self, forKey: field)
//    }
//}
//
///// A container for encoding model key paths.
//public struct QueryFieldEncodingContainer<Model: Fluent.Model> {
//    /// The underlying container.
//    public var container: KeyedEncodingContainer<QueryField>
//    
//    /// The model being encoded.
//    public var model: Model
//    
//    /// Encodes a model key path to the encoder.
//    public mutating func encode<T: Encodable>(key: KeyPath<Model, T>) throws {
//        let field = try key.makeQueryField()
//        let value: T = model[keyPath: key]
//        try container.encode(value, forKey: field)
//    }
//}
