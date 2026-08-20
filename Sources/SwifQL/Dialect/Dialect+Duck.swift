//
//  Dialect+Duck.swift
//

import Foundation

private func duckSamplingLiteralParts(_ value: Encodable) -> [SwifQLPart] {
    switch value {
    case let value as String:
        return [SwifQLPartSafeValue(value)]
    case let value as Int:
        return [SwifQLPartSafeValue(value)]
    case let value as Int8:
        return [SwifQLPartSafeValue(value)]
    case let value as Int16:
        return [SwifQLPartSafeValue(value)]
    case let value as Int32:
        return [SwifQLPartSafeValue(value)]
    case let value as Int64:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt8:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt16:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt32:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt64:
        return [SwifQLPartSafeValue(value)]
    case let value as Float:
        return [SwifQLPartSafeValue(value)]
    case let value as Double:
        return [SwifQLPartSafeValue(value)]
    case let value as Decimal:
        return [SwifQLPartSafeValue(value)]
    default:
        return [SwifQLPartOperator("<duck_sampling_argument_requires_safe_literal>")]
    }
}

private func duckSamplingLiteralParts(_ value: SwifQLable) -> [SwifQLPart] {
    switch value {
    case let value as String:
        return [SwifQLPartSafeValue(value)]
    case let value as Int:
        return [SwifQLPartSafeValue(value)]
    case let value as Int8:
        return [SwifQLPartSafeValue(value)]
    case let value as Int16:
        return [SwifQLPartSafeValue(value)]
    case let value as Int32:
        return [SwifQLPartSafeValue(value)]
    case let value as Int64:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt8:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt16:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt32:
        return [SwifQLPartSafeValue(value)]
    case let value as UInt64:
        return [SwifQLPartSafeValue(value)]
    case let value as Float:
        return [SwifQLPartSafeValue(value)]
    case let value as Double:
        return [SwifQLPartSafeValue(value)]
    case let value as Decimal:
        return [SwifQLPartSafeValue(value)]
    default:
        let parts = value.parts
        if !parts.isEmpty && parts.allSatisfy({ $0 is SwifQLPartSafeValue }) {
            return parts
        }
        if parts.count == 1, let unsafe = parts[0] as? SwifQLPartUnsafeValue {
            return duckSamplingLiteralParts(unsafe.unsafeValue)
        }
        return [SwifQLPartOperator("<duck_sampling_argument_requires_safe_literal>")]
    }
}

class DuckDialect: SQLDialect {
    private static let unqualifiedKeyPathScopes: Set<SwifQLRenderScope> = [
        .simplifiedPivotOn,
        .simplifiedPivotUsing,
        .simplifiedPivotGroupBy,
        .simplifiedPivotOrderBy,
        .simplifiedUnpivotOrderBy
    ]

    override var id: String? { "duckdb" }

    override var hybridRepresentationKey: SwifQLHybridRepresentationKey? { .duck }

    override func hybridOperator(_ hybrid: SwifQLHybridOperator) -> SwifQLPartOperator {
        hybrid.representation(for: .duck)
            ?? SwifQLPartOperator("<duck_hybrid_operator_requires_explicit_duck_branch>")
    }

    override func sampling(_ sample: SwifQLPartSampling) -> [SwifQLPart] {
        sample.renderedParts(
            argumentParts: sample.arguments.map { duckSamplingLiteralParts($0.value) },
            seedParts: sample.seed.map { duckSamplingLiteralParts($0.value) },
            repeatabilityParts: sample.repeatability.map { duckSamplingLiteralParts($0.value) }
        )
    }

    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func quotedIdentifier(_ value: String) -> String {
        "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }

    override func schemaName(_ value: String) -> String { quotedIdentifier(value) }

    override func identifier(_ value: String) -> String { quotedIdentifier(value) }

    override func catalogName(_ value: String) -> String { quotedIdentifier(value) }

    override func tableName(_ value: String) -> String { quotedIdentifier(value) }

    override func alias(_ value: String) -> String { quotedIdentifier(value) }

    override func column(_ value: String) -> String { quotedIdentifier(value) }

    override func stringValue(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "''"))'"
    }

    override func jsonField(_ value: String) -> String { stringValue(value) }

    private func shouldUnqualifyKeyPath(_ context: SwifQLRenderContext) -> Bool {
        context.scopes.contains { Self.unqualifiedKeyPathScopes.contains($0) }
    }

    private func renderKeyPath(
        _ keyPath: SwifQLPartKeyPath,
        qualified: Bool
    ) -> String {
        var result = ""
        if qualified {
            if let schema = keyPath.schema {
                result.append(schemaName(schema))
            }
            if let table = keyPath.table {
                if result.count > 0 {
                    result.append(".")
                }
                result.append(tableName(table))
            }
        }
        for (i, value) in keyPath.paths.enumerated() {
            if i == 0 {
                if result.count > 0 {
                    result.append(".")
                }
                result.append(column(value))
            } else {
                if keyPath.asText, i == keyPath.paths.count - 1 {
                    result.append("->>")
                } else {
                    result.append("->")
                }
                result.append(jsonField(value))
            }
        }
        if keyPath.paths.count > 1 {
            return "(\(result))"
        }
        return result
    }

    override func keyPath(_ keyPath: SwifQLPartKeyPath) -> String {
        renderKeyPath(keyPath, qualified: true)
    }

    override func keyPath(
        _ keyPath: SwifQLPartKeyPath,
        context: SwifQLRenderContext
    ) -> String {
        renderKeyPath(
            keyPath,
            qualified: !shouldUnqualifyKeyPath(context)
        )
    }

    override func date(_ value: Date) -> String {
        let microsecondsSinceEpoch = Int64((value.timeIntervalSince1970 * 1_000_000).rounded())
        var normalizedDate = Date(timeIntervalSince1970: Double(microsecondsSinceEpoch) / 1_000_000)
        var components = utcCalendar.dateComponents(in: utcCalendar.timeZone, from: normalizedDate)
        var second = utcCalendar.date(from: DateComponents(
            calendar: utcCalendar,
            timeZone: utcCalendar.timeZone,
            year: components.year,
            month: components.month,
            day: components.day,
            hour: components.hour,
            minute: components.minute,
            second: components.second
        ))!
        var microseconds = Int((normalizedDate.timeIntervalSince(second) * 1_000_000).rounded())
        if microseconds >= 1_000_000 {
            normalizedDate = second.addingTimeInterval(1)
            components = utcCalendar.dateComponents(in: utcCalendar.timeZone, from: normalizedDate)
            second = utcCalendar.date(from: DateComponents(
                calendar: utcCalendar,
                timeZone: utcCalendar.timeZone,
                year: components.year,
                month: components.month,
                day: components.day,
                hour: components.hour,
                minute: components.minute,
                second: components.second
            ))!
            microseconds = 0
        }

        func padded(_ value: Int, to length: Int) -> String {
            let string = String(value)
            return String(repeating: "0", count: max(0, length - string.count)) + string
        }

        return "TIMESTAMPTZ '\(padded(components.year!, to: 4))-\(padded(components.month!, to: 2))-\(padded(components.day!, to: 2)) \(padded(components.hour!, to: 2)):\(padded(components.minute!, to: 2)):\(padded(components.second!, to: 2)).\(padded(microseconds, to: 6))+00:00'"
    }

    override func bindKey(_ i: Int) -> String { "$\(i)" }

    override func inlineUnsafeValue(
        _ value: Encodable,
        context: SwifQLRenderContext
    ) -> String? {
        guard context.contains(.starPattern) else { return nil }
        return safeValue(value)
    }

    override var arrayStart: String { "[" }

    override var arrayEnd: String { "]" }
}
