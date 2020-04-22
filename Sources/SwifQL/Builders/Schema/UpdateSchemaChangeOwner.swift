//
//  UpdateSchemaChangeOwner.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12.04.2020.
//

public class UpdateSchemaChangeOwner<Schema: Schemable>: SwifQLable {
    public var parts: [SwifQLPart] {
        var query = SwifQL.alter.schema
        query = query[any: Path.Schema(Schema.schemaName)]
        query = query.owner.to
        query = query[any: Path.Schema(newOwner)]
        return query.parts
    }
    
    var newOwner = ""
    
    public init () {}
    
    public func newOwner(_ name: String) -> Self {
        newOwner = name
        return self
    }
}
