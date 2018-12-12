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
        case select, `as`, from, join, `where`, groupBy, orderBy, insertInto, values, union
        case and, or, greaterThan, lessThan, greaterThanOrEqual, lessThanOrEqual
        case equal, notEqual, `in`, notIn, like, notLike, ilike, notILike, fulltext, isNull, isNotNull
        case between, notBetween, not
        //just syntax
        case openBracket, closeBracket
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
            case .between: return "BETWEEN"
            case .notBetween: return "NOT BETWEEN"
            case .not: return "NOT"
            case .openBracket: return "("
            case .closeBracket: return ")"
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
            case .custom(let v): return v
            }
        }
        
        var part: SwifQLPartOperator {
            return SwifQLPartOperator(rawValue)
        }
    }
    
    public enum CastTypes {
        case uuid
        case char
        case varchar
        case text
        case integer
        case numeric
        case numeric2(Int, Int)
        case bigint
        case float(Int)
        case real
        case float8
        case bool
        
        var string: String {
            switch self {
            case .uuid: return "uuid"
            case .char: return "char"
            case .varchar: return "varchar"
            case .text: return "text"
            case .integer: return "integer"
            case .numeric: return "numeric"
            case .numeric2(let p, let s): return "numeric(\(p), \(s))"
            case .bigint: return "bigint"
            case .float(let v): return "float(\(v))"
            case .real: return "real"
            case .float8: return "float8"
            case .bool: return "bool"
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
        parts.append(o: .custom("in"))
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
            parts.append(o: .custom("from"))
            parts.append(o: .space)
            parts.append(safe: startPosition)
        }
        if let length = length {
            parts.append(o: .space)
            parts.append(o: .custom("for"))
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
        parts.append(o: .custom("from"))
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
