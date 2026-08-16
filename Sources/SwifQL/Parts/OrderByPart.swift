/// A readable ORDER BY clause that preserves its selected structural owner.
public struct SwifQLOrderByPart: SwifQLPart {
    public let owner: SwifQLClauseOwner?
    public let items: [[SwifQLPart]]

    public init(
        owner: SwifQLClauseOwner?,
        items: [[SwifQLPart]]
    ) {
        self.owner = owner
        self.items = items
    }
}
