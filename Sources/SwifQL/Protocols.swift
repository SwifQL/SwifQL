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
