//
//  Functions.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public struct Fn {}

extension Fn {
    public struct Name {
        let name: String
        
        public init (_ name: String) {
            self.name = name
        }
        
        public static var substr: Self = .init("substr")
        public static var coalesce: Self = .init("coalesce")
        public static var octet_length: Self = .init("octet_length")
        public static var cast: Self = .init("cast")
        public static var ifnull: Self = .init("ifnull")
        public static var isnull: Self = .init("isnull")
        public static var nvl: Self = .init("nvl")
        public static var expression: Self = .init("expression")
        
        // MARK: String
        
        public static var bit_length: Self = .init("bit_length")
        public static var btrim: Self = .init("btrim")
        public static var char_length: Self = .init("char_length")
        public static var character_length: Self = .init("character_length")
        public static var initcap: Self = .init("initcap")
        public static var concat: Self = .init("concat")
        public static var concat_ws: Self = .init("concat_ws")
        public static var array_length: Self = .init("array_length")
        public static var length: Self = .init("length")
        public static var lower: Self = .init("lower")
        public static var lpad: Self = .init("lpad")
        public static var ltrim: Self = .init("ltrim")
        public static var position: Self = .init("position")
        public static var `repeat`: Self = .init("repeat")
        public static var replace: Self = .init("replace")
        public static var rpad: Self = .init("rpad")
        public static var rtrim: Self = .init("rtrim")
        public static var strpos: Self = .init("strpos")
        public static var substring: Self = .init("substring")
        public static var translate: Self = .init("translate")
        public static var trim: Self = .init("trim")
        public static var upper: Self = .init("upper")
        
        // MARK: Numeric/Math
        
        public static var abs: Self = .init("abs")
        public static var avg: Self = .init("avg")
        public static var ceil: Self = .init("ceil")
        public static var ceiling: Self = .init("ceiling")
        public static var count: Self = .init("count")
        public static var div: Self = .init("div")
        public static var exp: Self = .init("exp")
        public static var floor: Self = .init("floor")
        public static var max: Self = .init("max")
        public static var min: Self = .init("min")
        public static var mod: Self = .init("mod")
        public static var power: Self = .init("power")
        public static var random: Self = .init("random")
        public static var round: Self = .init("round")
        public static var setseed: Self = .init("setseed")
        public static var sign: Self = .init("sign")
        public static var sqrt: Self = .init("sqrt")
        public static var sum: Self = .init("sum")
        
        // MARK: Postgres JSON
        
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
        
        // MARK: Postgres JSONB
        
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
        
        // MARK: Postgres time
        
        public static var age: Self = .init("age")
        public static var clock_timestamp: Self = .init("clock_timestamp")
        public static var current_date: Self = .init("current_date")
        public static var current_time: Self = .init("current_time")
        public static var current_timestamp: Self = .init("current_timestamp")
        public static var date_part: Self = .init("date_part")
        public static var date_trunc: Self = .init("date_trunc")
        public static var extract: Self = .init("extract")
        public static var isfinite: Self = .init("isfinite")
        public static var justify_days: Self = .init("justify_days")
        public static var justify_hours: Self = .init("justify_hours")
        public static var justify_interval: Self = .init("justify_interval")
        public static var localtime: Self = .init("localtime")
        public static var localtimestamp: Self = .init("localtimestamp")
        public static var make_date: Self = .init("make_date")
        public static var make_interval: Self = .init("make_interval")
        public static var make_time: Self = .init("make_time")
        public static var make_timestamp: Self = .init("make_timestamp")
        public static var make_timestamptz: Self = .init("make_timestamptz")
        public static var now: Self = .init("now")
        public static var statement_timestamp: Self = .init("statement_timestamp")
        public static var timeofday: Self = .init("timeofday")
        public static var transaction_timestamp: Self = .init("transaction_timestamp")
        public static var to_timestamp: Self = .init("to_timestamp")

        // MARK: Array
        
        public static var array_agg: Self = .init("array_agg")
        
        // MARK: Text Search
        
        public static var to_tsvector: Self = .init("to_tsvector")
        public static var to_tsquery: Self = .init("to_tsquery")
        public static var plainto_tsquery: Self = .init("plainto_tsquery")
        public static var ts_rank_cd: Self = .init("ts_rank_cd")
        
        // MARK: MySQL
        
        public static var from_unixtime: Self = .init("FROM_UNIXTIME")
        
        // MARK: Custom
        
        public static func custom(_ name: String) -> Self {
            return .init(name)
        }
        
        var part: SwifQLPartOperator {
            return SwifQLPartOperator(name)
        }
    }
}

//MARK: Function builders

extension Fn {
    public static func build(_ fn: Name) -> SwifQLable {
        return build(fn, body: nil)
    }
    public static func build(_ fn: Name, body: SwifQLPart...) -> SwifQLable {
        return build(fn, body: body)
    }
    public static func build(_ fn: Name, body: [SwifQLPart]? = nil) -> SwifQLable {
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

public var Select: SwifQLable { return Fn.build(.custom("SELECT")) }

//MARK: Functions

extension Fn {
    public static func substr(_ queryPart: SwifQLable, _ to: Int) -> SwifQLable {
        var parts: [SwifQLPart] = queryPart.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: to)
        return build(.substr, body: parts)
    }
    
    public static func ifNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.ifnull, body: parts)
    }
    
    public static func isNull(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.isnull, body: parts)
    }
    
    public static func nvl(_ value1: SwifQLable, _ value2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = value1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value2.parts)
        return build(.nvl, body: parts)
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
        return build(.coalesce, body: parts)
    }
    
    public static func octet_length(_ string: SwifQLable) -> SwifQLable {
        return build(.octet_length, body: string.parts)
    }
}

extension Fn {
    public static func cast(_ queryPart: SwifQLable, _ to: CastType) -> SwifQLable {
        return cast(nil, queryPart, to)
    }
    
    public static func cast(_ from: CastType?, _ queryPart: SwifQLable, _ to: CastType) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let from = from?.name {
            parts.append(o: .custom(from))
            parts.append(o: .space)
        }
        parts.append(contentsOf: queryPart.parts)
        parts.append(o: .space)
        parts.append(o: .as)
        parts.append(o: .space)
        parts.append(o: .custom(to.name))
        return build(.cast, body: parts)
    }
}



//Postgres specific functions

extension Fn {
    /// Number of bits in string
    /// e.g. `bit_length('jose')` will return 32
    /// [Learn more →]()
    public static func bit_length(_ string: SwifQLable) -> SwifQLable {
        return build(.bit_length, body: string.parts)
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
    
    /// Returns the length of the requested array dimension
    public static func array_length(_ anyArray: SwifQLable, _ dimension: Int = 1) -> SwifQLable {
        var parts: [SwifQLPart] = anyArray.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: dimension)
        return build(.array_length, body: parts)
    }
    
    /// Removes all specified characters from both the beginning and the end of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/btrim.php)
    public static func btrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return build(.btrim, body: parts)
    }
    
    /// Returns the length of the specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/char_length.php)
    public static func char_length(_ string: SwifQLable) -> SwifQLable {
        return build(.char_length, body: string.parts)
    }
    
    /// Returns the length of the specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/character_length.php)
    public static func character_length(_ string: SwifQLable) -> SwifQLable {
        return build(.character_length, body: string.parts)
    }
    
    /// Converts the first letter of each word to uppercase and all other letters are converted to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/initcap.php)
    public static func initcap(_ string: SwifQLable) -> SwifQLable {
        return build(.initcap, body: string.parts)
    }
    
    /// Returns the length of the specified string, expressed as the number of characters.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/length.php)
    public static func length(_ string: SwifQLable) -> SwifQLable {
        return build(.length, body: string.parts)
    }
    
    /// Converts all characters in the specified string to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/lower.php)
    public static func lower(_ string: SwifQLable) -> SwifQLable {
        return build(.lower, body: string.parts)
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
        return build(.lpad, body: parts)
    }
    
    /// Removes all specified characters from the left-hand side of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ltrim.php)
    public static func ltrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return build(.ltrim, body: parts)
    }
    
    /// Returns the location of a substring in a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/position.php)
    public static func position(_ substring: SwifQLable, in string: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = substring.parts
        parts.append(o: .space)
        parts.append(o: .in)
        parts.append(o: .space)
        parts.append(contentsOf: string.parts)
        return build(.position, body: parts)
    }
    
    /// Repeats a string a specified number of times
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/repeat.php)
    public static func `repeat`(_ string: SwifQLable, _ number: Int) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: number)
        return build(.repeat, body: parts)
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
        return build(.replace, body: parts)
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
        return build(.rpad, body: parts)
    }
    
    /// Removes all specified characters from the right-hand side of a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/rtrim.php)
    public static func rtrim(_ string: SwifQLable, _ characters: String) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: characters)
        return build(.rtrim, body: parts)
    }
    
    /// Returns the location of a substring in a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/strpos.php)
    public static func strpos(_ string: SwifQLable, _ substring: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = string.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: substring.parts)
        return build(.strpos, body: parts)
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
        return build(.substring, body: parts)
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
        return build(.translate, body: parts)
    }
    
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(_ string: SwifQLable) -> SwifQLable {
        return build(.trim, body: string.parts)
    }
    
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(leading trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        return _trim("leading", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(trailing trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        return _trim("trailing", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(both trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        return _trim("both", trimCharacter, from: string)
    }
    
    /// Private `trim` builder method
    private static func _trim(_ type: String, _ trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(o: .custom(type))
        if let trimCharacter = trimCharacter {
            parts.append(o: .space)
            parts.append(contentsOf: trimCharacter.parts)
        }
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: string.parts)
        return build(.trim, body: string.parts)
    }
    
    /// Converts all characters in the specified string to uppercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/upper.php)
    public static func upper(_ string: SwifQLable) -> SwifQLable {
        return build(.upper, body: string.parts)
    }
    
    //MARK: - Numeric/Math Functions
    
    /// Returns the absolute value of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/abs.php)
    public static func abs(_ number: SwifQLable) -> SwifQLable {
        return build(.abs, body: number.parts)
    }
    
    /// Returns the average value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/avg.php)
    public static func avg(_ quantity: SwifQLable) -> SwifQLable {
        return build(.avg, body: quantity.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceil.php)
    public static func ceil(_ number: SwifQLable) -> SwifQLable {
        return build(.ceil, body: number.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceiling.php)
    public static func ceiling(_ number: SwifQLable) -> SwifQLable {
        return build(.ceiling, body: number.parts)
    }
    
    /// Returns the count of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/count.php)
    public static func count(_ expression: SwifQLable) -> SwifQLable {
        return build(.count, body: expression.parts)
    }
    
    /// Used for integer division where n is divided by m and an integer value is returned
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/div.php)
    public static func div(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return build(.div, body: parts)
    }
    
    /// Used for integer division where n is divided by m and an integer value is returned
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/exp.php)
    public static func exp(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return build(.exp, body: parts)
    }
    
    /// Returns the largest integer value that is equal to or less than a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/floor.php)
    public static func floor(_ number: SwifQLable) -> SwifQLable {
        return build(.floor, body: number.parts)
    }
    
    /// Returns the maximum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/max.php)
    public static func max(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.max, body: aggregateExpression.parts)
    }
    
    /// Returns the minimum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/min.php)
    public static func min(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.min, body: aggregateExpression.parts)
    }
    
    /// Returns the remainder of n divided by m
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/mod.php)
    public static func mod(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return build(.mod, body: parts)
    }
    
    /// Returns m raised to the nth power
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/power.php)
    public static func power(_ n: SwifQLable, _ m: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = n.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: m.parts)
        return build(.power, body: parts)
    }
    
    /// Random function can be used to return a random number or a random number within a range
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/random.php)
    public static func random() -> SwifQLable {
        return build(.random, body: [])
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
        return build(.round, body: parts)
    }
    
    /// Can be used to set a seed for the next time that you call the random function.
    /// If you do not call setseed, PostgreSQL will use its own seed value.
    /// This may or may not be truly random.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/setseed.php)
    public static func setseed(_ number: SwifQLable) -> SwifQLable {
        return build(.setseed, body: number.parts)
    }
    
    /// Returns a value indicating the sign of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sign.php)
    public static func sign(_ number: SwifQLable) -> SwifQLable {
        return build(.sign, body: number.parts)
    }
    
    /// Returns the square root of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sqrt.php)
    public static func sqrt(_ number: SwifQLable) -> SwifQLable {
        return build(.sqrt, body: number.parts)
    }
    
    /// Returns the summed value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sum.php)
    public static func sum(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.sum, body: aggregateExpression.parts)
    }
    
    // MARK: Postgres JSON
    
    ///
    public static func json_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_agg, body: aggregateExpression.parts)
    }
    
    /// Returns the value as json.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func to_json(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.to_json, body: aggregateExpression.parts)
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
        return json_build_object(items)
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
        return build(.json_object, body: aggregateExpression.parts)
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
        return build(.json_array_length, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_each, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_each_text, body: aggregateExpression.parts)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func json_extract_path(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return _buildFn(.json_extract_path, body: aggregateExpression.parts)
//    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func json_extract_path_text(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return _buildFn(.json_extract_path_text, body: aggregateExpression.parts)
//    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_object_keys, body: aggregateExpression.parts)
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
        return build(.json_array_elements, body: aggregateExpression.parts)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_array_elements_text, body: aggregateExpression.parts)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_typeof, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_to_record, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_to_recordset, body: aggregateExpression.parts)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func json_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.json_strip_nulls, body: aggregateExpression.parts)
    }
    
    // MARK: Postgres JSONB
    
    ///
    public static func jsonb_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_agg, body: aggregateExpression.parts)
    }
    
    /// Returns the value as jsonb.
    /// Arrays and composites are converted (recursively) to arrays and objects;
    /// otherwise, if there is a cast from the type to json, the cast function will be used to perform the conversion;
    /// otherwise, a scalar value is produced.
    /// For any scalar type other than a number, a Boolean, or a null value,
    /// the text representation will be used, in such a fashion that it is a valid json or jsonb value.
    public static func to_jsonb(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.to_jsonb, body: aggregateExpression.parts)
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
        return jsonb_build_object(items)
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
        return build(.jsonb_object, body: aggregateExpression.parts)
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
        return build(.jsonb_array_length, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_each(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_each, body: aggregateExpression.parts)
    }
    
    /// Expands the outermost JSON object into a set of key/value pairs. The returned values will be of type text
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_each_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_each_text, body: aggregateExpression.parts)
    }
    
    /// Returns JSON value pointed to by path_elems (equivalent to #> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_extract_path(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return _buildFn(.jsonb_extract_path, body: aggregateExpression.parts)
//    }
    
    /// Returns JSON value pointed to by path_elems as text (equivalent to #>> operator)
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
//    public static func jsonb_extract_path_text(from_json : SwifQLable, path_elems: [String]) -> SwifQLable { // TBD
//        return _buildFn(.jsonb_extract_path_text, body: aggregateExpression.parts)
//    }
    
    /// Returns set of keys in the outermost JSON object.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_object_keys(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_object_keys, body: aggregateExpression.parts)
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
        return build(.jsonb_array_elements, body: aggregateExpression.parts)
    }
    
    /// Expands a JSON array to a set of text values.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_array_elements_text(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_array_elements_text, body: aggregateExpression.parts)
    }
    
    /// Returns the type of the outermost JSON value as a text string. Possible types are object, array, string, number, boolean, and null.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_typeof(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_typeof, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary record from a JSON object (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_to_record(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_to_record, body: aggregateExpression.parts)
    }
    
    /// Builds an arbitrary set of records from a JSON array of objects (see note below). As with all functions returning record, the caller must explicitly define the structure of the record with an AS clause.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_to_recordset(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_to_recordset, body: aggregateExpression.parts)
    }
    
    /// Returns from_json with all object fields that have null values omitted. Other null values are untouched.
    /// [Learn more →](https://www.postgresql.org/docs/current/functions-json.html)
    public static func jsonb_strip_nulls(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.jsonb_strip_nulls, body: aggregateExpression.parts)
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
        return build(.jsonb_pretty, body: aggregateExpression.parts)
    }
    
    // MARK: Array
    
    ///
    public static func array_agg(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return build(.array_agg, body: aggregateExpression.parts)
    }
    
    // MARK: Postgres Time Functions
    
    /// Subtract arguments, producing a “symbolic” result that uses years and months, rather than just days
    /// # Example
    /// ```swift
    /// Fn.age("2001-04-10" => .timestamp, "1957-06-13" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 43 years 9 mons 27 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func age(_ timestamp1: SwifQLable, _ timestamp2: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = timestamp1.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: timestamp2.parts)
        return build(.age, body: parts)
    }
    
    /// Subtract from current_date (at midnight)
    /// # Example
    /// ```swift
    /// Fn.age("2001-04-10" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 43 years 8 mons 3 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func age(_ timestamp1: SwifQLable) -> SwifQLable {
        return build(.age, body: timestamp1.parts)
    }
    
    /// Current date and time (changes during statement execution)
    /// # Example
    /// ```swift
    /// Fn.clock_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func clock_timestamp() -> SwifQLable {
        return build(.clock_timestamp, body: [])
    }
    
    /// Current date
    /// # Example
    /// ```swift
    /// Fn.current_date
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static var current_date: SwifQLable {
        return SwifQLableParts(parts: Name.current_date.part)
    }
    
    /// Current time of day
    /// # Example
    /// ```swift
    /// Fn.current_time
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func current_time(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return SwifQLableParts(parts: Name.current_time.part)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.current_timestamp
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-CURRENT)
    public static func current_timestamp(_ aggregateExpression: SwifQLable) -> SwifQLable {
        return SwifQLableParts(parts: Name.current_timestamp.part)
    }
    
    /// Get subfield (equivalent to extract)
    /// # Example with timestamp
    /// ```swift
    /// Fn.date_part("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.date_part("month", "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func date_part(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.date_part, body: parts)
    }
    
    /// Truncate to specified precision
    /// # Example with timestamp
    /// ```swift
    /// Fn.date_trunc("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 2001-02-16 20:00:00
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.date_trunc("hour", "2 days 3 hours 40 minutes" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 2 days 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC)
    public static func date_trunc(_ text: SwifQLable, _ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = text.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.date_trunc, body: parts)
    }
    
    /// Get subfield
    /// # Example with timestamp
    /// ```swift
    /// Fn.extract("hour", "2001-02-16 20:38:40" => .timestamp)
    /// ```
    /// # Result
    /// ```
    /// 20
    /// ```
    /// # Example with interval
    /// ```swift
    /// Fn.extract("month", "2 years 3 months" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 3
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    public static func extract(_ field: SwifQLable, from value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = field.parts
        parts.append(o: .space)
        parts.append(o: .from)
        parts.append(o: .space)
        parts.append(contentsOf: value.parts)
        return build(.extract, body: parts)
    }
    
    /// Test for finite date (not +/-infinity)
    /// # Example
    /// ```swift
    /// Fn.isfinite("4 hours" => .interval)
    /// ```
    /// # Result
    /// ```
    /// true
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func isfinite(_ interval: SwifQLable) -> SwifQLable {
        return build(.isfinite, body: interval.parts)
    }
    
    /// Adjust interval so 30-day time periods are represented as months
    /// # Example
    /// ```swift
    /// Fn.justify_days("35 days" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 mon 5 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_days(_ interval: SwifQLable) -> SwifQLable {
        return build(.justify_days, body: interval.parts)
    }
    
    /// Adjust interval so 24-hour time periods are represented as days
    /// # Example
    /// ```swift
    /// Fn.justify_hours("27 hours" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 1 day 03:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_hours(_ interval: SwifQLable) -> SwifQLable {
        return build(.justify_hours, body: interval.parts)
    }
    
    /// Adjust interval using justify_days and justify_hours, with additional sign adjustments
    /// # Example
    /// ```swift
    /// Fn.justify_interval("1 mon -1 hour" => .interval)
    /// ```
    /// # Result
    /// ```
    /// 29 days 23:00:00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func justify_interval(_ interval: SwifQLable) -> SwifQLable {
        return build(.justify_interval, body: interval.parts)
    }
    
    /// Current time of day
    /// # Example
    /// ```swift
    /// Fn.localtime
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static var localtime: SwifQLable {
        return SwifQLableParts(parts: Name.localtime.part)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.localtimestamp
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static var localtimestamp: SwifQLable {
        return SwifQLableParts(parts: Name.localtimestamp.part)
    }
    
    /// Create date from year, month and day fields
    /// # Example
    /// ```swift
    /// Fn.make_date(2013, 7, 15)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_date(_ year: SwifQLable, _ month: SwifQLable, _ day: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        return build(.make_date, body: parts)
    }
    
    /// Create interval from years, months, weeks, days, hours, minutes and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_interval(days: 10)
    /// ```
    /// # Result
    /// ```
    /// 10 days
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_interval(years: SwifQLable? = nil,
                                                   months: SwifQLable? = nil,
                                                   weeks: SwifQLable? = nil,
                                                   days: SwifQLable? = nil,
                                                   hours: SwifQLable? = nil,
                                                   mins: SwifQLable? = nil,
                                                   secs: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = []
        if let years = years {
            parts.append(o: .custom("years => "))
            parts.append(contentsOf: years.parts)
        }
        if let months = months {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("months => "))
            parts.append(contentsOf: months.parts)
        }
        if let weeks = weeks {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("weeks => "))
            parts.append(contentsOf: weeks.parts)
        }
        if let days = days {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("days => "))
            parts.append(contentsOf: days.parts)
        }
        if let hours = hours {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("hours => "))
            parts.append(contentsOf: hours.parts)
        }
        if let mins = mins {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("mins => "))
            parts.append(contentsOf: mins.parts)
        }
        if let secs = secs {
            if parts.count > 0 { parts.append(o: .comma, .space) }
            parts.append(o: .custom("secs => "))
            parts.append(contentsOf: secs.parts)
        }
        return build(.make_interval, body: parts)
    }
    
    /// Create time from hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_time(8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_time(_ hour: SwifQLable, _ min: SwifQLable, _ sec: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = hour.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        return build(.make_time, body: parts)
    }
    
    /// Create timestamp from year, month, day, hour, minute and seconds fields
    /// # Example
    /// ```swift
    /// Fn.make_timestamp(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_timestamp(_ year: SwifQLable,
                                                       _ month: SwifQLable,
                                                       _ day: SwifQLable,
                                                       _ hour: SwifQLable,
                                                       _ min: SwifQLable,
                                                       _ sec: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: hour.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        return build(.make_timestamp, body: parts)
    }
    
    /// Create timestamp with time zone from year, month, day, hour, minute and seconds fields;
    /// if timezone is not specified, the current time zone is used
    /// # Example
    /// ```swift
    /// Fn.make_timestamptz(2013, 7, 15, 8, 15, 23.5)
    /// ```
    /// # Result
    /// ```
    /// 2013-07-15 08:15:23.5+01
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func make_timestamptz(_ year: SwifQLable,
                                                          _ month: SwifQLable,
                                                          _ day: SwifQLable,
                                                          _ hour: SwifQLable,
                                                          _ min: SwifQLable,
                                                          _ sec: SwifQLable,
                                                          _ timezone: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = year.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: month.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: day.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: hour.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: min.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: sec.parts)
        if let timezone = timezone {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: timezone.parts)
        }
        return build(.make_timestamptz, body: parts)
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.now()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func now() -> SwifQLable {
        return build(.now, body: [])
    }
    
    /// Current date and time (start of current statement)
    /// # Example
    /// ```swift
    /// Fn.statement_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func statement_timestamp() -> SwifQLable {
        return build(.statement_timestamp, body: [])
    }
    
    /// Current date and time (like clock_timestamp, but as a text string)
    /// # Example
    /// ```swift
    /// Fn.timeofday()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func timeofday() -> SwifQLable {
        return build(.timeofday, body: [])
    }
    
    /// Current date and time (start of current transaction)
    /// # Example
    /// ```swift
    /// Fn.transaction_timestamp()
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func transaction_timestamp() -> SwifQLable {
        return build(.transaction_timestamp, body: [])
    }
    
    /// Convert Unix epoch (seconds since 1970-01-01 00:00:00+00) to timestamp
    /// # Example
    /// ```swift
    /// Fn.to_timestamp(1284352323)
    /// ```
    /// # Result
    /// ```
    /// 2010-09-13 04:32:03+00
    /// ```
    ///
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-datetime.html)
    public static func to_timestamp(_ value: SwifQLable) -> SwifQLable {
        return build(.to_timestamp, body: value.parts)
    }
    
    /// PostgreSQL provides the function to_tsvector for converting a document to the tsvector data type.
    /// to_tsvector([ config regconfig, ] document text) returns tsvector
    /// # Example
    /// ```swift
    /// Fn.to_tsvector("english", "a fat  cat sat on a mat - it ate a fat rats")
    /// ```
    /// # Result
    /// ```
    /// 'ate':9 'cat':3 'fat':2,11 'mat':7 'rat':12 'sat':4
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func to_tsvector(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.to_tsvector, body: parts)
    }
    
    /// PostgreSQL provides to_tsquery function for converting a query to the tsquery data type.
    /// to_tsquery offers access to more features than plainto_tsquery, but is less forgiving about its input.
    /// to_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.to_tsquery("english", "The & Fat & Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func to_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.to_tsquery, body: parts)
    }
    
    /// `plainto_tsquery` transforms unformatted text querytext to tsquery
    /// plainto_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.plainto_tsquery("english", "The Fat Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func plainto_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.plainto_tsquery, body: parts)
    }
    
    /// PostgreSQL provides two predefined ranking functions, which take into account lexical, proximity,
    /// and structural information; that is, they consider how often the query terms appear in the document,
    /// how close together the terms are in the document, and how important is the part of the document where they occur.
    
    /// `ts_rank_rd` calculates the rank of the provided tsquery
    /// ts_rank_rd(vector tsvector, query tsquery [, normalization integer ]) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.ts_rank_cd("rats", Fn.to_tsquery("The Fat Rats"))
    /// ```
    /// # Result
    /// ```
    /// ts_rank_cd("rats", to_tsquery('The Fat Rats'))
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.6/textsearch-controls.html#TEXTSEARCH-RANKING)
    public static func ts_rank_cd(_ vector: SwifQLable, _ query: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = vector.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: query.parts)
        return build(.ts_rank_cd, body: parts)
    }
    
    /// Concatenate all arguments. NULL arguments are ignored.
    ///
    /// # Example
    /// ```swift
    /// Fn.concat("Hello ", \User.name)
    /// ```
    /// # Result
    /// ```
    /// concat('Hello ', "User"."name")
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/functions-string.html)
    public static func concat(_ values: SwifQLable...) -> SwifQLable {
        return concat(values)
    }
    
    /// Concatenate all arguments. NULL arguments are ignored.
    ///
    /// # Example
    /// ```swift
    /// Fn.concat("Hello ", \User.name)
    /// ```
    /// # Result
    /// ```
    /// concat('Hello ', "User"."name")
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/functions-string.html)
    public static func concat(_ values: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        values.enumerated().forEach { offset, value in
            parts.append(contentsOf: value.parts)
            if offset < values.count - 1 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
        }
        return build(.concat, body: parts)
    }
    
    /// Concatenate all arguments. NULL arguments are ignored.
    ///
    /// # Example
    /// ```swift
    /// Fn.concat_ws(", ", "Hello", \User.name)
    /// ```
    /// # Result
    /// ```
    /// concat_ws(', ', 'Hello', "User"."name")
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/functions-string.html)
    public static func concat_ws(_ values: SwifQLable...) -> SwifQLable {
        return concat_ws(values)
    }
    
    /// Concatenate all arguments. NULL arguments are ignored.
    ///
    /// # Example
    /// ```swift
    /// Fn.concat_ws(", ", "Hello", \User.name)
    /// ```
    /// # Result
    /// ```
    /// concat_ws(', ', 'Hello', "User"."name")
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/functions-string.html)
    public static func concat_ws(_ values: [SwifQLable]) -> SwifQLable {
        var parts: [SwifQLPart] = []
        values.enumerated().forEach { offset, value in
            parts.append(contentsOf: value.parts)
            if offset < values.count - 1 {
                parts.append(o: .comma)
                parts.append(o: .space)
            }
        }
        return build(.concat_ws, body: parts)
    }
    
    // MARK: - MySQL
    
    public static func from_unixtime(_ timeinterval: SwifQLable, _ format: String? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = timeinterval.parts
        if let format = format {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(o: .custom(format.singleQuotted))
        }
        return build(.from_unixtime, body: parts)
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
    public mutating func append(f: Fn.Name) {
        append(f.part)
    }
    public mutating func append(o: SwifQLPartOperator...) {
        for o in o {
            append(o)
        }
    }
    public mutating func append(safe value: Any) {
        append(SwifQLPartSafeValue(value))
    }
}
