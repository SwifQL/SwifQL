//
//  Functions+String.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
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
    public static var string_agg: Self = .init("string_agg")
    public static var regexp_replace: Self = .init("regexp_replace")
} 

extension Fn {
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
    
    /// Number of bits in string
    /// e.g. `bit_length('jose')` will return 32
    /// [Learn more →]()
    public static func bit_length(_ string: SwifQLable) -> SwifQLable {
        build(.bit_length, body: string.parts)
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
        build(.char_length, body: string.parts)
    }
    
    /// Returns the length of the specified string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/character_length.php)
    public static func character_length(_ string: SwifQLable) -> SwifQLable {
        build(.character_length, body: string.parts)
    }
    
    /// Converts the first letter of each word to uppercase and all other letters are converted to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/initcap.php)
    public static func initcap(_ string: SwifQLable) -> SwifQLable {
        build(.initcap, body: string.parts)
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
        concat(values)
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
        concat_ws(values)
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
    
    /// Returns the length of the requested array dimension
    public static func array_length(_ anyArray: SwifQLable, _ dimension: Int = 1) -> SwifQLable {
        var parts: [SwifQLPart] = anyArray.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(safe: dimension)
        return build(.array_length, body: parts)
    }
    
    /// Returns the length of the specified string, expressed as the number of characters.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/length.php)
    public static func length(_ string: SwifQLable) -> SwifQLable {
        build(.length, body: string.parts)
    }
    
    /// Converts all characters in the specified string to lowercase
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/lower.php)
    public static func lower(_ string: SwifQLable) -> SwifQLable {
        build(.lower, body: string.parts)
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
        _substring(string, from: startPosition)
    }
    /// Allows you to extract a substring from a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/substring.php)
    public static func substring(_ string: SwifQLable, for length: Int) -> SwifQLable {
        _substring(string, for: length)
    }
    /// Allows you to extract a substring from a string
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/substring.php)
    public static func substring(_ string: SwifQLable, from startPosition: Int, for length: Int) -> SwifQLable {
        _substring(string, from: startPosition, for: length)
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
        build(.trim, body: string.parts)
    }
    
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(leading trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        _trim("leading", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(trailing trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        _trim("trailing", trimCharacter, from: string)
    }
    /// Removes all specified characters either from the beginning or the end of a string.
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/trim.php)
    public static func trim(both trimCharacter: SwifQLable? = nil, from string: SwifQLable) -> SwifQLable {
        _trim("both", trimCharacter, from: string)
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
        build(.upper, body: string.parts)
    }

    /// Concatenates non-null input values into a string, separated by delimiter
    /// [Learn more →](https://www.postgresql.org/docs/11/functions-aggregate.html)
    public static func string_agg(_ string: SwifQLable, _ separator: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(contentsOf: string.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: separator.parts)
        return build(.string_agg, body: parts)
    }
    
    /// Replaces a sequence of characters in a string with another set of characters using regular expression pattern matching
    /// [Learn more →](https://www.techonthenet.com/oracle/functions/regexp_replace.php)
    public static func regexp_replace(_ string: SwifQLable, _ fromRegexp: SwifQLable, _ toSubstring: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = []
        parts.append(contentsOf: string.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: fromRegexp.parts)
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: toSubstring.parts)
        return build(.regexp_replace, body: parts)
    }
}
