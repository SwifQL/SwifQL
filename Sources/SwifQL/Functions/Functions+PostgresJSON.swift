//
//  Functions+PostgresJSON.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var json_agg: Self = .init("json_agg")
    public static var to_json: Self = .init("to_json")
    public static var array_to_json: Self = .init("array_to_json")
    public static var row_to_json: Self = .init("row_to_json")
    public static var json_build_array: Self = .init("json_build_array")
    public static var json_build_object: Self = .init("json_build_object")
    public static var json_object: Self = .init("json_object")
    public static var json_array_length: Self = .init("json_array_length")
    public static var json_each: Self = .init("json_each")
    public static var json_each_text: Self = .init("json_each_text")
    public static var json_extract_path: Self = .init("json_extract_path")
    public static var json_extract_path_text: Self = .init("json_extract_path_text")
    public static var json_object_keys: Self = .init("json_object_keys")
    public static var json_populate_record: Self = .init("json_populate_record")
    public static var json_populate_recordset: Self = .init("json_populate_recordset")
    public static var json_array_elements: Self = .init("json_array_elements")
    public static var json_array_elements_text: Self = .init("json_array_elements_text")
    public static var json_typeof: Self = .init("json_typeof")
    public static var json_to_record: Self = .init("json_to_record")
    public static var json_to_recordset: Self = .init("json_to_recordset")
    public static var json_strip_nulls: Self = .init("json_strip_nulls")
}

extension Fn {
    ///
    public static func json_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_agg, body: aggregateExpression.parts)
    }
    
    /// Returns the value as json.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func to_json(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.to_json, body: aggregateExpression.parts)
    }
    
    /// Returns the array as a JSON array.
    /// A PostgreSQL multidimensional array becomes a JSON array of arrays.
    /// Line feeds will be added between dimension-1 elements if pretty_bool is true
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func array_to_json(_ anyarray: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = anyarray.parts
        if let pretty = pretty {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(safe: pretty)
        }
        return build(.array_to_json, body: parts)
    }
    
    /// Returns the row as a JSON object.
    /// Line feeds will be added between level-1 elements if pretty_bool is true
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func row_to_json(_ record: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = record.parts
        if let pretty = pretty {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(safe: pretty)
        }
        return build(.row_to_json, body: parts)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_array(_ items: SwifQLable...) -> SwifQLable {
        json_build_array(items)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_array(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return build(.json_build_array, body: parts)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// # Example
    /// ```swift
    /// Fn.json_build_object("foo", 1, "bar", 2)
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_object(_ items: SwifQLable...) -> SwifQLable {
        json_build_object(items)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// # Example
    /// ```swift
    /// Fn.json_build_object("foo", 1, "bar", 2)
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_object(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return build(.json_build_object, body: parts)
    }
    
    /// Builds a JSON object out of a text array.
    /// The array must have either exactly one dimension with an even number of members,
    /// in which case they are taken as alternating key/value pairs,
    /// or two dimensions such that each inner array has exactly two elements, which are taken as a key/value pair
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_object, body: aggregateExpression.parts)
    }
    
    /// This form of json_object takes keys and values pairwise from two separate arrays.
    /// In all other respects it is identical to the one-argument form.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = keys.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: values.parts)
        return build(.json_object, body: parts)
    }
    
    /// Returns the number of elements in the outermost JSON array
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_length(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_array_length, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_each, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_each_text, body: aggregateExpression.parts)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_extract_path(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
        var parts: [SwifQLPart] = from_json.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        for (i, v) in path_elems.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        
        return build(.json_extract_path, body: parts)
    }
    
    public static func json_extract_path(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
        json_extract_path(from_json, path_elems: path_elems)
    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_extract_path_text(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
        var parts: [SwifQLPart] = from_json.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        for (i, v) in path_elems.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        
        return build(.json_extract_path_text, body: parts)
    }
    
    public static func json_extract_path_text(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
        json_extract_path_text(from_json, path_elems: path_elems)
    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_object_keys, body: aggregateExpression.parts)
    }
    
    /// Expands the object in from_json to a row whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_populate_record(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return build(.json_populate_record, body: parts)
    }
    
    /// Expands the outermost array of objects in from_json to a set of rows whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_populate_recordset(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return build(.json_populate_recordset, body: parts)
    }
    
    /// Expands a JSON array to a set of JSON values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_elements(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_array_elements, body: aggregateExpression.parts)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_array_elements_text, body: aggregateExpression.parts)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_typeof, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_to_record, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_to_recordset, body: aggregateExpression.parts)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.json_strip_nulls, body: aggregateExpression.parts)
    }
}
