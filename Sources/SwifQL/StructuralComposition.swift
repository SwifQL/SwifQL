import Foundation

/// Open identity for a clause whose semantic owner may be selected by a
/// structural SQL-region frame.
public struct SwifQLClauseKind: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }

    public static let on = Self(namespace: "swifql", name: "on")
    public static let using = Self(namespace: "swifql", name: "using")
    public static let groupBy = Self(namespace: "swifql", name: "groupBy")
    public static let orderBy = Self(namespace: "swifql", name: "orderBy")
}

/// Open identity for the structural SQL region that owns a clause.
public struct SwifQLClauseOwner: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }

    public func renderScope(for kind: SwifQLClauseKind) -> SwifQLRenderScope {
        SwifQLRenderScope(
            namespace: "swifql.clause-owner",
            name: "\(namespace).\(name).\(kind.namespace).\(kind.name)"
        )
    }
}

/// The real SQL-region boundaries represented by the structural composition
/// layer. Ordinary expression parentheses are not structural regions.
public enum SwifQLStructuralRegion: Hashable, Sendable {
    case statement
    case setResult
}

/// A value-semantic, readable SQL-region/set-result root in `SwifQLable.parts`.
public struct SwifQLStructuralFramePart: SwifQLPart {
    public let region: SwifQLStructuralRegion
    public let children: [SwifQLPart]
    public let owners: [SwifQLClauseKind: SwifQLClauseOwner]

    public init(
        region: SwifQLStructuralRegion,
        owners: [SwifQLClauseKind: SwifQLClauseOwner] = [:],
        children: [SwifQLPart] = []
    ) {
        self.region = region
        self.owners = owners
        self.children = children
    }

    public func owner(for kind: SwifQLClauseKind) -> SwifQLClauseOwner? {
        owners[kind]
    }

    internal func appending(
        _ parts: [SwifQLPart],
        owners newOwners: [SwifQLClauseKind: SwifQLClauseOwner] = [:]
    ) -> Self {
        guard !newOwners.isEmpty else {
            return Self(region: region, owners: owners, children: children + parts)
        }

        var mergedOwners = owners
        mergedOwners.merge(newOwners) { _, new in new }
        return Self(region: region, owners: mergedOwners, children: children + parts)
    }
}

enum _SwifQLStructuralComposition {
    static func rootFrame(in parts: [SwifQLPart]) -> SwifQLStructuralFramePart? {
        parts.first as? SwifQLStructuralFramePart
    }

    static func currentOwner(
        in parts: [SwifQLPart],
        for kind: SwifQLClauseKind
    ) -> SwifQLClauseOwner? {
        rootFrame(in: parts)?.owner(for: kind)
    }

    static func statementFrame(for query: SwifQLable) -> SwifQLStructuralFramePart {
        if let frame = rootFrame(in: query.parts), frame.region == .statement {
            return frame
        }

        return SwifQLStructuralFramePart(region: .statement, children: query.parts)
    }

    static func setResult(from query: SwifQLable) -> SwifQLable {
        if let frame = rootFrame(in: query.parts), frame.region == .setResult {
            return query
        }

        return SwifQLableParts(rawParts: [
            SwifQLStructuralFramePart(
                region: .setResult,
                children: [statementFrame(for: query)]
            )
        ])
    }

    static func append(
        _ base: SwifQLable,
        parts newParts: [SwifQLPart],
        owners newOwners: [SwifQLClauseKind: SwifQLClauseOwner] = [:]
    ) -> SwifQLable {
        func continuationParts(
            _ parts: [SwifQLPart],
            after existingParts: [SwifQLPart]
        ) -> [SwifQLPart] {
            guard let first = parts.first as? SwifQLPartOperator,
                  first._value == " " else {
                return parts
            }

            if existingParts.isEmpty,
               !parts.isEmpty {
                return Array(parts.dropFirst())
            }

            if let last = existingParts.last as? SwifQLPartOperator,
               last._value == " " {
                return Array(parts.dropFirst())
            }

            return parts
        }

        guard let root = rootFrame(in: base.parts) else {
            let appendedParts = continuationParts(newParts, after: base.parts)
            guard !newOwners.isEmpty else {
                return SwifQLableParts(rawParts: base.parts + appendedParts)
            }

            return SwifQLableParts(rawParts: [
                SwifQLStructuralFramePart(
                    region: .statement,
                    owners: newOwners,
                    children: base.parts + appendedParts
                )
            ])
        }

        let appendedParts = continuationParts(newParts, after: root.children)
        return SwifQLableParts(rawParts: [root.appending(appendedParts, owners: newOwners)])
    }

    static func appendStatementContents(
        from fragment: SwifQLable,
        to base: SwifQLable
    ) -> SwifQLable {
        let contents: [SwifQLPart]
        if let frame = rootFrame(in: fragment.parts), frame.region == .statement {
            contents = frame.children
        } else {
            contents = fragment.parts
        }

        guard !contents.isEmpty else {
            return base
        }

        return append(
            base,
            parts: [SwifQLPartOperator.space] + contents
        )
    }
}

extension SwifQLable {
    /// Continues the current root SQL region without inspecting nested
    /// frames or semantic history.
    public func structurallyAppending(_ fragment: SwifQLable) -> SwifQLable {
        _SwifQLStructuralComposition.append(self, parts: fragment.parts)
    }

    /// Reads ownership only from the current root frame.
    public func structuralOwner(for kind: SwifQLClauseKind) -> SwifQLClauseOwner? {
        _SwifQLStructuralComposition.currentOwner(in: parts, for: kind)
    }
}

extension SwifQLableParts {
    internal init(rawParts: [SwifQLPart]) {
        self.parts = rawParts
    }
}
