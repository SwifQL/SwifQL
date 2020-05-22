//
//  Functions+Numeric.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
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
}

extension Fn {
    /// Returns the absolute value of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/abs.php)
    public static func abs(_ number: SwifQLable) -> SwifQLable {
        build(.abs, body: number.parts)
    }
    
    /// Returns the average value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/avg.php)
    public static func avg(_ quantity: SwifQLable) -> SwifQLable {
        build(.avg, body: quantity.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceil.php)
    public static func ceil(_ number: SwifQLable) -> SwifQLable {
        build(.ceil, body: number.parts)
    }
    
    /// Returns the smallest integer value that is greater than or equal to a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/ceiling.php)
    public static func ceiling(_ number: SwifQLable) -> SwifQLable {
        build(.ceiling, body: number.parts)
    }
    
    /// Returns the count of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/count.php)
    public static func count(_ expression: SwifQLable) -> SwifQLable {
        build(.count, body: expression.parts)
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
        build(.floor, body: number.parts)
    }
    
    /// Returns the maximum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/max.php)
    public static func max(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.max, body: aggregateExpression.parts)
    }
    
    /// Returns the minimum value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/min.php)
    public static func min(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.min, body: aggregateExpression.parts)
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
        build(.random, body: [])
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
        build(.setseed, body: number.parts)
    }
    
    /// Returns a value indicating the sign of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sign.php)
    public static func sign(_ number: SwifQLable) -> SwifQLable {
        build(.sign, body: number.parts)
    }
    
    /// Returns the square root of a number
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sqrt.php)
    public static func sqrt(_ number: SwifQLable) -> SwifQLable {
        build(.sqrt, body: number.parts)
    }
    
    /// Returns the summed value of an expression
    /// [Learn more →](https://www.techonthenet.com/postgresql/functions/sum.php)
    public static func sum(_ aggregateExpression: SwifQLable) -> SwifQLable {
        build(.sum, body: aggregateExpression.parts)
    }
}
