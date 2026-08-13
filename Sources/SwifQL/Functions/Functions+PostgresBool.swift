//
//  Functions+PostgresBool.swift
//  SwifQL
//
//  Created by Ethan Lozano on 06.12.20.
//

import Foundation

extension Fn.Name {
    public static let boolAnd: Self = .init("bool_and")
    @available(*, deprecated, renamed: "boolAnd")
    public static var bool_and: Self { .boolAnd }
    public static let boolOr: Self = .init("bool_or")
    @available(*, deprecated, renamed: "boolOr")
    public static var bool_or: Self { .boolOr }
}

extension Fn {

    public static func boolAnd(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.boolAnd, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "boolAnd(_:)")
    public static func bool_and(_ aggregateExpression: SwifQLable) -> SwifQLable {
        boolAnd(aggregateExpression)
    }

    public static func boolOr(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.boolOr, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "boolOr(_:)")
    public static func bool_or(_ aggregateExpression: SwifQLable) -> SwifQLable {
        boolOr(aggregateExpression)
    }
}
