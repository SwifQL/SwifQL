//
//  KeyPath.swift
//  SwifQLVapor
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation
import SwifQL
import Core

extension KeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple, KeyPathLastPath  where Root: Decodable & Reflectable {
    public typealias AType = Value
    public typealias AModel = Root
    public typealias ARoot = KeyPath
    
    public var queryValue: String {
        return formattedPath(Root.self, self).pathWithTable
    }
    
    public var path: String {
        return formattedPath(Root.self, self).path
    }
    
    public var lastPath: String {
        return formattedPath(Root.self, self).lastPath
    }
    
    public var originalKeyPath: KeyPath<Root, Value> {
        return self
    }
}

struct FormattedPath {
    var queryString: String
    var path: String
}

struct _FormattedKeyPath {
    var pathWithTable: String = ""
    var path: String = ""
    var lastPath: String = ""
    
    init (table: String, paths: [String]) {
        pathWithTable.append(table.doubleQuotted)
        path = _FormattedKeyPath.flattenKeyPath(paths)
        pathWithTable.append(".")
        pathWithTable.append(path)
        lastPath = paths.last ?? ""
    }
    
    static func flattenKeyPath(_ paths: [String]) -> String {
        var path = ""
        for (index, p) in paths.enumerated() {
            if index == 0 {
                path.append(p.doubleQuotted)
            } else {
                path.append("->")
                path.append(p.singleQuotted)
            }
        }
        return path
    }
}

func formattedPath<T, V>(_ table: T.Type, _ kp: KeyPath<T, V>) -> _FormattedKeyPath where T: Reflectable {
    if let table = table as? Tableable.Type {
        return formattedPath(table.entity, kp)
    }
    return formattedPath(String(describing: table), kp)
}

func formattedPath<T, V>(_ table: String, _ kp: KeyPath<T, V>) -> _FormattedKeyPath where T: Reflectable {
    return _FormattedKeyPath(table: table, paths: kp.paths)
}

func extractTable<T>(_ table: T.Type) -> String where T: Reflectable {
    if let table = table as? Tableable.Type {
        return table.entity
    }
    return String(describing: table)
}

extension KeyPath where Root: Reflectable {
    public var paths: [String] {
        var values: [String] = []
        do {
            if let v = try Root.reflectProperty(forKey: self)?.path {
                values = v
            }
        } catch {
            print(error)
        }
        return values
    }
}

//MARK: SwifQLable

extension KeyPath: SwifQLPart {}

extension KeyPath: SwifQLKeyPathable where Root: Reflectable {
    public var table: String { return extractTable(Root.self) }
}

extension KeyPath: CustomStringConvertible where Root: Reflectable {}

extension KeyPath: SwifQLable where Root: Reflectable {
    public var parts: [SwifQLPart] { return [SwifQLPartKeyPath(table: table, paths: paths)] }
}

extension KeyPath: Keypathable where Root: Reflectable {
    public var shortPath: String { return _FormattedKeyPath.flattenKeyPath(self.paths) }
    public var lastPath: String { return self.paths.last ?? "%{last_path_not_found}%" }
    
    public func fullPath(table: String) -> String {
        return formattedPath(table, self).pathWithTable
    }
}
