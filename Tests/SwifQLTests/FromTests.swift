import XCTest
@testable import SwifQL

final class FromTests: SwifQLTestCase {
    //MARK: - FROM
    
    func testSelectFrom() {
        check(
            SwifQL.select(1).from(),
            .psql("SELECT 1 FROM "),
            .mysql("SELECT 1 FROM ")
        )
    }
    
    func testFrom() {
        check(
            SwifQL.from(),
            .psql("FROM "),
            .mysql("FROM ")
        )
    }
    
    func testFromOneTable() {
        check(
            SwifQL.from(CarBrands.table),
            .psql(#"FROM "CarBrands""#),
            .mysql("FROM CarBrands")
        )
    }
    
    func testFromTwoTables() {
        check(
            SwifQL.from(CarBrands.table, CarBrands.table),
            .psql(#"FROM "CarBrands", "CarBrands""#),
            .mysql("FROM CarBrands, CarBrands")
        )
    }
    
    func testFromOneTableAlias() {
        check(
            SwifQL.from(cb.table),
            .psql(#"FROM "CarBrands" AS "cb""#),
            .mysql("FROM CarBrands AS cb")
        )
    }
    
    func testFromTwoTableAliases() {
        check(
            SwifQL.from(cb.table, cb.table),
            .psql(#"FROM "CarBrands" AS "cb", "CarBrands" AS "cb""#),
            .mysql("FROM CarBrands AS cb, CarBrands AS cb")
        )
    }
    
    func testFromTableAndTableAlias() {
        check(
            SwifQL.from(CarBrands.table, cb.table),
            .psql(#"FROM "CarBrands", "CarBrands" AS "cb""#),
            .mysql("FROM CarBrands, CarBrands AS cb")
        )
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
