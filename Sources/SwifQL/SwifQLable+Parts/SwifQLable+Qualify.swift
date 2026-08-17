import Foundation

//MARK: QUALIFY

extension SwifQLable {
    /// Appends a QUALIFY predicate to the current SQL composition.
    public func qualify(_ predicate: SwifQLable) -> SwifQLable {
        var parts = self.parts
        parts.appendSpaceIfNeeded()
        parts.append(o: .custom("QUALIFY"), .space)
        parts.append(contentsOf: predicate.parts)
        return SwifQLableParts(parts: parts)
    }
}
