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

    internal func appending(_ parts: [SwifQLPart]) -> Self {
        Self(region: region, owners: owners, children: children + parts)
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

    static func append(
        _ base: SwifQLable,
        parts newParts: [SwifQLPart]
    ) -> SwifQLable {
        guard let root = rootFrame(in: base.parts) else {
            return SwifQLableParts(rawParts: base.parts + newParts)
        }

        return SwifQLableParts(rawParts: [root.appending(newParts)])
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
