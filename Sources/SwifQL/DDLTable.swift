import Foundation

extension SwifQLable {
    /// Appends the exact SQL operand `TYPE <type>`.
    public func type(_ type: SwifQL.`Type`) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .type, .space, SwifQLPartOperator(type.name))
        return SwifQLableParts(parts: parts)
    }

    /// Appends a parenthesized, comma-separated table-definition list.
    public func tableDefinitions(_ definitions: SwifQLable...) -> SwifQLable {
        tableDefinitions(definitions)
    }

    /// Appends a parenthesized, comma-separated table-definition list.
    public func tableDefinitions(_ definitions: [SwifQLable]) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .openBracket)
        for (index, definition) in definitions.enumerated() {
            if index > 0 {
                parts.append(o: .comma, .space)
            }
            parts.append(contentsOf: definition.parts)
        }
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}

public enum GeneratedColumnStorage {
    case virtual
    case stored
}

public struct GeneratedColumn: SwifQLable {
    private let name: String
    private let type: SwifQL.`Type`?
    private let expression: SwifQLable
    private let storage: GeneratedColumnStorage?

    public init(
        _ name: String,
        as expression: SwifQLable,
        storage: GeneratedColumnStorage? = nil
    ) {
        self.name = name
        self.type = nil
        self.expression = expression
        self.storage = storage
    }

    public init(
        _ name: String,
        _ type: SwifQL.`Type`,
        generatedAlwaysAs expression: SwifQLable,
        storage: GeneratedColumnStorage? = nil
    ) {
        self.name = name
        self.type = type
        self.expression = expression
        self.storage = storage
    }

    public var parts: [SwifQLPart] {
        var parts: [SwifQLPart] = [SwifQLPartColumn(name)]
        if let type {
            parts.append(o: .space, SwifQLPartOperator(type.name))
            parts.append(o: .space, .custom("GENERATED"), .space, .custom("ALWAYS"))
        }
        parts.append(o: .space, .as, .space, .openBracket)
        parts.append(contentsOf: expression.parts)
        parts.append(o: .closeBracket)
        if let storage {
            switch storage {
            case .virtual:
                parts.append(o: .space, .custom("VIRTUAL"))
            case .stored:
                parts.append(o: .space, .custom("STORED"))
            }
        }
        return parts
    }
}
