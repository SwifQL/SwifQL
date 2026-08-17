//
//  Lambda.swift
//  SwifQL
//

import Foundation

public struct SQLLambda: SwifQLable {
    public struct Parameter: SwifQLable {
        private let column: SwifQLPartColumn

        fileprivate init(_ name: String) {
            column = SwifQLPartColumn(name)
        }

        public var parts: [SwifQLPart] {
            [column]
        }
    }

    public let parts: [SwifQLPart]

    public init(_ name: String, body: (Parameter) -> SwifQLable) {
        let parameter = Parameter(name)
        self.init(parameters: [parameter], body: body(parameter).parts)
    }

    public init(_ first: String, _ second: String, body: (Parameter, Parameter) -> SwifQLable) {
        let firstParameter = Parameter(first)
        let secondParameter = Parameter(second)
        self.init(
            parameters: [firstParameter, secondParameter],
            body: body(firstParameter, secondParameter).parts
        )
    }

    private init(parameters: [Parameter], body: [SwifQLPart]) {
        var parts: [SwifQLPart] = [
            SwifQLPartOperator.custom("lambda"),
            SwifQLPartOperator.space
        ]

        for (index, parameter) in parameters.enumerated() {
            if index > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: parameter.parts)
        }

        parts.append(o: .space)
        parts.append(SwifQLPartOperator.custom(":"))
        parts.append(o: .space)
        parts.append(contentsOf: body)
        self.parts = parts
    }
}
