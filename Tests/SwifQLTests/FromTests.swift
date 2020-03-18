import XCTest
@testable import SwifQL

final class FromTests: SwifQLTestCase {
    //MARK: - FROM
    
    func testSelectFrom() {
        checkAllDialects(SwifQL.select(1).from(), pg: "SELECT 1 FROM ", mySQL: "SELECT 1 FROM ")
    }
    
    func testFrom() {
        checkAllDialects(SwifQL.from(), pg: "FROM ", mySQL: "FROM ")
    }
    
    func testFromOneTable() {
        checkAllDialects(SwifQL.from(CarBrands.table), pg: """
            FROM "CarBrands"
            """, mySQL: """
            FROM CarBrands
            """)
    }
    
    func testFromTwoTables() {
        checkAllDialects(SwifQL.from(CarBrands.table, CarBrands.table), pg: """
            FROM "CarBrands", "CarBrands"
            """, mySQL: """
            FROM CarBrands, CarBrands
            """)
    }
    
    func testFromOneTableAlias() {
        checkAllDialects(SwifQL.from(cb.table), pg: """
            FROM "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb
            """)
    }
    
    func testFromTwoTableAliases() {
        checkAllDialects(SwifQL.from(cb.table, cb.table), pg: """
            FROM "CarBrands" AS "cb", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb, CarBrands AS cb
            """)
    }
    
    func testFromTableAndTableAlias() {
        checkAllDialects(SwifQL.from(CarBrands.table, cb.table), pg: """
            FROM "CarBrands", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands, CarBrands AS cb
            """)
    }
    
    static var allTests = [
        ("testSelectFrom", testSelectFrom),
        ("testFrom", testFrom),
        ("testFromOneTable", testFromOneTable),
        ("testFromTwoTables", testFromTwoTables),
        ("testFromOneTableAlias", testFromOneTableAlias),
        ("testFromTwoTableAliases", testFromTwoTableAliases),
        ("testFromTableAndTableAlias", testFromTableAndTableAlias)
    ]
}
