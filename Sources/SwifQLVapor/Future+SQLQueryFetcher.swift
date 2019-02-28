//
//  Future+SQLQueryFetcher.swift
//  SwifQLVapor
//
//  Created by Mihael Isaev on 12/12/2018.
//

import Core
import SQL

/// a bridge to SQLQueryFetcher through Future
extension Future where T: SQLQueryFetcher {
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<D>(decoding type: D.Type) -> Future<D?> where D : Decodable {
        return flatMap { $0.first(decoding: D.self) }
    }
    
    /// Decodes two types from the result set. Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self, Galaxy.self)
    ///
    public func first<A, B>(decoding a: A.Type, _ b: B.Type) -> Future<(A, B)?> where A : SQLTable, B : SQLTable {
        return flatMap { $0.first(decoding: A.self, B.self) }
    }
    
    /// Decodes three types from the result set. Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self, Galaxy.self, SolarSystem.self)
    ///
    public func first<A, B, C>(decoding a: A.Type, _ b: B.Type, _ c: C.Type) -> Future<(A, B, C)?> where A : SQLTable, B : SQLTable, C : SQLTable {
        return flatMap { $0.first(decoding: A.self, B.self, C.self) }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A>(decoding type: A.Type) -> Future<[A]> where A : Decodable {
        return flatMap { $0.all(decoding: A.self) }
    }
    
    /// Decodes two types from the result set. Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self, Galaxy.self)
    ///
    public func all<A, B>(decoding a: A.Type, _ b: B.Type) -> Future<[(A, B)]> where A : Decodable, B : Decodable {
        return flatMap { $0.all(decoding: A.self, B.self) }
    }
    
    /// Decodes three types from the result set. Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self, Galaxy.self, SolarSystem.self)
    ///
    public func all<A, B, C>(decoding a: A.Type, _ b: B.Type, _ c: C.Type) -> Future<[(A, B, C)]> where A : Decodable, B : Decodable, C : Decodable {
        return flatMap { $0.all(decoding: A.self, B.self, C.self) }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self) { planet in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A>(decoding type: A.Type, into handler: @escaping (A) throws -> ()) -> Future<Void> where A : Decodable {
        return flatMap { $0.run(decoding: A.self, into: handler) }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self) { planet, galaxy in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B>(decoding a: A.Type, _ b: B.Type, into handler: @escaping (A, B) throws -> ()) -> Future<Void> where A : Decodable, B : Decodable {
        return flatMap { $0.run(decoding: A.self, B.self, into: handler) }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B, C>(decoding a: A.Type, _ b: B.Type, _ c: C.Type, into handler: @escaping (A, B, C) throws -> ()) -> Future<Void> where A : Decodable, B : Decodable, C : Decodable {
        return flatMap { $0.run(decoding: A.self, B.self, C.self, into: handler) }
    }
}
