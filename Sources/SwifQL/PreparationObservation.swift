//
//  PreparationObservation.swift
//  SwifQL
//
//  Created by SwifQL contributors.
//

import Foundation

public struct SwifQLUnsafeValueOccurrence {
    public enum Disposition: Equatable, Sendable {
        case bound(index: Int)
        case notBound
    }

    public let value: Encodable
    public let disposition: Disposition

    init(value: Encodable, disposition: Disposition) {
        self.value = value
        self.disposition = disposition
    }
}

public enum SwifQLUnsafeValueTrace {
    case complete([SwifQLUnsafeValueOccurrence])
    case unavailable
}

public struct SwifQLObservedPrepared {
    public let prepared: SwifQLPrepared
    public let unsafeValueTrace: SwifQLUnsafeValueTrace

    init(prepared: SwifQLPrepared, unsafeValueTrace: SwifQLUnsafeValueTrace) {
        self.prepared = prepared
        self.unsafeValueTrace = unsafeValueTrace
    }
}

public struct SwifQLUnsafeValueObservation {
    public func notBound(_ unsafeValue: SwifQLPartUnsafeValue) -> SwifQLPart {
        SwifQLUnsafeValueObservationPart(unsafeValue: unsafeValue)
    }
}

public struct SwifQLObservedParts {
    public let parts: [SwifQLPart]

    let isComplete: Bool

    public static func complete(_ parts: [SwifQLPart]) -> SwifQLObservedParts {
        .init(parts: parts, isComplete: true)
    }

    static func incomplete(_ parts: [SwifQLPart]) -> SwifQLObservedParts {
        .init(parts: parts, isComplete: false)
    }

    private init(parts: [SwifQLPart], isComplete: Bool) {
        self.parts = parts
        self.isComplete = isComplete
    }
}

private struct SwifQLUnsafeValueObservationPart: SwifQLPart {
    let unsafeValue: SwifQLPartUnsafeValue
}

enum SwifQLPreparationMode {
    case legacy
    case observeUnsafeValues
}

struct SwifQLPreparationResult {
    let prepared: SwifQLPrepared
    let unsafeValueTrace: SwifQLUnsafeValueTrace
}

final class SwifQLPreparationRenderer {
    private let dialect: SQLDialect
    private let mode: SwifQLPreparationMode

    private var values: [Encodable] = []
    private var formattedValues: [String] = []
    private var unsafeValueOccurrences: [SwifQLUnsafeValueOccurrence] = []
    private var traceIsComplete = true

    init(dialect: SQLDialect, mode: SwifQLPreparationMode) {
        self.dialect = dialect
        self.mode = mode
    }

    func prepare(_ parts: [SwifQLPart]) -> SwifQLPreparationResult {
        let query = render(parts, context: SwifQLRenderContext())
        let prepared = SwifQLPrepared(
            dialect: dialect,
            query: query,
            values: values,
            formattedValues: formattedValues
        )

        let trace: SwifQLUnsafeValueTrace
        switch mode {
        case .legacy:
            trace = .unavailable
        case .observeUnsafeValues:
            trace = traceIsComplete ? .complete(unsafeValueOccurrences) : .unavailable
        }

        return .init(prepared: prepared, unsafeValueTrace: trace)
    }

    private func render(_ parts: [SwifQLPart], context: SwifQLRenderContext) -> String {
        parts.map { part in
            if let scopedPart = part as? SwifQLScopedPart {
                return render(
                    scopedPart.parts,
                    context: context.appending(scopedPart.scope)
                )
            }

            if let observedUnsafe = part as? SwifQLUnsafeValueObservationPart {
                guard mode == .observeUnsafeValues else {
                    return ""
                }
                unsafeValueOccurrences.append(
                    .init(
                        value: observedUnsafe.unsafeValue.unsafeValue,
                        disposition: .notBound
                    )
                )
                return ""
            }

            switch part {
            case let v as SwifQLStructuralFramePart:
                return render(v.children, context: SwifQLRenderContext())
            case let v as SwifQLGroupByPart:
                let childContext = v.owner.map {
                    context.appending($0.renderScope(for: .groupBy))
                } ?? context
                var clauseParts: [SwifQLPart] = []
                clauseParts.append(o: .group)
                clauseParts.append(o: .space)
                clauseParts.append(o: .by)
                clauseParts.append(o: .space)
                for (i, field) in v.fields.enumerated() {
                    if i > 0 {
                        clauseParts.append(o: .comma)
                        clauseParts.append(o: .space)
                    }
                    clauseParts.append(contentsOf: field)
                }
                return render(clauseParts, context: childContext)
            case let v as SwifQLOrderByPart:
                let childContext = v.owner.map {
                    context.appending($0.renderScope(for: .orderBy))
                } ?? context
                var clauseParts: [SwifQLPart] = []
                clauseParts.append(o: .order)
                clauseParts.append(o: .space)
                clauseParts.append(o: .by)
                clauseParts.append(o: .space)
                for (i, item) in v.items.enumerated() {
                    if i > 0 {
                        clauseParts.append(o: .comma)
                        clauseParts.append(o: .space)
                    }
                    clauseParts.append(contentsOf: item)
                }
                return render(clauseParts, context: childContext)
            case let v as SwifQLPartArray:
                guard !v.elements.isEmpty else {
                    return dialect.emptyArrayStart + dialect.emptyArrayEnd
                }
                var string = dialect.arrayStart
                for (i, element) in v.elements.enumerated() {
                    if i > 0 {
                        string += dialect.arraySeparator
                    }
                    string += render(element.parts, context: context)
                }
                return string + dialect.arrayEnd
            case let v as SwifQLPartBool:
                return dialect.boolValue(v.value)
            case is SwifQLPartNull:
                return dialect.null
            case let v as SwifQLPartCatalog:
                return dialect.catalogName(v.name)
            case let v as SwifQLPartIdentifier:
                return dialect.identifier(v.name)
            case let v as SwifQLPartSchema:
                guard let schema = v.schema else { return "" }
                return dialect.schemaName(schema)
            case let v as SwifQLPartTable:
                if let schema = v.schema {
                    return dialect.schemaName(schema) + "." + dialect.tableName(v.table)
                }
                return dialect.tableName(v.table)
            case let v as SwifQLPartTableWithAlias:
                if let schema = v.schema {
                    return dialect.schemaName(schema) + "." + dialect.tableName(v.table, andAlias: v.alias)
                }
                return dialect.tableName(v.table, andAlias: v.alias)
            case let v as SwifQLPartAlias:
                return dialect.alias(v.alias)
            case let v as SwifQLPartKeyPath:
                return dialect.keyPath(v, context: context)
            case let v as SwifQLPartSampling:
                switch mode {
                case .legacy:
                    return render(dialect.sampling(v), context: context)
                case .observeUnsafeValues:
                    let observed = dialect.sampling(
                        v,
                        observingUnsafeValues: SwifQLUnsafeValueObservation()
                    )
                    if !observed.isComplete {
                        traceIsComplete = false
                    }
                    return render(observed.parts, context: context)
                }
            case let v as SwifQLPartLambda:
                switch mode {
                case .legacy:
                    return render(dialect.lambda(v), context: context)
                case .observeUnsafeValues:
                    let observed = dialect.lambda(
                        v,
                        observingUnsafeValues: SwifQLUnsafeValueObservation()
                    )
                    if !observed.isComplete {
                        traceIsComplete = false
                    }
                    return render(observed.parts, context: context)
                }
            case let v as SwifQLPartType:
                return dialect.type(v.type)
            case let v as SwifQLPartColumn:
                return dialect.column(v.name)
            case let v as SwifQLStarExcludePart:
                return render(dialect.starExcludeParts(v), context: context)
            case let v as SwifQLStarReplacePart:
                switch mode {
                case .legacy:
                    return render(dialect.starReplaceParts(v), context: context)
                case .observeUnsafeValues:
                    let observed = dialect.starReplaceParts(
                        v,
                        observingUnsafeValues: SwifQLUnsafeValueObservation()
                    )
                    if !observed.isComplete {
                        traceIsComplete = false
                    }
                    return render(observed.parts, context: context)
                }
            case let v as SwifQLStarRenamePart:
                return render(dialect.starRenameParts(v), context: context)
            case let v as SwifQLPartOperator:
                return v._value
            case let v as SwifQLHybridOperator:
                return dialect.hybridOperator(v)._value
            case let v as SwifQLPartDate:
                return dialect.date(v.date)
            case let v as SwifQLPartSafeValue:
                return dialect.safeValue(v.safeValue)
            case let v as SwifQLPartUnsafeValue:
                if let inlineValue = dialect.inlineUnsafeValue(v.unsafeValue, context: context) {
                    if mode == .observeUnsafeValues {
                        unsafeValueOccurrences.append(
                            .init(value: v.unsafeValue, disposition: .notBound)
                        )
                    }
                    return inlineValue
                }

                let index = values.count
                if mode == .observeUnsafeValues {
                    unsafeValueOccurrences.append(
                        .init(value: v.unsafeValue, disposition: .bound(index: index))
                    )
                }
                values.append(v.unsafeValue)
                formattedValues.append(dialect.safeValue(v.unsafeValue))
                return dialect.bindSymbol
            default:
                return ""
            }
        }.joined(separator: "")
    }
}
