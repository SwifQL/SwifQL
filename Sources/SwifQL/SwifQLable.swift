//
//  SwifQLable.swift
//  SwifQL
//
//  Created by Mihael Isaev on 04/11/2018.
//

import Foundation

public protocol SwifQLable: CustomStringConvertible {
    var parts: [SwifQLPart] { get }
}

extension SwifQLable {
    public var description: String { prepare(.psql).plain }
}

public struct SwifQLableParts: SwifQLable {
    public var parts: [SwifQLPart]
    public init (parts: SwifQLPart...) {
        self.init(parts: parts)
    }
    public init (parts: [SwifQLPart]) {
        guard let frame = parts.first as? SwifQLStructuralFramePart else {
            self.parts = parts
            return
        }

        var appended = Array(parts.dropFirst())
        if let first = appended.first as? SwifQLPartOperator, first._value == " " {
            let rootAlreadyEndsInSpace: Bool
            if let last = frame.children.last as? SwifQLPartOperator {
                rootAlreadyEndsInSpace = last._value == " "
            } else {
                rootAlreadyEndsInSpace = false
            }
            if frame.children.isEmpty || rootAlreadyEndsInSpace {
                appended.removeFirst()
            }
        }

        self.parts = [frame.appending(appended)]
    }
}

public protocol SwifQLPart {}

public protocol SwifQLKeyPathable: SwifQLPart {
    var schema: String? { get }
    var table: String? { get }
    var paths: [String] { get }
}

extension SwifQLable {
    /// Good choice only for super short and universal queries like `BEGIN;`, `ROLLBACK;`, `COMMIT;`
    public func prepare() -> SwifQLPrepared {
        prepare(.any)
    }
    
    public func prepare(_ dialect: SQLDialect) -> SwifQLPrepared {
        var values: [Encodable] = []
        var formattedValues: [String] = []

        func render(_ parts: [SwifQLPart], context: SwifQLRenderContext) -> String {
            parts.map { part in
                if let scopedPart = part as? SwifQLScopedPart {
                    return render(
                        scopedPart.parts,
                        context: context.appending(scopedPart.scope)
                    )
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
                    guard v.elements.count > 0 else {
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
                case let v as SwifQLPartColumn:
                    return dialect.column(v.name)
                case let v as SwifQLStarExcludePart:
                    return render(dialect.starExcludeParts(v), context: context)
                case let v as SwifQLStarReplacePart:
                    return render(dialect.starReplaceParts(v), context: context)
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
                        return inlineValue
                    }
                    values.append(v.unsafeValue)
                    formattedValues.append(dialect.safeValue(v.unsafeValue))
                    return dialect.bindSymbol
                default:
                    return ""
                }
            }.joined(separator: "")
        }

        let query = render(parts, context: SwifQLRenderContext())
        return .init(dialect: dialect, query: query, values: values, formattedValues: formattedValues)
    }
}
