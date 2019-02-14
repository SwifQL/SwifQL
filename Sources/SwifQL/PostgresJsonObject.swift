//
//  PostgresJsonObject.swift
//  SwifQL
//
//  Created by Mihael Isaev on 14/02/2019.
//

import Foundation

public typealias PgJsonObject = PostgresJsonObject

public class PostgresJsonObject: SwifQLable {
    private struct Field {
        let key: String
        let value: SwifQLable
    }
    
    private var fields: [Field] = []
    
    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        parts.appendSpaceIfNeeded()
        var body: [SwifQLPart] = []
        for (i, v) in fields.enumerated() {
            if i > 0 {
                body.append(o: .comma)
                body.append(o: .space)
            }
            body.append(o: .custom(v.key.singleQuotted))
            body.append(o: .comma)
            body.append(o: .space)
            body.append(contentsOf: v.value.parts)
        }
        return Fn.buildFn(.jsonb_build_object, body: body).parts
    }
    
    public init () {}
    
    public func field(key: SwifQLable, value: SwifQLable) -> PostgresJsonObject {
        let k: String
        if let key = key as? FQUniversalKeyPathSimple {
            k = key.lastPath
        } else {
            k = String(describing: key)
        }
        let field = Field(key: k, value: value)
        fields.append(field)
        return self
    }
}
