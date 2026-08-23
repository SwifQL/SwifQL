//
//  Functions+PostgresJSON.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var jsonAgg: Self = .init("json_agg")
    @available(*, deprecated, renamed: "jsonAgg")
    public static var json_agg: Self { .jsonAgg }
    public static var toJSON: Self = .init("to_json")
    @available(*, deprecated, renamed: "toJSON")
    public static var to_json: Self { .toJSON }
    public static var arrayToJSON: Self = .init("array_to_json")
    @available(*, deprecated, renamed: "arrayToJSON")
    public static var array_to_json: Self { .arrayToJSON }
    public static var rowToJSON: Self = .init("row_to_json")
    @available(*, deprecated, renamed: "rowToJSON")
    public static var row_to_json: Self { .rowToJSON }
    public static var jsonBuildArray: Self = .init("json_build_array")
    @available(*, deprecated, renamed: "jsonBuildArray")
    public static var json_build_array: Self { .jsonBuildArray }
    public static var jsonBuildObject: Self = .init("json_build_object")
    @available(*, deprecated, renamed: "jsonBuildObject")
    public static var json_build_object: Self { .jsonBuildObject }
    public static var jsonObject: Self = .init("json_object")
    @available(*, deprecated, renamed: "jsonObject")
    public static var json_object: Self { .jsonObject }
    public static var jsonArrayLength: Self = .init("json_array_length")
    @available(*, deprecated, renamed: "jsonArrayLength")
    public static var json_array_length: Self { .jsonArrayLength }
    public static var jsonEach: Self = .init("json_each")
    @available(*, deprecated, renamed: "jsonEach")
    public static var json_each: Self { .jsonEach }
    public static var jsonEachText: Self = .init("json_each_text")
    @available(*, deprecated, renamed: "jsonEachText")
    public static var json_each_text: Self { .jsonEachText }
    public static var jsonExtractPath: Self = .init("json_extract_path")
    @available(*, deprecated, renamed: "jsonExtractPath")
    public static var json_extract_path: Self { .jsonExtractPath }
    public static var jsonExtractPathText: Self = .init("json_extract_path_text")
    @available(*, deprecated, renamed: "jsonExtractPathText")
    public static var json_extract_path_text: Self { .jsonExtractPathText }
    public static var jsonObjectKeys: Self = .init("json_object_keys")
    @available(*, deprecated, renamed: "jsonObjectKeys")
    public static var json_object_keys: Self { .jsonObjectKeys }
    public static var jsonPopulateRecord: Self = .init("json_populate_record")
    @available(*, deprecated, renamed: "jsonPopulateRecord")
    public static var json_populate_record: Self { .jsonPopulateRecord }
    public static var jsonPopulateRecordSet: Self = .init("json_populate_recordset")
    @available(*, deprecated, renamed: "jsonPopulateRecordSet")
    public static var json_populate_recordset: Self { .jsonPopulateRecordSet }
    public static var jsonArrayElements: Self = .init("json_array_elements")
    @available(*, deprecated, renamed: "jsonArrayElements")
    public static var json_array_elements: Self { .jsonArrayElements }
    public static var jsonArrayElementsText: Self = .init("json_array_elements_text")
    @available(*, deprecated, renamed: "jsonArrayElementsText")
    public static var json_array_elements_text: Self { .jsonArrayElementsText }
    public static var jsonTypeOf: Self = .init("json_typeof")
    @available(*, deprecated, renamed: "jsonTypeOf")
    public static var json_typeof: Self { .jsonTypeOf }
    public static var jsonToRecord: Self = .init("json_to_record")
    @available(*, deprecated, renamed: "jsonToRecord")
    public static var json_to_record: Self { .jsonToRecord }
    public static var jsonToRecordSet: Self = .init("json_to_recordset")
    @available(*, deprecated, renamed: "jsonToRecordSet")
    public static var json_to_recordset: Self { .jsonToRecordSet }
    public static var jsonStripNulls: Self = .init("json_strip_nulls")
    @available(*, deprecated, renamed: "jsonStripNulls")
    public static var json_strip_nulls: Self { .jsonStripNulls }
}

extension Fn {
    ///
    public static func jsonAgg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonAgg, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonAgg(_:)")
    public static func json_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonAgg(aggregateExpression)
    }
    
    /// Returns the value as json.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func toJSON(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.toJSON, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "toJSON(_:)")
    public static func to_json(_ aggregateExpression: SwifQLable) -> SwifQLable {
        toJSON(aggregateExpression)
    }
    
    /// Returns the array as a JSON array.
    /// A PostgreSQL multidimensional array becomes a JSON array of arrays.
    /// Line feeds will be added between dimension-1 elements if pretty_bool is true
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func arrayToJSON(_ anyarray: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = anyarray.parts
        if let pretty = pretty {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(safe: pretty)
        }
        return build(.arrayToJSON, body: parts)
    }

    @available(*, deprecated, renamed: "arrayToJSON(_:pretty:)")
    public static func array_to_json(_ anyarray: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        arrayToJSON(anyarray, pretty: pretty)
    }
    
    /// Returns the row as a JSON object.
    /// Line feeds will be added between level-1 elements if pretty_bool is true
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func rowToJSON(_ record: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = record.parts
        if let pretty = pretty {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(safe: pretty)
        }
        return build(.rowToJSON, body: parts)
    }

    @available(*, deprecated, renamed: "rowToJSON(_:pretty:)")
    public static func row_to_json(_ record: SwifQLable, pretty: Bool? = nil) -> SwifQLable {
        rowToJSON(record, pretty: pretty)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonBuildArray(_ items: SwifQLable...) -> SwifQLable {
        jsonBuildArray(items)
    }

    @available(*, deprecated, renamed: "jsonBuildArray(_:)")
    public static func json_build_array(_ items: SwifQLable...) -> SwifQLable {
        jsonBuildArray(items)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonBuildArray(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return build(.jsonBuildArray, body: parts)
    }

    @available(*, deprecated, renamed: "jsonBuildArray(_:)")
    public static func json_build_array(_ items: [SwifQLable]) -> SwifQLable {
        jsonBuildArray(items)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// # Example
    /// ```swift
        /// Fn.jsonBuildObject("foo", 1, "bar", 2)
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonBuildObject(_ items: SwifQLable...) -> SwifQLable {
        jsonBuildObject(items)
    }

    @available(*, deprecated, renamed: "jsonBuildObject(_:)")
    public static func json_build_object(_ items: SwifQLable...) -> SwifQLable {
        jsonBuildObject(items)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// # Example
    /// ```swift
        /// Fn.jsonBuildObject("foo", 1, "bar", 2)
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonBuildObject(_ items: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, v) in items.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        return build(.jsonBuildObject, body: parts)
    }

    @available(*, deprecated, renamed: "jsonBuildObject(_:)")
    public static func json_build_object(_ items: [SwifQLable]) -> SwifQLable {
        jsonBuildObject(items)
    }
    
    /// Builds a JSON object out of a text array.
    /// The array must have either exactly one dimension with an even number of members,
    /// in which case they are taken as alternating key/value pairs,
    /// or two dimensions such that each inner array has exactly two elements, which are taken as a key/value pair
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonObject(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonObject, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonObject(_:)")
    public static func json_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonObject(aggregateExpression)
    }
    
    /// This form of json_object takes keys and values pairwise from two separate arrays.
    /// In all other respects it is identical to the one-argument form.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonObject(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = keys.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: values.parts)
        return build(.jsonObject, body: parts)
    }

    @available(*, deprecated, renamed: "jsonObject(keys:values:)")
    public static func json_object(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
        jsonObject(keys: keys, values: values)
    }
    
    /// Returns the number of elements in the outermost JSON array
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonArrayLength(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonArrayLength, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonArrayLength(_:)")
    public static func json_array_length(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonArrayLength(aggregateExpression)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonEach(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonEach, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonEach(_:)")
    public static func json_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonEach(aggregateExpression)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonEachText(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonEachText, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonEachText(_:)")
    public static func json_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonEachText(aggregateExpression)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonExtractPath(_ fromJson: SwifQLable, pathElems: [String]) -> SwifQLable {
        var parts: [SwifQLPart] = fromJson.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        for (i, v) in pathElems.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        
        return build(.jsonExtractPath, body: parts)
    }
    
    public static func jsonExtractPath(_ fromJson: SwifQLable, pathElems: String...) -> SwifQLable {
        jsonExtractPath(fromJson, pathElems: pathElems)
    }

    @available(*, deprecated, renamed: "jsonExtractPath(_:pathElems:)")
    public static func json_extract_path(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
        jsonExtractPath(from_json, pathElems: path_elems)
    }

    @available(*, deprecated, renamed: "jsonExtractPath(_:pathElems:)")
    public static func json_extract_path(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
        jsonExtractPath(from_json, pathElems: path_elems)
    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonExtractPathText(_ fromJson: SwifQLable, pathElems: [String]) -> SwifQLable {
        var parts: [SwifQLPart] = fromJson.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        for (i, v) in pathElems.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
            parts.append(contentsOf: v.parts)
        }
        
        return build(.jsonExtractPathText, body: parts)
    }
    
    public static func jsonExtractPathText(_ fromJson: SwifQLable, pathElems: String...) -> SwifQLable {
        jsonExtractPathText(fromJson, pathElems: pathElems)
    }

    @available(*, deprecated, renamed: "jsonExtractPathText(_:pathElems:)")
    public static func json_extract_path_text(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
        jsonExtractPathText(from_json, pathElems: path_elems)
    }

    @available(*, deprecated, renamed: "jsonExtractPathText(_:pathElems:)")
    public static func json_extract_path_text(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
        jsonExtractPathText(from_json, pathElems: path_elems)
    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonObjectKeys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonObjectKeys, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonObjectKeys(_:)")
    public static func json_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonObjectKeys(aggregateExpression)
    }
    
    /// Expands the object in from_json to a row whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonPopulateRecord(base: SwifQLable, fromJSON: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: fromJSON.parts)
        return build(.jsonPopulateRecord, body: parts)
    }

    @available(*, deprecated, renamed: "jsonPopulateRecord(base:fromJSON:)")
    public static func json_populate_record(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        jsonPopulateRecord(base: base, fromJSON: from_json)
    }
    
    /// Expands the outermost array of objects in from_json to a set of rows whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonPopulateRecordSet(base: SwifQLable, fromJSON: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: fromJSON.parts)
        return build(.jsonPopulateRecordSet, body: parts)
    }

    @available(*, deprecated, renamed: "jsonPopulateRecordSet(base:fromJSON:)")
    public static func json_populate_recordset(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        jsonPopulateRecordSet(base: base, fromJSON: from_json)
    }
    
    /// Expands a JSON array to a set of JSON values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonArrayElements(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonArrayElements, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonArrayElements(_:)")
    public static func json_array_elements(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonArrayElements(aggregateExpression)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonArrayElementsText(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonArrayElementsText, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonArrayElementsText(_:)")
    public static func json_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonArrayElementsText(aggregateExpression)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonTypeOf(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonTypeOf, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonTypeOf(_:)")
    public static func json_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonTypeOf(aggregateExpression)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonToRecord(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonToRecord, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonToRecord(_:)")
    public static func json_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonToRecord(aggregateExpression)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonToRecordSet(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonToRecordSet, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonToRecordSet(_:)")
    public static func json_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonToRecordSet(aggregateExpression)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonStripNulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.jsonStripNulls, body: aggregateExpression.parts)
    }

    @available(*, deprecated, renamed: "jsonStripNulls(_:)")
    public static func json_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        jsonStripNulls(aggregateExpression)
    }
}
