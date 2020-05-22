//
//  Functions+PostgresJSONB.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var jsonb_agg: Self = .init("jsonb_agg")
    public static var to_jsonb: Self = .init("to_jsonb")
    public static var jsonb_build_array: Self = .init("jsonb_build_array")
    public static var jsonb_build_object: Self = .init("jsonb_build_object")
    public static var jsonb_object: Self = .init("jsonb_object")
    public static var jsonb_array_length: Self = .init("jsonb_array_length")
    public static var jsonb_each: Self = .init("jsonb_each")
    public static var jsonb_each_text: Self = .init("jsonb_each_text")
    public static var jsonb_extract_path: Self = .init("jsonb_extract_path")
    public static var jsonb_extract_path_text: Self = .init("jsonb_extract_path_text")
    public static var jsonb_object_keys: Self = .init("jsonb_object_keys")
    public static var jsonb_populate_record: Self = .init("jsonb_populate_record")
    public static var jsonb_populate_recordset: Self = .init("jsonb_populate_recordset")
    public static var jsonb_array_elements: Self = .init("jsonb_array_elements")
    public static var jsonb_array_elements_text: Self = .init("jsonb_array_elements_text")
    public static var jsonb_typeof: Self = .init("jsonb_typeof")
    public static var jsonb_to_record: Self = .init("jsonb_to_record")
    public static var jsonb_to_recordset: Self = .init("jsonb_to_recordset")
    public static var jsonb_strip_nulls: Self = .init("jsonb_strip_nulls")
    public static var jsonb_set: Self = .init("jsonb_set")
    public static var jsonb_insert: Self = .init("jsonb_insert")
    public static var jsonb_pretty: Self = .init("jsonb_pretty")
}

extension Fn {
    ///
        public static func jsonb_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_agg, body: aggregateExpression.parts)
        }
        
        /// Returns the value as jsonb.
        /// Arrays and composites are converted (recursively) to arrays and objects;
        /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
        /// otherwise, a scalar value is produced.
        /// For any scalar type other than a number, a Boolean, or a null value,
        /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
        public static func to_jsonb(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.to_jsonb, body: aggregateExpression.parts)
        }
        
        /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_build_array(_ items: SwifQLable...) -> SwifQLable {
            jsonb_build_array(items)
        }
        
        /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_build_array(_ items: [SwifQLable]) -> SwifQLable {
            var parts: [SwifQLPart] = []
            for (i, v) in items.enumerated() {
                if i > 0 {
                    parts.append(o: .comma)
                    parts.append(o: .space)
                }
                parts.append(contentsOf: v.parts)
            }
            return build(.jsonb_build_array, body: parts)
        }
        
        /// Builds a JSON object out of a variadic argument list.
        /// By convention, the argument list consists of alternating keys and values
        /// # Example
        /// ```swift
        /// Fn.jsonb_build_object("foo", 1, "bar", 2)
        /// ```
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_build_object(_ items: SwifQLable...) -> SwifQLable {
            jsonb_build_object(items)
        }
        
        /// Builds a JSON object out of a variadic argument list.
        /// By convention, the argument list consists of alternating keys and values
        /// # Example
        /// ```swift
        /// Fn.jsonb_build_object("foo", 1, "bar", 2)
        /// ```
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_build_object(_ items: [SwifQLable]) -> SwifQLable {
            var parts: [SwifQLPart] = []
            for (i, v) in items.enumerated() {
                if i > 0 {
                    parts.append(o: .comma)
                    parts.append(o: .space)
                }
                parts.append(contentsOf: v.parts)
            }
            return build(.jsonb_build_object, body: parts)
        }
        
        /// Builds a JSON object out of a text array.
        /// The array must have either exactly one dimension with an even number of members,
        /// in which case they are taken as alternating key/value pairs,
        /// or two dimensions such that each inner array has exactly two elements, which are taken as a key/value pair
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_object, body: aggregateExpression.parts)
        }
        
        /// This form of json_object takes keys and values pairwise from two separate arrays.
        /// In all other respects it is identical to the one-argument form.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_object(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
            var parts: [SwifQLPart] = keys.parts
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: values.parts)
            return build(.jsonb_object, body: parts)
        }
        
        /// Returns the number of elements in the outermost JSON array
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_array_length(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_array_length, body: aggregateExpression.parts)
        }
        
        /// Expands the outermost JSON object into a set of key/value pairs
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_each, body: aggregateExpression.parts)
        }
        
        /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_each_text, body: aggregateExpression.parts)
        }
        
        /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_extract_path(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
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
            
            return build(.jsonb_extract_path, body: parts)
        }
        
        public static func jsonb_extract_path(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
            jsonb_extract_path(from_json, path_elems: path_elems)
        }
        
        /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_extract_path_text(_ from_json: SwifQLable, path_elems: [String]) -> SwifQLable {
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
            
            return build(.jsonb_extract_path_text, body: parts)
        }
        
        public static func jsonb_extract_path_text(_ from_json: SwifQLable, path_elems: String...) -> SwifQLable {
            jsonb_extract_path_text(from_json, path_elems: path_elems)
        }
        
        /// Returns set of keys in the outermost JSON object.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_object_keys, body: aggregateExpression.parts)
        }
        
        /// Expands the object in from_json to a row whose columns match the record type defined by base (see note below).
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_populate_record(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
            var parts: [SwifQLPart] = base.parts
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: from_json.parts)
            return build(.jsonb_populate_record, body: parts)
        }
        
        /// Expands the outermost array of objects in from_json to a set of rows whose columns match the record type defined by base (see note below).
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_populate_recordset(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
            var parts: [SwifQLPart] = base.parts
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: from_json.parts)
            return build(.jsonb_populate_recordset, body: parts)
        }
        
        /// Expands a JSON array to a set of JSON values.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_array_elements(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_array_elements, body: aggregateExpression.parts)
        }
        
        /// Expands a JSON array to a set of text values.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_array_elements_text, body: aggregateExpression.parts)
        }
        
        /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_typeof, body: aggregateExpression.parts)
        }
        
        /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_to_record, body: aggregateExpression.parts)
        }
        
        /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_to_recordset, body: aggregateExpression.parts)
        }
        
        /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_strip_nulls, body: aggregateExpression.parts)
        }
        
        /// Returns target with the section designated by path replaced by new_value,
        /// or with new_value added if create_missing is true ( default is true)
        /// and the item designated by path does not exist.
        /// As with the path orientated operators, negative integers
        /// that appear in path count from the end of JSON arrays.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    //    public static func jsonb_set(target: SwifQLable, path text: [String], new_value: SwifQLable, create_missing: Bool? = nil) -> SwifQLable { // TDB
    //        return _buildFn(.jsonb_set, body: aggregateExpression.parts)
    //    }
        
        /// Returns target with new_value inserted.
        /// If target section designated by path is in a JSONB array,
        /// new_value will be inserted before target or after if insert_after is true (default is false).
        /// If target section designated by path is in JSONB object, new_value will be inserted
        /// only if target does not exist. As with the path orientated operators, negative integers
        /// that appear in path count from the end of JSON arrays.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    //    public static func jsonb_insert(target: SwifQLable, path text: [String], new_value: SwifQLable, insert_after: Bool? = nil) -> SwifQLable { // TDB
    //        return _buildFn(.jsonb_insert, body: aggregateExpression.parts)
    //    }
        
        /// Returns from_json as indented JSON text.
        /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
        public static func jsonb_pretty(_ aggregateExpression: SwifQLable) -> SwifQLable {
            build(.jsonb_pretty, body: aggregateExpression.parts)
        }
}
