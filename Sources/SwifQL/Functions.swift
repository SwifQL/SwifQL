//
//  Functions.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public struct Fn {}

extension Fn {
    public enum Operator {
        case select, `as`, from, join, `where`, having, groupBy, orderBy, insertInto, values, union
        case and, or, greaterThan, lessThan, greaterThanOrEqual, lessThanOrEqual
        case equal, notEqual, `in`, notIn, like, notLike, ilike, notILike, fulltext, isNull, isNotNull
        case contains, containedBy
        case on, `case`, when, then, `else`, end, null
        case asc, desc
        case limit, offset
        case `for`
        case array, doubleDollar
        case between, notBetween, not
        //just syntax
        case openBracket, closeBracket
        case openSquareBracket, closeSquareBracket
        case comma, space, `_`
        //custom
        case custom(String)
        
        var rawValue: String {
            switch self {
            case .select: return "SELECT"
            case .as: return "as"
            case .from: return "FROM"
            case .join: return "JOIN"
            case .where: return "WHERE"
            case .having: return "HAVING"
            case .groupBy: return "GROUP BY"
            case .orderBy: return "ORDER BY"
            case .insertInto: return "INSERT INTO"
            case .values: return "VALUES"
            case .union: return "UNION"
            case .and: return "AND"
            case .or: return "OR"
            case .greaterThan: return ">"
            case .lessThan: return "<"
            case .greaterThanOrEqual: return ">="
            case .lessThanOrEqual: return "<="
            case .equal: return "="
            case .notEqual: return "!="
            case .in: return "IN"
            case .notIn: return "NOT IN"
            case .like: return "LIKE"
            case .notLike: return "NOT LIKE"
            case .ilike: return "ILIKE"
            case .notILike: return "NOT ILIKE"
            case .fulltext: return "@@"
            case .isNull: return "IS NULL"
            case .isNotNull: return "IS NOT NULL"
            case .contains: return "@>"
            case .containedBy: return "<@"
            case .on: return "ON"
            case .case: return "CASE"
            case .when: return "WHEN"
            case .then: return "THEN"
            case .else: return "ELSE"
            case .end: return "END"
            case .null: return "NULL"
            case .asc: return "ASC"
            case .desc: return "DESC"
            case .limit: return "LIMIT"
            case .offset: return "OFFSET"
            case .for: return "FOR"
            case .array: return "ARRAY"
            case .doubleDollar: return "$$"
            case .between: return "BETWEEN"
            case .notBetween: return "NOT BETWEEN"
            case .not: return "NOT"
            case .openBracket: return "("
            case .closeBracket: return ")"
            case .openSquareBracket: return "["
            case .closeSquareBracket: return "]"
            case .comma: return ","
            case .space: fallthrough
            case ._: return " "
            case .custom(let v): return v
            }
        }
        
        var part: SwifQLPartOperator {
            return SwifQLPartOperator(rawValue)
        }
    }
    
    public enum Function {
        case substr, coalesce, octet_length, cast, ifnull, isnull, nvl, expression
        //string functions
        case bit_length, btrim, char_length, character_length, initcap
        case length, lower, lpad, ltrim, position, `repeat`
        case replace, rpad, rtrim, strpos, substring, translate
        case trim, upper
        //Numeric/Math Functions
        case abs, avg, ceil, ceiling, count, div, exp, floor
        case max, min, mod, power, random, round, setseed
        case sign, sqrt, sum
        //Postgres JSON
        case json_agg, to_json
        case array_to_json, row_to_json
        case json_build_array, json_build_object, json_object
        case json_array_length, json_each
        case json_each_text, json_extract_path, json_extract_path_text
        case json_object_keys, json_populate_record, json_populate_recordset
        case json_array_elements, json_array_elements_text, json_typeof
        case json_to_record, json_to_recordset
        case json_strip_nulls
        //Postgres JSONB
        case jsonb_agg, to_jsonb
        case jsonb_build_array, jsonb_build_object, jsonb_object
        case jsonb_array_length, jsonb_each
        case jsonb_each_text, jsonb_extract_path, jsonb_extract_path_text
        case jsonb_object_keys, jsonb_populate_record, jsonb_populate_recordset
        case jsonb_array_elements, jsonb_array_elements_text, jsonb_typeof
        case jsonb_to_record, jsonb_to_recordset
        case jsonb_strip_nulls
        case jsonb_set, jsonb_insert, jsonb_pretty
        //Array
        case array_agg
        //custom
        case custom(String)
        
        var rawValue: String {
            switch self {
            case .substr: return "substr"
            case .coalesce: return "coalesce"
            case .octet_length: return "octet_length"
            case .cast: return "cast"
            case .ifnull: return "ifnull"
            case .isnull: return "isnull"
            case .nvl: return "nvl"
            case .expression: return "expression"
                
            case .bit_length: return "bit_length"
            case .btrim: return "btrim"
            case .char_length: return "char_length"
            case .character_length: return "character_length"
            case .initcap: return "initcap"
            case .length: return "length"
            case .lower: return "lower"
            case .lpad: return "lpad"
            case .ltrim: return "ltrim"
            case .position: return "position"
            case .repeat: return "repeat"
            case .replace: return "replace"
            case .rpad: return "rpad"
            case .rtrim: return "rtrim"
            case .strpos: return "strpos"
            case .substring: return "substring"
            case .translate: return "translate"
            case .trim: return "trim"
            case .upper: return "upper"
            case .abs: return "abs"
            case .avg: return "avg"
            case .ceil: return "ceil"
            case .ceiling: return "ceiling"
            case .count: return "count"
            case .div: return "div"
            case .exp: return "exp"
            case .floor: return "floor"
            case .max: return "max"
            case .min: return "min"
            case .mod: return "mod"
            case .power: return "power"
            case .random: return "random"
            case .round: return "round"
            case .setseed: return "setseed"
            case .sign: return "sign"
            case .sqrt: return "sqrt"
            case .sum: return "sum"
            
            case .json_agg: return "json_agg"
            case .to_json: return "to_json"
            case .array_to_json: return "array_to_json"
            case .row_to_json: return "row_to_json"
            case .json_build_array: return "json_build_array"
            case .json_build_object: return "json_build_object"
            case .json_object: return "json_object"
            case .json_array_length: return "json_array_length"
            case .json_each: return "json_each"
            case .json_each_text: return "json_each_text"
            case .json_extract_path: return "json_extract_path"
            case .json_extract_path_text: return "json_extract_path_text"
            case .json_object_keys: return "json_object_keys"
            case .json_populate_record: return "json_populate_record"
            case .json_populate_recordset: return "json_populate_recordset"
            case .json_array_elements: return "json_array_elements"
            case .json_array_elements_text: return "json_array_elements_text"
            case .json_typeof: return "json_typeof"
            case .json_to_record: return "json_to_record"
            case .json_to_recordset: return "json_to_recordset"
            case .json_strip_nulls: return "json_strip_nulls"
                
            case .jsonb_agg: return "jsonb_agg"
            case .to_jsonb: return "to_jsonb"
            case .jsonb_build_array: return "jsonb_build_array"
            case .jsonb_build_object: return "jsonb_build_object"
            case .jsonb_object: return "jsonb_object"
            case .jsonb_array_length: return "jsonb_array_length"
            case .jsonb_each: return "jsonb_each"
            case .jsonb_each_text: return "jsonb_each_text"
            case .jsonb_extract_path: return "jsonb_extract_path"
            case .jsonb_extract_path_text: return "jsonb_extract_path_text"
            case .jsonb_object_keys: return "jsonb_object_keys"
            case .jsonb_populate_record: return "jsonb_populate_record"
            case .jsonb_populate_recordset: return "jsonb_populate_recordset"
            case .jsonb_array_elements: return "jsonb_array_elements"
            case .jsonb_array_elements_text: return "jsonb_array_elements_text"
            case .jsonb_typeof: return "jsonb_typeof"
            case .jsonb_to_record: return "jsonb_to_record"
            case .jsonb_to_recordset: return "jsonb_to_recordset"
            case .jsonb_strip_nulls: return "jsonb_strip_nulls"
            case .jsonb_set: return "jsonb_set"
            case .jsonb_insert: return "jsonb_insert"
            case .jsonb_pretty: return "jsonb_pretty"
                
            case .array_agg: return "array_agg"
            case .custom(let v): return v
            }
        }
        
        var part: SwifQLPartOperator {
            return SwifQLPartOperator(rawValue)
        }
    }
    
    public enum CastTypes {
        case uuid
        case uuidArray
        case char
        case charArray
        case varchar
        case varcharArray
        case text
        case textArray
        case integer
        case integerArray
        case numeric
        case numericArray
        case numeric2(Int, Int)
        case bigint
        case bigintArray
        case float(Int)
        case real
        case realArray
        case float8
        case float8Array
        case bool
        case boolArray
        
        var string: String {
            switch self {
            case .uuid: return "uuid"
            case .uuidArray: return "uuid[]"
            case .char: return "char"
            case .charArray: return "char[]"
            case .varchar: return "varchar"
            case .varcharArray: return "varchar[]"
            case .text: return "text"
            case .textArray: return "text[]"
            case .integer: return "integer"
            case .integerArray: return "integer[]"
            case .numeric: return "numeric"
            case .numericArray: return "numeric[]"
            case .numeric2(let p, let s): return "numeric(\(p), \(s))"
            case .bigint: return "bigint"
            case .bigintArray: return "bigint[]"
            case .float(let v): return "float(\(v))"
            case .real: return "real"
            case .realArray: return "real[]"
            case .float8: return "float8"
            case .float8Array: return "float8[]"
            case .bool: return "bool"
            case .boolArray: return "bool[]"
            }
        }
    }
}

//MARK: Function builders

extension Fn {
    static func buildFn(_ fn: Function) -> SwifQLable {
        return buildFn(fn, body: nil)
    }
    static func buildFn(_ fn: Function, body: SwifQLPart...) -> SwifQLable {
        return buildFn(fn, body: body)
    }
    static func buildFn(_ fn: Function, body: [SwifQLPart]? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(f: fn)
        if let body = body {
            parts.append(o: .openBracket)
            parts.append(contentsOf: body)
            parts.append(o: .closeBracket)
        }
        return SwifQLableParts(parts: parts)
    }
}

public func Select(_ queryPart: SwifQLable...) -> SwifQLable {
    return Select(queryPart)
}

public func Select(_ queryParts: [SwifQLable]) -> SwifQLable {
    var parts: [SwifQLPart] = []
    parts.append(o: .select)
    parts.append(o: .space)
    for (i, q) in queryParts.enumerated() {
        if i > 0 {
            parts.append(o: .comma)
            parts.append(o: .space)
        }
        parts.append(contentsOf: q.parts)
    }
    return SwifQLableParts(parts: parts)
}

public var Select: SwifQLable { return Fn.buildFn(.custom("SELECT")) }

//MARK: Functions

extension Fn {
    public static func substr(_ queryPart: SwifQLable, _ to: Int) -> SwifQLable {
        var parts: [SwifQLPart] = queryPart.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: to)
        return buildFn(.substr, body: parts)
    }
    
    public static func ifNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return buildFn(.ifnull, body: parts)
    }
    
    public static func isNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return buildFn(.isnull, body: parts)
    }
    
    public static func nvl(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return buildFn(.nvl, body: parts)
    }
    
    public static func coalesce(_ queryPart: SwifQLable...) -> SwifQLable {
        return coalesce(queryPart)
    }
    
    public static func coalesce(_ queryParts: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        for (i, q) in queryParts.enumerated() {
            if i > 0 {
                parts.append(o: .comma)
            }
            parts.append(contentsOf: q.parts)
        }
        return buildFn(.coalesce, body: parts)
    }
    
    public static func octet_length(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.octet_length, body: string.parts)
    }
}

extension Fn {
    public static func cast(_ queryPart: SwifQLable, _ to: CastTypes) -> SwifQLable {
        return cast(nil, queryPart, to)
    }
    
    public static func cast(_ from: CastTypes?, _ queryPart: SwifQLable, _ to: CastTypes) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let from = from?.string {
            parts.append(o: .custom(from))
            parts.append(o: .space)
        }
        parts.append(contentsOf: queryPart.parts)
        parts.append(o: .space)
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(o: .custom(to.string))
        return buildFn(.cast, body: parts)
    }
}



//Postgres specific functions

extension Fn {
    /// Number of bits in string
    /// e.g. `bit_length('jose')` will return 32
    /// [Learn more →]()
    public static func bit_length(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.bit_length, body: string.parts)
    }
    
    //MARK: - String Functions
    
    /// String and non-string concatenation
    /// e.g. `'Post' || 'greSQL'` will return `PostgreSQL`
    /// so in Swift you can write it like `"Post" || "greSQL"`
    /// or using KeyPath like \User.firstName || " " || \User.lastName
    /// and KeyPath alias like u+\.firstName || " " || u+\.lastName
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/concat2.php)
    public static func concatStrings(lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = lhs.parts
        parts.append(o: .space)
        parts.append(o: .custom("||"))
        parts.append(o: .space)
        parts.append(contentsOf: rhs.parts)
        return SwifQLableParts(parts: parts)
    }

    
    /// Removes all specified characters from both the beginning and the end of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/btrim.php)
    public static func btrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return buildFn(.btrim, body: parts)
    }
    
    /// Returns the length of the specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/char_length.php)
    public static func char_length(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.char_length, body: string.parts)
    }
    
    /// Returns the length of the specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/character_length.php)
    public static func character_length(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.character_length, body: string.parts)
    }
    
    /// Converts the first letter of each word to uppercase and all other letters are converted to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/initcap.php)
    public static func initcap(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.initcap, body: string.parts)
    }
    
    /// Returns the length of the specified string, expressed as the number of characters.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/length.php)
    public static func length(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.length, body: string.parts)
    }
    
    /// Converts all characters in the specified string to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/lower.php)
    public static func lower(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.lower, body: string.parts)
    }
    
    /// Returns a string that is left-padded with a specified string to a certain length
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/lpad.php)
    public static func lpad(_ string: SwifQLable, _ length: Int, _ padString: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: length)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: padString.parts)
        return buildFn(.lpad, body: parts)
    }
    
    /// Removes all specified characters from the left-hand side of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ltrim.php)
    public static func ltrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return buildFn(.ltrim, body: parts)
    }
    
    /// Returns the location of a substring in a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/position.php)
    public static func position(_ substring: SwifQLable, in string: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = substring.parts
        parts.append(o: .space)
        parts.append(o: .in)
        parts.append(o: .space)
        parts.append(contentsOf: string.parts)
        return buildFn(.position, body: parts)
    }
    
    /// Repeats a string a specified number of times
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/repeat.php)
    public static func `repeat`(_ string: SwifQLable, _ number: Int) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: number)
        return buildFn(.repeat, body: parts)
    }
    
    /// Replaces all occurrences of a specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/replace.php)
    public static func replace(_ string: SwifQLable, _ fromSubstring: SwifQLable, _ toSubstring: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: fromSubstring.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: toSubstring.parts)
        return buildFn(.replace, body: parts)
    }
    
    /// Returns a string that is right-padded with a specified string to a certain length
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/rpad.php)
    public static func rpad(_ string: SwifQLable, _ length: Int, _ padString: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: length)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: padString.parts)
        return buildFn(.rpad, body: parts)
    }
    
    /// Removes all specified characters from the right-hand side of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/rtrim.php)
    public static func rtrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return buildFn(.rtrim, body: parts)
    }
    
    /// Returns the location of a substring in a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/strpos.php)
    public static func strpos(_ string: SwifQLable, _ substring: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: substring.parts)
        return buildFn(.strpos, body: parts)
    }
    
    /// Allows you to extract a substring from a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/substring.php)
    public static func substring(_ string: SwifQLable, from startPosition: Int) -> SwifQLable {
        return _substring(string, from: startPosition)
    }
    /// Allows you to extract a substring from a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/substring.php)
    public static func substring(_ string: SwifQLable, for length: Int) -> SwifQLable {
        return _substring(string, for: length)
    }
    /// Allows you to extract a substring from a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/substring.php)
    public static func substring(_ string: SwifQLable, from startPosition: Int, for length: Int) -> SwifQLable {
        return _substring(string, from: startPosition, for: length)
    }
    private static func _substring(_ string: SwifQLable, from startPosition: Int? = nil, for length: Int? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        if let startPosition = startPosition {
            parts.append(o: .space)
            parts.append(o: .from)
            parts.append(o: .space)
            parts.append(safe: startPosition)
        }
        if let length = length {
            parts.append(o: .space)
            parts.append(o: .for)
            parts.append(o: .space)
            parts.append(safe: length)
        }
        return buildFn(.substring, body: parts)
    }
    
    /// Replaces a sequence of characters in a string with another set of characters. However, it replaces a single character at a time.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/translate.php)
    public static func translate(_ string: SwifQLable, _ stringToReplace: SwifQLable, _ replacementString: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: stringToReplace.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: replacementString.parts)
        return buildFn(.translate, body: parts)
    }
    
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(leading trimCharacter: SwifQLable, from string: SwifQLable) -> SwifQLable {
        return _trim("leading", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(trailing trimCharacter: SwifQLable, from string: SwifQLable) -> SwifQLable {
        return _trim("trailing", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(both trimCharacter: SwifQLable, from string: SwifQLable) -> SwifQLable {
        return _trim("both", trimCharacter, from: string)
    }
    private static func _trim(_ type: String, _ trimCharacter: SwifQLable, from string: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(o: .custom(type))
        parts.append(o: .space)
        parts.append(contentsOf: trimCharacter.parts)
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: string.parts)
        return buildFn(.upper, body: string.parts)
    }
    
    /// Converts all characters in the specified string to uppercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/upper.php)
    public static func upper(_ string: SwifQLable) -> SwifQLable {
        return buildFn(.upper, body: string.parts)
    }
    
    //MARK: - Numeric/Math Functions
    
    /// Returns the absolute value of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/abs.php)
    public static func abs(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.abs, body: number.parts)
    }
    
    /// Returns the average value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/avg.php)
    public static func avg(_ quantity: SwifQLable) -> SwifQLable {
        return buildFn(.avg, body: quantity.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceil.php)
    public static func ceil(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.ceil, body: number.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceiling.php)
    public static func ceiling(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.ceiling, body: number.parts)
    }
    
    /// Returns the count of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/count.php)
    public static func count(_ expression: SwifQLable) -> SwifQLable {
        return buildFn(.count, body: expression.parts)
    }
    
    /// Used for integer division where n is divided by m and an integer value is returned
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/div.php)
    public static func div(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return buildFn(.div, body: parts)
    }
    
    /// Used for integer division where n is divided by m and an integer value is returned
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/exp.php)
    public static func exp(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return buildFn(.exp, body: parts)
    }
    
    /// Returns the largest integer value that is equal to or less than a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/floor.php)
    public static func floor(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.floor, body: number.parts)
    }
    
    /// Returns the maximum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/max.php)
    public static func max(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.max, body: aggregateExpression.parts)
    }
    
    /// Returns the minimum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/min.php)
    public static func min(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.min, body: aggregateExpression.parts)
    }
    
    /// Returns the remainder of n divided by m
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/mod.php)
    public static func mod(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return buildFn(.mod, body: parts)
    }
    
    /// Returns m raised to the nth power
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/power.php)
    public static func power(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return buildFn(.power, body: parts)
    }
    
    /// Random function can be used to return a random number or a random number within a range
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/random.php)
    public static func random() -> SwifQLable {
        return buildFn(.random, body: [])
    }
    
    /// Returns a number rounded to a certain number of decimal places
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/round.php)
    public static func round(_ number: SwifQLable, _ decimalPlaces: Int? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = number.parts
        if let decimalPlaces = decimalPlaces {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(safe: decimalPlaces)
        }
        return buildFn(.round, body: parts)
    }
    
    /// Can be used to set a seed for the next time that you call the random function.
    /// If you do not call setseed, PostgreSQL will use its own seed value.
    /// This may or may not be truly random.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/setseed.php)
    public static func setseed(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.setseed, body: number.parts)
    }
    
    /// Returns a value indicating the sign of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sign.php)
    public static func sign(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.sign, body: number.parts)
    }
    
    /// Returns the square root of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sqrt.php)
    public static func sqrt(_ number: SwifQLable) -> SwifQLable {
        return buildFn(.sqrt, body: number.parts)
    }
    
    /// Returns the summed value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sum.php)
    public static func sum(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.sum, body: aggregateExpression.parts)
    }
    
    // MARK: Postgres JSON
    
    ///
    public static func json_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_agg, body: aggregateExpression.parts)
    }
    
    /// Returns the value as json.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func to_json(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.to_json, body: aggregateExpression.parts)
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
        return buildFn(.array_to_json, body: parts)
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
        return buildFn(.row_to_json, body: parts)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_array(_ items: SwifQLable...) -> SwifQLable {
        return json_build_array(items)
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
        return buildFn(.json_build_array, body: parts)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_build_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_build_object, body: aggregateExpression.parts)
    }
    
    /// Builds a JSON object out of a text array.
    /// The array must have either exactly one dimension with an even number of members,
    /// in which case they are taken as alternating key/value pairs,
    /// or two dimensions such that each inner array has exactly two elements, which are taken as a key/value pair
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_object, body: aggregateExpression.parts)
    }
    
    /// This form of json_object takes keys and values pairwise from two separate arrays.
    /// In all other respects it is identical to the one-argument form.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = keys.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: values.parts)
        return buildFn(.json_object, body: parts)
    }
    
    /// Returns the number of elements in the outermost JSON array
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_length(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_array_length, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_each, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_each_text, body: aggregateExpression.parts)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func json_extract_path(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return buildFn(.json_extract_path, body: aggregateExpression.parts)
//    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func json_extract_path_text(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return buildFn(.json_extract_path_text, body: aggregateExpression.parts)
//    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_object_keys, body: aggregateExpression.parts)
    }
    
    /// Expands the object in from_json to a row whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_populate_record(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return buildFn(.json_populate_record, body: parts)
    }
    
    /// Expands the outermost array of objects in from_json to a set of rows whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_populate_recordset(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return buildFn(.json_populate_recordset, body: parts)
    }
    
    /// Expands a JSON array to a set of JSON values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_elements(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_array_elements, body: aggregateExpression.parts)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_array_elements_text, body: aggregateExpression.parts)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_typeof, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_to_record, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_to_recordset, body: aggregateExpression.parts)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.json_strip_nulls, body: aggregateExpression.parts)
    }
    
    // MARK: Postgres JSONB
    
    ///
    public static func jsonb_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_agg, body: aggregateExpression.parts)
    }
    
    /// Returns the value as jsonb.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    public static func to_jsonb(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.to_jsonb, body: aggregateExpression.parts)
    }
    
    /// Builds a possibly-heterogeneously-typed JSON array out of a variadic argument list
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_build_array(_ items: SwifQLable...) -> SwifQLable {
        return jsonb_build_array(items)
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
        return buildFn(.jsonb_build_array, body: parts)
    }
    
    /// Builds a JSON object out of a variadic argument list.
    /// By convention, the argument list consists of alternating keys and values
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_build_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_build_object, body: aggregateExpression.parts)
    }
    
    /// Builds a JSON object out of a text array.
    /// The array must have either exactly one dimension with an even number of members,
    /// in which case they are taken as alternating key/value pairs,
    /// or two dimensions such that each inner array has exactly two elements, which are taken as a key/value pair
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_object(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_object, body: aggregateExpression.parts)
    }
    
    /// This form of json_object takes keys and values pairwise from two separate arrays.
    /// In all other respects it is identical to the one-argument form.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_object(keys: SwifQLable, values: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = keys.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: values.parts)
        return buildFn(.jsonb_object, body: parts)
    }
    
    /// Returns the number of elements in the outermost JSON array
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_array_length(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_array_length, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_each, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_each_text, body: aggregateExpression.parts)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_extract_path(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return buildFn(.jsonb_extract_path, body: aggregateExpression.parts)
//    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_extract_path_text(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return buildFn(.jsonb_extract_path_text, body: aggregateExpression.parts)
//    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_object_keys, body: aggregateExpression.parts)
    }
    
    /// Expands the object in from_json to a row whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_populate_record(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return buildFn(.jsonb_populate_record, body: parts)
    }
    
    /// Expands the outermost array of objects in from_json to a set of rows whose columns match the record type defined by base (see note below).
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_populate_recordset(base: SwifQLable, from_json: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = base.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: from_json.parts)
        return buildFn(.jsonb_populate_recordset, body: parts)
    }
    
    /// Expands a JSON array to a set of JSON values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_array_elements(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_array_elements, body: aggregateExpression.parts)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_array_elements_text, body: aggregateExpression.parts)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_typeof, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_to_record, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_to_recordset, body: aggregateExpression.parts)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_strip_nulls, body: aggregateExpression.parts)
    }
    
    /// Returns target with the section designated by path replaced by new_value,
    /// or with new_value added if create_missing is true ( default is true)
    /// and the item designated by path does not exist.
    /// As with the path orientated operators, negative integers
    /// that appear in path count from the end of JSON arrays.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_set(target: SwifQLable, path text: [String], new_value: SwifQLable, create_missing: Bool? = nil) -> SwifQLable { // TDB
//        return buildFn(.jsonb_set, body: aggregateExpression.parts)
//    }
    
    /// Returns target with new_value inserted.
    /// If target section designated by path is in a JSONB array,
    /// new_value will be inserted before target or after if insert_after is true (default is false).
    /// If target section designated by path is in JSONB object, new_value will be inserted
    /// only if target does not exist. As with the path orientated operators, negative integers
    /// that appear in path count from the end of JSON arrays.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_insert(target: SwifQLable, path text: [String], new_value: SwifQLable, insert_after: Bool? = nil) -> SwifQLable { // TDB
//        return buildFn(.jsonb_insert, body: aggregateExpression.parts)
//    }
    
    /// Returns from_json as indented JSON text.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_pretty(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.jsonb_pretty, body: aggregateExpression.parts)
    }
    
    // MARK: Array
    
    ///
    public static func array_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return buildFn(.array_agg, body: aggregateExpression.parts)
    }
}

//MARK: [SwifQLPart] extension

extension Array where Element == SwifQLPart {
    public mutating func appendSpaceIfNeeded() {
        if count == 0 { return }
        if let last = last as? SwifQLPartOperator, last.value == " " {
            return
        }
        append(o: .space)
    }
    public mutating func append(f: Fn.Function) {
        append(f.part)
    }
    public mutating func append(o: Fn.Operator) {
        append(o.part)
    }
    public mutating func append(safe value: Any) {
        append(SwifQLPartSafeValue(value))
    }
}
