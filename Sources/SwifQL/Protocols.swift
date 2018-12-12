//
//  Protocols.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 11/11/2018.
//

import Foundation

/// For getting keypath
public protocol Keypathable {
    var paths: [String] { get }
    var shortPath: String { get }
    var lastPath: String { get }
    func fullPath(table: String) -> String
}

/// Formatting keypath
public struct FormattedKeyPath {
    public var pathWithTable: String = ""
    public var path: String = ""
    public var lastPath: String = ""
    
    public init (table: String, paths: [String]) {
        pathWithTable.append(table.doubleQuotted)
        path = FormattedKeyPath.flattenKeyPath(paths)
        pathWithTable.append(".")
        pathWithTable.append(path)
        lastPath = paths.last ?? ""
    }
    
    public static func flattenKeyPath(_ paths: [String]) -> String {
        var path = ""
        for (index, p) in paths.enumerated() {
            if index == 0 {
                path.append(p.doubleQuotted)
                //formattedPlainPath.append(p)
            } else {
                path.append("->")
                path.append(p.singleQuotted)
                //formattedPlainPath.append("_")
                //formattedPlainPath.append(p)
            }
        }
        return path
    }
}
