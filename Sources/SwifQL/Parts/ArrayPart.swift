//
//  ArrayPart.swift
//  SwifQL
//
//  Created by Mihael Isaev on 06.06.2020.
//

import Foundation

public protocol SwifQLPartArray: SwifQLPart {
    var elements: [SwifQLable] { get }
}
