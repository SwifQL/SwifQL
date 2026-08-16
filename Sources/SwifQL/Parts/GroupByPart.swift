/// A readable GROUP BY clause that preserves its selected structural owner.
public struct SwifQLGroupByPart: SwifQLPart {
    public let owner: SwifQLClauseOwner?
    public let fields: [[SwifQLPart]]

    public init(
        owner: SwifQLClauseOwner?,
        fields: [[SwifQLPart]]
    ) {
        self.owner = owner
        self.fields = fields
    }
}
