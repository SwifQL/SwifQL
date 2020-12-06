//
//  Functions+PostgresBool.swift
//  SwifQL
//
//  Created by Ethan Lozano on 06.12.20.
//

import Foundation

extension Fn.Name {
    public static var bool_and: Self = .init("bool_and")
    public static var bool_or: Self = .init("bool_or")
}

extension Fn {

    public static func bool_and(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.bool_and, body: aggregateExpression.parts)
    }

    public static func bool_or(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.bool_or, body: aggregateExpression.parts)
    }
}
