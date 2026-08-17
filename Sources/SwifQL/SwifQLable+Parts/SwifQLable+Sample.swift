import Foundation

/// A parser-constant sample size used by USING SAMPLE and TABLESAMPLE.
public struct SampleSize: SwifQLable {
    public enum Kind: Equatable {
        case percentage
        case rows
    }

    public let kind: Kind
    private let value: SwifQLPart

    public init(percentage value: Int) {
        self.kind = .percentage
        self.value = SwifQLPartSafeValue(value)
    }

    public init(percentage value: Double) {
        self.kind = .percentage
        self.value = SwifQLPartSafeValue(value)
    }

    public init(rows value: Int) {
        self.kind = .rows
        self.value = SwifQLPartSafeValue(value)
    }

    public var parts: [SwifQLPart] {
        [value]
    }

    fileprivate var usingSampleParts: [SwifQLPart] {
        var parts = self.parts
        if kind == .percentage {
            parts.append(o: .custom("%"))
        }
        return parts
    }

    fileprivate var tableSampleParts: [SwifQLPart] {
        var parts = self.parts
        parts.append(o: .space)
        parts.append(o: .custom(kind == .percentage ? "PERCENT" : "ROWS"))
        return parts
    }
}

/// A native DuckDB sampling method shared by the exact sampling clauses.
public enum SampleMethod: String, SwifQLable {
    case system
    case bernoulli
    case reservoir

    public var parts: [SwifQLPart] {
        [SwifQLPartOperator(rawValue)]
    }
}

/// The value-semantic options inside a USING SAMPLE clause.
public struct Sample: SwifQLable {
    private let size: SampleSize
    private let method: SampleMethod?
    private let seed: Int?

    public init(_ size: SampleSize, method: SampleMethod? = nil) {
        self.size = size
        self.method = method
        self.seed = nil
    }

    public init(_ size: SampleSize, method: SampleMethod, seed: Int) {
        self.size = size
        self.method = method
        self.seed = seed
    }

    public var parts: [SwifQLPart] {
        var parts = size.usingSampleParts
        if let method = method {
            parts.append(o: .space, .openBracket)
            parts.append(contentsOf: method.parts)
            if let seed = seed {
                parts.append(o: .comma, .space)
                parts.append(safe: seed)
            }
            parts.append(o: .closeBracket)
        }
        return parts
    }
}

/// The value-semantic options inside a TABLESAMPLE table-reference suffix.
public struct TableSample: SwifQLable {
    private let size: SampleSize
    private let method: SampleMethod?
    private let repeatable: Int?

    public init(_ size: SampleSize) {
        self.size = size
        self.method = nil
        self.repeatable = nil
    }

    public init(_ size: SampleSize, method: SampleMethod) {
        self.size = size
        self.method = method
        self.repeatable = nil
    }

    public init(_ size: SampleSize, method: SampleMethod, repeatable: Int) {
        self.size = size
        self.method = method
        self.repeatable = repeatable
    }

    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = []
        if let method = method {
            parts.append(contentsOf: method.parts)
            parts.append(o: .openBracket)
        } else {
            parts.append(o: .openBracket)
        }
        parts.append(contentsOf: size.tableSampleParts)
        parts.append(o: .closeBracket)
        if let repeatable = repeatable {
            parts.append(o: .space, .custom("REPEATABLE"), .space, .openBracket)
            parts.append(safe: repeatable)
            parts.append(o: .closeBracket)
        }
        return parts
    }
}

extension SwifQLable {
    /// Appends a SELECT-level USING SAMPLE clause.
    public func usingSample(_ sample: Sample) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .using, .space, .custom("SAMPLE"), .space)
        parts.append(contentsOf: sample.parts)
        return SwifQLableParts(parts: parts)
    }

    /// Appends a TABLESAMPLE suffix to a table reference.
    public func tableSample(_ sample: TableSample) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("TABLESAMPLE"), .space)
        parts.append(contentsOf: sample.parts)
        return SwifQLableParts(parts: parts)
    }
}
