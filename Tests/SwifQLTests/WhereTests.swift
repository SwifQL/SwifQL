import XCTest
@testable import SwifQL

final class WhereTests: SwifQLTestCase {
    func testWhere() {
        checkAllDialects(SwifQL.where("" == 1), pg: "WHERE '' = 1", mySQL: "WHERE '' = 1")
        checkAllDialects(SwifQL.where, pg: "WHERE", mySQL: "WHERE")
    }
    
    static var allTests = [
        ("testWhere", testWhere)
    ]
}
