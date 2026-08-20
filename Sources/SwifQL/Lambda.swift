//
//  Lambda.swift
//  SwifQL
//

import Foundation

/// The structured SQL lambda value passed to the dialect rendering boundary.
/// Parameter identities and body parts remain separate from concrete lambda
/// punctuation so downstream dialects can choose their own grammar.
public struct SwifQLPartLambda: SwifQLPart {
    public let parameters: [SQLLambda.Parameter]
    public let body: [SwifQLPart]

    public init(
        parameters: [SQLLambda.Parameter],
        body: [SwifQLPart]
    ) {
        self.parameters = parameters
        self.body = body
    }
}

public struct SQLLambda: SwifQLable {
    public struct Parameter: SwifQLable {
        private let column: SwifQLPartColumn

        public let name: String

        fileprivate init(_ name: String) {
            self.name = name
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
        self.parts = [SwifQLPartLambda(parameters: parameters, body: body)]
    }
}
