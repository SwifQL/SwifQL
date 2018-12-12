//
//  Reflectable
//
//  Copied from https://github.com/vapor/core
//

import Foundation
import SwifQL
import NIO

struct CoreError: Error {
    var identifier: String
    var reason: String
    var suggestedFixes: [String]
}

/// This protocol allows for reflection of properties on conforming types.
///
/// Ideally Swift type mirroring would handle this completely. In the interim, this protocol
/// acts to fill in the missing gaps.
///
///     struct Pet: Decodable {
///         var name: String
///         var age: Int
///     }
///
///     struct User: Reflectable, Decodable {
///         var id: UUID?
///         var name: String
///         var pet: Pet
///     }
///
///     try User.reflectProperties(depth: 0) // [id: UUID?, name: String, pet: Pet]
///     try User.reflectProperties(depth: 1) // [pet.name: String, pet.age: Int]
///     try User.reflectProperty(forKey: \.name) // ["name"] String
///     try User.reflectProperty(forKey: \.pet.name) // ["pet", "name"] String
///
/// Types that conform to this protocol and are also `Decodable` will get the implementations for free
/// using a decoder to discover the type's structure.
///
/// Any type can conform to `Reflectable` by implementing its two static methods.
///
///     struct User: Reflectable {
///         var firstName: String
///         var lastName: String
///
///         static func reflectProperties(depth: Int) throws -> [ReflectedProperty] {
///             guard depth == 0 else { return [] } // this type only has properties at depth 0
///             return [.init(String.self, at: ["first_name"]), .init(String.self, at: ["last_name"])]
///         }
///
///         static func reflectProperty<T>(forKey keyPath: KeyPath<User, T>) throws -> ReflectedProperty? {
///             let key: String
///             switch keyPath {
///             case \User.firstName: key = "first_name"
///             case \User.lastName: key = "last_name"
///             default: return nil
///             }
///             return .init(T.self, at: [key])
///         }
///     }
///
/// Even if your type gets the default implementation for being `Decodable`, you can still override both
/// the `reflectProperties(depth:)` and `reflectProperty(forKey:)` methods.
public protocol Reflectable: AnyReflectable {
    
    /// Returns a `ReflectedProperty` for the supplied key path.
    ///
    ///     struct Pet: Decodable {
    ///         var name: String
    ///         var age: Int
    ///     }
    ///
    ///     struct User: Reflectable, Decodable {
    ///         var id: UUID?
    ///         var name: String
    ///         var pet: Pet
    ///     }
    ///
    ///     try User.reflectProperty(forKey: \.name) // ["name"] String
    ///     try User.reflectProperty(forKey: \.pet.name) // ["pet", "name"] String
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to reflect a property for.
    /// - throws: Any error reflecting this property.
    /// - returns: `ReflectedProperty` if one was found.
    static func reflectProperty<T>(forKey keyPath: KeyPath<Self, T>) throws -> ReflectedProperty?
}

extension Reflectable {
    /// Reflects all of this type's `ReflectedProperty`s.
    public static func reflectProperties() throws -> [ReflectedProperty] {
        return try reflectProperties(depth: 0)
    }
    
    /// See `Reflectable`.
    public static func reflectProperty<T>(forKey keyPath: KeyPath<Self, T>) throws -> ReflectedProperty? {
        return try anyReflectProperty(valueType: T.self, keyPath: keyPath)
    }
}

/// Type-erased `Reflectable`.
public protocol AnyReflectable {
    /// Reflects all of this type's `ReflectedProperty`s.
    ///
    ///     struct Pet: Decodable {
    ///         var name: String
    ///         var age: Int
    ///     }
    ///
    ///     struct User: Reflectable, Decodable {
    ///         var id: UUID?
    ///         var name: String
    ///         var pet: Pet
    ///     }
    ///
    ///     try User.reflectProperties(depth: 0) // [id: UUID?, name: String, pet: Pet]
    ///     try User.reflectProperties(depth: 1) // [pet.name: String, pet.age: Int]
    ///
    /// - parameters:
    ///     - depth: The level of nesting to use.
    ///              If `0`, the top-most properties will be returned.
    ///              If `1`, the first layer of nested properties, and so-on.
    /// - throws: Any error reflecting this type's properties.
    /// - returns: All `ReflectedProperty`s at the specified depth.
    static func reflectProperties(depth: Int) throws -> [ReflectedProperty]
    
    /// Returns a `ReflectedProperty` for the supplied key path. Use the non-type erased version on
    /// `Reflectable` wherever possible.
    ///
    ///     struct Pet: Decodable {
    ///         var name: String
    ///         var age: Int
    ///     }
    ///
    ///     struct User: Reflectable, Decodable {
    ///         var id: UUID?
    ///         var name: String
    ///         var pet: Pet
    ///     }
    ///
    ///     try User.anyReflectProperty(valueType: String.self, keyPath: \User.name) // ["name"] String
    ///     try User.anyReflectProperty(valueType: String.self, keyPath: \User.pet.name) // ["pet", "name"] String
    ///
    /// - parameters:
    ///     - valueType: Value type of the key path.
    ///     - keyPath: `AnyKeyPath` to reflect a property for.
    /// - throws: Any error reflecting this property.
    /// - returns: `ReflectedProperty` if one was found.
    static func anyReflectProperty(valueType: Any.Type, keyPath: AnyKeyPath) throws -> ReflectedProperty?
}

/// Capable of being represented by an optional wrapped type.
///
/// This protocol mostly exists to allow constrained extensions on generic
/// types where an associatedtype is an `Optional<T>`.
public protocol OptionalType: AnyOptionalType {
    /// Underlying wrapped type.
    associatedtype WrappedType
    
    /// Returns the wrapped type, if it exists.
    var wrapped: WrappedType? { get }
    
    /// Creates this optional type from an optional wrapped type.
    static func makeOptionalType(_ wrapped: WrappedType?) -> Self
}

/// Conform concrete optional to `OptionalType`.
/// See `OptionalType` for more information.
extension Optional: OptionalType {
    /// See `OptionalType.WrappedType`
    public typealias WrappedType = Wrapped
    
    /// See `OptionalType.wrapped`
    public var wrapped: Wrapped? {
        switch self {
        case .none: return nil
        case .some(let w): return w
        }
    }
    
    /// See `OptionalType.makeOptionalType`
    public static func makeOptionalType(_ wrapped: Wrapped?) -> Optional<Wrapped> {
        return wrapped
    }
}

/// Type-erased `OptionalType`
public protocol AnyOptionalType {
    /// Returns the wrapped type, if it exists.
    var anyWrapped: Any? { get }
    
    /// Returns the wrapped type, if it exists.
    static var anyWrappedType: Any.Type { get }
}

extension AnyOptionalType where Self: OptionalType {
    /// See `AnyOptionalType.anyWrapped`
    public var anyWrapped: Any? { return wrapped }
    
    /// See `AnyOptionalType.anyWrappedType`
    public static var anyWrappedType: Any.Type { return WrappedType.self }
}

/// Represents a property on a type that has been reflected using the `Reflectable` protocol.
///
///     let property = try User.reflectProperty(forKey: \.pet.name)
///     print(property) // ["pet", "name"] String
///
public struct ReflectedProperty {
    /// This property's type.
    public let type: Any.Type
    
    /// The path to this property.
    public let path: [String]
    
    /// Creates a new `ReflectedProperty` from a type and path.
    public init<T>(_ type: T.Type, at path: [String]) {
        self.type = T.self
        self.path = path
    }
    
    /// Creates a new `ReflectedProperty` using `Any.Type` and a path.
    public init(any type: Any.Type, at path: [String]) {
        self.type = type
        self.path = path
    }
}

extension Collection where Element == ReflectedProperty {
    /// Removes all optional properties from an array of `ReflectedProperty`.
    public func optionalsRemoved() -> [ReflectedProperty] {
        return filter { !($0.type is AnyOptionalType.Type) }
    }
}

extension ReflectedProperty: CustomStringConvertible {
    /// See `CustomStringConvertible.description`
    public var description: String {
        return "\(path.joined(separator: ".")): \(type)"
    }
}

/// Internal types for powering the default implementation of `Reflectable` for `Decodable` types.
///
/// See `Decodable.decodeProperties(depth:)` and `Decodable.decodeProperty(forKey:)` for more information.

// MARK: Internal

/// Reference class for collecting information about `Decodable` types when initializing them.
final class ReflectionDecoderContext {
    /// If set, this is the `CodingKey` path to the truthy value in the initialized model.
    var activeCodingPath: [CodingKey]?
    
    /// Sets a maximum depth for decoding nested types like optionals and structs. This value ensures
    /// that models with recursive structures can be decoded without looping infinitely.
    var maxDepth: Int
    
    /// An array of all properties seen while initilaizing the `Decodable` type.
    var properties: [ReflectedProperty]
    
    /// If `true`, the property be decoded currently should be set to a truthy value.
    /// This property will cycle each time it is called.
    var isActive: Bool {
        defer { currentOffset += 1 }
        return currentOffset == activeOffset
    }
    
    /// This decoder context's curent active offset. This will determine which property gets
    /// set to a truthy value while decoding.
    private var activeOffset: Int
    
    /// Current offset. This is equal to the number of times `isActive` has been called so far.
    private var currentOffset: Int
    
    /// Creates a new `ReflectionDecoderContext`.
    init(activeOffset: Int, maxDepth: Int) {
        self.activeCodingPath = nil
        self.maxDepth = maxDepth
        self.properties = []
        self.activeOffset = activeOffset
        currentOffset = 0
    }
    
    /// Adds a property to this `ReflectionDecoderContext`.
    func addProperty<T>(type: T.Type, at path: [CodingKey]) {
        let path = path.map { $0.stringValue }
        // remove any duplicates, favoring the new type
        properties = properties.filter { $0.path != path }
        let property = ReflectedProperty.init(T.self, at: path)
        properties.append(property)
    }
}

/// Main decoder for codable reflection.
struct ReflectionDecoder: Decoder {
    var codingPath: [CodingKey]
    var context: ReflectionDecoderContext
    var userInfo: [CodingUserInfoKey: Any] { return [:] }
    
    init(codingPath: [CodingKey], context: ReflectionDecoderContext) {
        self.codingPath = codingPath
        self.context = context
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return .init(ReflectionKeyedDecoder<Key>(codingPath: codingPath, context: context))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return ReflectionUnkeyedDecoder(codingPath: codingPath, context: context)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return ReflectionSingleValueDecoder(codingPath: codingPath, context: context)
    }
}

/// Single value decoder for codable reflection.
struct ReflectionSingleValueDecoder: SingleValueDecodingContainer {
    var codingPath: [CodingKey]
    var context: ReflectionDecoderContext
    
    init(codingPath: [CodingKey], context: ReflectionDecoderContext) {
        self.codingPath = codingPath
        self.context = context
    }
    
    func decodeNil() -> Bool {
        return false
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        context.addProperty(type: T.self, at: codingPath)
        let type = try forceCast(T.self)
        let reflected = try type.anyReflectDecoded()
        if context.isActive {
            context.activeCodingPath = codingPath
            return reflected.0 as! T
        }
        return reflected.1 as! T
    }
}

/// Keyed decoder for codable reflection.
final class ReflectionKeyedDecoder<K>: KeyedDecodingContainerProtocol where K: CodingKey {
    typealias Key = K
    var allKeys: [K] { return [] }
    var codingPath: [CodingKey]
    var context: ReflectionDecoderContext
    var nextIsOptional: Bool
    
    init(codingPath: [CodingKey], context: ReflectionDecoderContext) {
        self.codingPath = codingPath
        self.context = context
        self.nextIsOptional = false
    }
    
    func contains(_ key: K) -> Bool {
        nextIsOptional = true
        return true
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        if context.maxDepth > codingPath.count {
            return false
        }
        return true
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        return .init(ReflectionKeyedDecoder<NestedKey>(codingPath: codingPath + [key], context: context))
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        return ReflectionUnkeyedDecoder(codingPath: codingPath + [key], context: context)
    }
    
    func superDecoder() throws -> Decoder {
        return ReflectionDecoder(codingPath: codingPath, context: context)
    }
    
    func superDecoder(forKey key: K) throws -> Decoder {
        return ReflectionDecoder(codingPath: codingPath + [key], context: context)
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        if nextIsOptional {
            context.addProperty(type: T?.self, at: codingPath + [key])
            nextIsOptional = false
        } else {
            context.addProperty(type: T.self, at: codingPath + [key])
        }
        if let type = T.self as? AnyReflectionDecodable.Type, let reflected = try? type.anyReflectDecoded() {
            if context.isActive {
                context.activeCodingPath = codingPath + [key]
                return reflected.0 as! T
            }
            return reflected.1 as! T
        } else {
            let decoder = ReflectionDecoder(codingPath: codingPath + [key], context: context)
            return try T(from: decoder)
        }
    }
}

/// Unkeyed decoder for codable reflection.
fileprivate struct ReflectionUnkeyedDecoder: UnkeyedDecodingContainer {
    var count: Int?
    var isAtEnd: Bool
    var currentIndex: Int
    var codingPath: [CodingKey]
    var context: ReflectionDecoderContext
    
    init(codingPath: [CodingKey], context: ReflectionDecoderContext) {
        self.codingPath = codingPath
        self.context = context
        self.currentIndex = 0
        if context.isActive {
            self.count = 1
            self.isAtEnd = false
            context.activeCodingPath = codingPath
        } else {
            self.count = 0
            self.isAtEnd = true
        }
    }
    
    mutating func decodeNil() throws -> Bool {
        isAtEnd = true
        return true
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        context.addProperty(type: [T].self, at: codingPath)
        isAtEnd = true
        if let type = T.self as? AnyReflectionDecodable.Type, let reflected = try? type.anyReflectDecoded() {
            return reflected.0 as! T
        } else {
            let decoder = ReflectionDecoder(codingPath: codingPath, context: context)
            return try T(from: decoder)
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return .init(ReflectionKeyedDecoder<NestedKey>(codingPath: codingPath, context: context))
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return ReflectionUnkeyedDecoder(codingPath: codingPath, context: context)
    }
    
    mutating func superDecoder() throws -> Decoder {
        return ReflectionDecoder(codingPath: codingPath, context: context)
    }
}


extension Decodable {
    /// Decodes all `CodableProperty`s for this type. This requires that all propeties on this type are `ReflectionDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperties(depth:)` on `Reflectable`.
    ///
    /// - parameters: depth: The level of nesting to use.
    ///                      If `0`, the top-most properties will be returned.
    ///                      If `1`, the first layer of nested properties, and so-on.
    /// - throws: Any error decoding this type's properties.
    /// - returns: All `ReflectedProperty`s at the specified depth.
    public static func decodeProperties(depth: Int) throws -> [ReflectedProperty] {
        let context = ReflectionDecoderContext(activeOffset: 0, maxDepth: 42)
        let decoder = ReflectionDecoder(codingPath: [], context: context)
        _ = try Self(from: decoder)
        return context.properties.filter { $0.path.count == depth + 1 }
    }
    
    /// Decodes a `CodableProperty` for the supplied `KeyPath`. This requires that all propeties on this
    /// type are `ReflectionDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperty(forKey:)` on `Reflectable`.
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to decode a property for.
    /// - throws: Any error decoding this property.
    /// - returns: `ReflectedProperty` if one was found.
    public static func decodeProperty<T>(forKey keyPath: KeyPath<Self, T>) throws -> ReflectedProperty? {
        return try anyDecodeProperty(valueType: T.self, keyPath: keyPath)
    }
    
    /// Decodes a `CodableProperty` for the supplied `KeyPath`. This requires that all propeties on this
    /// type are `ReflectionDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperty(forKey:)` on `Reflectable`.
    ///
    /// - parameters:
    ///     - keyPath: `AnyKeyPath` to decode a property for.
    /// - throws: Any error decoding this property.
    public static func anyDecodeProperty(valueType: Any.Type, keyPath: AnyKeyPath) throws -> ReflectedProperty? {
        guard valueType is AnyReflectionDecodable.Type else {
            throw CoreError(identifier: "ReflectionDecodable", reason: "`\(valueType)` does not conform to `ReflectionDecodable`.", suggestedFixes: [])
        }
        
        if let cached = ReflectedPropertyCache.storage[keyPath] {
            return cached
        }
        
        var maxDepth = 0
        a: while true {
            defer { maxDepth += 1 }
            var activeOffset = 0
            
            if maxDepth > 42 {
                return nil
            }
            
            b: while true {
                defer { activeOffset += 1 }
                let context = ReflectionDecoderContext(activeOffset: activeOffset, maxDepth: maxDepth)
                let decoder = ReflectionDecoder(codingPath: [], context: context)
                
                let decoded = try Self(from: decoder)
                guard let codingPath = context.activeCodingPath else {
                    // no more values are being set at this depth
                    break b
                }
                
                guard let t = valueType as? AnyReflectionDecodable.Type, let left = decoded[keyPath: keyPath] else {
                    break b
                }
                
                if try t.anyReflectDecodedIsLeft(left) {
                    let property = ReflectedProperty(any: valueType, at: codingPath.map { $0.stringValue })
                    ReflectedPropertyCache.storage[keyPath] = property
                    return property
                }
            }
        }
    }
}

/// Caches derived `ReflectedProperty`s so that they only need to be decoded once per thread.
final class ReflectedPropertyCache {
    /// Thread-specific shared storage.
    static var storage: [AnyKeyPath: ReflectedProperty] {
        get {
            let cache = ReflectedPropertyCache.thread.currentValue ?? .init()
            return cache.storage
        }
        set {
            let cache = ReflectedPropertyCache.thread.currentValue ?? .init()
            cache.storage = newValue
            ReflectedPropertyCache.thread.currentValue = cache
        }
    }
    
    /// Private `ThreadSpecificVariable` powering this cache.
    private static let thread: ThreadSpecificVariable<ReflectedPropertyCache> = .init()
    
    /// Instance storage.
    private var storage: [AnyKeyPath: ReflectedProperty]
    
    /// Creates a new `ReflectedPropertyCache`.
    init() {
        self.storage = [:]
    }
}

/// Types conforming to this protocol can be created dynamically for use in reflecting the structure of a `Decodable` type.
///
/// `ReflectionDecodable` requires that a type declare two _distinct_ representations of itself. It also requires that the type
/// declare a method for comparing those two representations. If the conforming type is already equatable, this method will
/// not be required.
///
/// A `Bool` is a simple type that is capable of conforming to `ReflectionDecodable`:
///
///     extension Bool: ReflectionDecodable {
///         static func reflectDecoded() -> (Bool, Bool) { return (false, true) }
///     }
///
/// For some types, like an `enum` with only one case, it is impossible to conform to `ReflectionDecodable`. In these situations
/// you must expand the type to have at least two distinct cases, or use a different method of reflection.
///
///     enum Pet { case cat } // unable to conform
///
/// Enums with two or more cases can conform.
///
///     enum Pet { case cat, dog }
///     extension Pet: ReflectionDecodable {
///         static func reflectDecoded() -> (Pet, Pet) { return (.cat, .dog) }
///     }
///
/// Many types already conform to `ReflectionDecodable` such as `String`, `Int`, `Double`, `UUID`, `Array`, `Dictionary`, and `Optional`.
///
/// Other types will have free implementation provided when conformance is added, like `RawRepresentable` types.
///
///     enum Direction: UInt8, ReflectionDecodable {
///         case left, right
///     }
///
public protocol ReflectionDecodable: AnyReflectionDecodable {
    /// Returns a tuple containing two _distinct_ instances for this type.
    ///
    ///     extension Bool: ReflectionDecodable {
    ///         static func reflectDecoded() -> (Bool, Bool) { return (false, true) }
    ///     }
    ///
    /// - throws: Any errors deriving these distinct instances.
    /// - returns: Two distinct instances of this type.
    static func reflectDecoded() throws -> (Self, Self)
    
    /// Returns `true` if the supplied instance of this type is equal to the _left_ instance returned
    /// by `reflectDecoded()`.
    ///
    ///     extension Pet: ReflectionDecodable {
    ///         static func reflectDecoded() -> (Pet, Pet) { return (cat, dog) }
    ///     }
    ///
    /// In the case of the above example, this method should return `true` if supplied `Pet.cat` and false for anything else.
    /// This method is automatically implemented for types that conform to `Equatable.
    ///
    /// - throws: Any errors comparing instances.
    /// - returns: `true` if supplied instance equals left side of `reflectDecoded()`.
    static func reflectDecodedIsLeft(_ item: Self) throws -> Bool
}

extension ReflectionDecodable where Self: Equatable {
    /// Default implememntation for `ReflectionDecodable` that are also `Equatable`.
    ///
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    public static func reflectDecodedIsLeft(_ item: Self) throws -> Bool {
        return try Self.reflectDecoded().0 == item
    }
}

// MARK: Types

extension String: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (String, String) { return ("0", "1") }
}

extension FixedWidthInteger {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Self, Self) { return (0, 1) }
}

extension UInt: ReflectionDecodable { }
extension UInt8: ReflectionDecodable { }
extension UInt16: ReflectionDecodable { }
extension UInt32: ReflectionDecodable { }
extension UInt64: ReflectionDecodable { }

extension Int: ReflectionDecodable { }
extension Int8: ReflectionDecodable { }
extension Int16: ReflectionDecodable { }
extension Int32: ReflectionDecodable { }
extension Int64: ReflectionDecodable { }

extension Bool: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Bool, Bool) { return (false, true) }
}

extension BinaryFloatingPoint {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Self, Self) { return (0, 1) }
}

extension Decimal: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Decimal, Decimal) { return (0, 1) }
}

extension Float: ReflectionDecodable { }
extension Double: ReflectionDecodable { }

extension UUID: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (UUID, UUID) {
        let left = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
        let right = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2))
        return (left, right)
    }
}

extension Data: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Data, Data) {
        let left = Data([0x00])
        let right = Data([0x01])
        return (left, right)
    }
}

extension Date: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() -> (Date, Date) {
        let left = Date(timeIntervalSince1970: 1)
        let right = Date(timeIntervalSince1970: 0)
        return (left, right)
    }
}

extension Optional: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() throws -> (Wrapped?, Wrapped?) {
        let reflected = try forceCast(Wrapped.self).anyReflectDecoded()
        return (reflected.0 as? Wrapped, reflected.1 as? Wrapped)
    }
    
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    public static func reflectDecodedIsLeft(_ item: Wrapped?) throws -> Bool {
        guard let wrapped = item else {
            return false
        }
        return try forceCast(Wrapped.self).anyReflectDecodedIsLeft(wrapped)
    }
}

extension Array: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() throws -> ([Element], [Element]) {
        let reflected = try forceCast(Element.self).anyReflectDecoded()
        return ([reflected.0 as! Element], [reflected.1 as! Element])
    }
    
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    public static func reflectDecodedIsLeft(_ item: [Element]) throws -> Bool {
        return try forceCast(Element.self).anyReflectDecodedIsLeft(item[0])
    }
}

extension Dictionary: ReflectionDecodable {
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func reflectDecoded() throws -> ([Key: Value], [Key: Value]) {
        let reflectedValue = try forceCast(Value.self).anyReflectDecoded()
        let reflectedKey = try forceCast(Key.self).anyReflectDecoded()
        let key = reflectedKey.0 as! Key
        return ([key: reflectedValue.0 as! Value], [key: reflectedValue.1 as! Value])
    }
    
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    public static func reflectDecodedIsLeft(_ item: [Key: Value]) throws -> Bool {
        let reflectedKey = try forceCast(Key.self).anyReflectDecoded()
        let key = reflectedKey.0 as! Key
        return try forceCast(Value.self).anyReflectDecodedIsLeft(item[key]!)
    }
}

// MARK: Type Erased

/// Type-erased version of `ReflectionDecodable`
public protocol AnyReflectionDecodable {
    /// Type-erased version of `ReflectionDecodable.reflectDecoded()`.
    ///
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    static func anyReflectDecoded() throws -> (Any, Any)
    
    /// Type-erased version of `ReflectionDecodable.reflectDecodedIsLeft(_:)`.
    ///
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    static func anyReflectDecodedIsLeft(_ any: Any) throws -> Bool
}

extension ReflectionDecodable {
    /// Type-erased version of `ReflectionDecodable.reflectDecoded()`.
    ///
    /// See `ReflectionDecodable.reflectDecoded()` for more information.
    public static func anyReflectDecoded() throws -> (Any, Any) {
        let reflected = try reflectDecoded()
        return (reflected.0, reflected.1)
    }
    
    /// Type-erased version of `ReflectionDecodable.reflectDecodedIsLeft(_:)`.
    ///
    /// See `ReflectionDecodable.reflectDecodedIsLeft(_:)` for more information.
    public static func anyReflectDecodedIsLeft(_ any: Any) throws -> Bool {
        return try reflectDecodedIsLeft(any as! Self)
    }
}

/// Trys to cast a type to `AnyReflectionDecodable.Type`. This can be removed when conditional conformance supports runtime querying.
func forceCast<T>(_ type: T.Type) throws -> AnyReflectionDecodable.Type {
    guard let casted = T.self as? AnyReflectionDecodable.Type else {
        throw CoreError(
            identifier: "ReflectionDecodable",
            reason: "\(T.self) is not `ReflectionDecodable`",
            suggestedFixes: [
                "Conform `\(T.self)` to `ReflectionDecodable`: `extension \(T.self): ReflectionDecodable { }`."
            ]
        )
    }
    return casted
}

#if swift(>=4.1.50)
#else
public protocol CaseIterable {
static var allCases: [Self] { get }
}
#endif

extension ReflectionDecodable where Self: CaseIterable {
    /// Default implementation of `ReflectionDecodable` for enums that are also `CaseIterable`.
    ///
    /// See `ReflectionDecodable.reflectDecoded(_:)` for more information.
    public static func reflectDecoded() throws -> (Self, Self) {
        /// enum must have at least 2 unique cases
        guard allCases.count > 1,
            let first = allCases.first, let last = allCases.suffix(1).first else {
                throw CoreError(
                    identifier: "ReflectionDecodable",
                    reason: "\(Self.self) enum must have at least 2 cases",
                    suggestedFixes: [
                        "Add at least 2 cases to the enum."
                    ]
                )
        }
        return (first, last)
    }
}
