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
        enum KeyMode {
            case `default`, keyPath
        }
        let key: SwifQLable
        let mode: KeyMode
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
            switch v.mode {
            case .default:
                body.append(contentsOf: v.key.parts)
            case .keyPath:
                if let key = v.key as? SwifQLUniversalKeyPathSimple {
                    body.append(o: .custom(key.lastPath.singleQuotted))
                } else {
                    body.append(o: .custom(String(describing: v.key).singleQuotted))
                }
            }
            body.append(o: .comma)
            body.append(o: .space)
            body.append(contentsOf: v.value.parts)
        }
        return Fn.build(.jsonb_build_object, body: body).parts
    }
    
    public init () {}
    
    public func field(key: SwifQLable, value: SwifQLable) -> PostgresJsonObject {
        let field = Field(key: key, mode: .default, value: value)
        fields.append(field)
        return self
    }
    
    public func field(keyPathAsKey: SwifQLable, value: SwifQLable) -> PostgresJsonObject {
        let field = Field(key: keyPathAsKey, mode: .keyPath, value: value)
        fields.append(field)
        return self
    }
}
