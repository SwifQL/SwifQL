//
//  SwifQLTableAlias.swift
//  SwifQL
//
//  Created by Mihael Isaev on 11/11/2018.
//

import Foundation

protocol SwifQLTableAliasable {
    var alias: String { get }
}

public class SwifQLTableAlias<M: Decodable>: SwifQLable, SwifQLTableAliasable {
    public typealias Model = M
    
    public var parts: [SwifQLPart] {
        [SwifQLPartTable(alias)]
    }
    
    public var table: SwifQLable {
        SwifQLableParts(parts: SwifQLPartTableWithAlias(name, alias))
    }
    
    var name: String {
        if let mmm = M.self as? Tableable.Type {
            return mmm.entity
        }
        return String(describing: M.self)
    }
    
    var alias: String
    
    public init(_ alias: String) {
        self.alias = alias
    }
    
    public func column(_ paths: String...) -> Path.TableWithColumn {
        Path.Table(alias).column(paths)
    }
    
    //MARK: SQLQueryPart
    
    //    public func k<V>(_ kp: KeyPath<M, V>) -> AliasedKeyPath<M, V> {
    //        return AliasedKeyPath(alias, kp)
    //    }
}

postfix operator *
postfix public func *<T: Decodable>(table: SwifQLTableAlias<T>) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(SwifQLPartTable(table.alias))
    parts.append(o: .custom(".*"))
    parts.append(o: .space)
    return SwifQLableParts(parts: parts)
}
postfix public func *(table: Tableable.Type) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(SwifQLPartTable(table.entity))
    parts.append(o: .custom(".*"))
    parts.append(o: .space)
    return SwifQLableParts(parts: parts)
}

//MARK: Decodable extension

extension Decodable {
    public static func `as`(_ alias: String) -> SwifQLTableAlias<Self> {
        SwifQLTableAlias(alias)
    }
}

//MARK: AliasedKeyPath

public class AliasedKeyPath<K, T, V> where K: KeyPath<T, V>, K: Keypathable, T: Decodable {
    var alias: String
    var kp: K
    init(_ alias: String, _ kp: K) {
        self.alias = alias
        self.kp = kp
    }
}

extension AliasedKeyPath: SwifQLKeyPathable {
    public var table: String? { alias }
    public var paths: [String] { kp.paths }
}

extension AliasedKeyPath: SwifQLable {
    public var parts: [SwifQLPart] {
        if let kp = self.originalKeyPath as? FluentKitFieldable {
            return [SwifQLPartKeyPath(table: table, paths: [kp.key])]
        }
        return [SwifQLPartKeyPath(table: table, paths: paths)]
    }
}

extension AliasedKeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple {
    public typealias AType = V
    public typealias AModel = T
    public typealias ARoot = AliasedKeyPath
    
    public var queryValue: String { kp.fullPath(table: alias) }
    public var path: String { kp.shortPath }
    public var lastPath: String { kp.lastPath }
    public var originalKeyPath: KeyPath<T, V> { kp }
}
