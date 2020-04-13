//
//  Keypathable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 11/11/2018.
//

import Foundation

public protocol Keypathable {
    var schema: String? { get }
    var table: String { get }
    var paths: [String] { get }
    var shortPath: String { get }
    var lastPath: String { get }
}
