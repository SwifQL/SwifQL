import XCTest
@testable import SwifQL

final class OrderTests: SwifQLTestCase {
    // MARK: - Order by simple
    
    func testOrderBySimple() {
        let query = SwifQL.orderBy(.asc(CarBrands.column("name")), .desc(CarBrands.column("id")))
        let pg = """
        ORDER BY "CarBrands"."name" ASC, "CarBrands"."id" DESC
        """
        let mySQL = """
        ORDER BY CarBrands.name ASC, CarBrands.id DESC
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    // MARK: - Order by with nulls
    
    func testOrderByWithNulls() {
        let pgQuery = SwifQL.orderBy(.asc(CarBrands.column("name"), nulls: .first), .desc(CarBrands.column("id"), nulls: .last))
        let pg = """
        ORDER BY "CarBrands"."name" ASC NULLS FIRST, "CarBrands"."id" DESC NULLS LAST
        """
        let mysqlQuery = SwifQL.orderBy(.asc(CarBrands.column("name") == nil, CarBrands.column("name")), .desc(CarBrands.column("id") != nil, CarBrands.column("id")))
        let mySQL = """
        ORDER BY CarBrands.name IS NULL, CarBrands.name ASC, CarBrands.id IS NOT NULL, CarBrands.id DESC
        """
        checkAllDialects(pgQuery, pg: pg)
        checkAllDialects(mysqlQuery, mySQL: mySQL)
    }
    
    // MARK: - Order by with direction
    
    func testOrderByDirection() {
        let pgQuery = SwifQL.orderBy(.direction(.asc, CarBrands.column("name"), nulls: .last))
        let pg = """
        ORDER BY "CarBrands"."name" ASC NULLS LAST
        """
        let mysqlQuery = SwifQL.orderBy(.direction(.desc, CarBrands.column("id"), nulls: .first))
        let mySQL = """
        ORDER BY CarBrands.id DESC NULLS FIRST
        """
        checkAllDialects(pgQuery, pg: pg)
        checkAllDialects(mysqlQuery, mySQL: mySQL)
    }
    
    static var allTests = [
        ("testOrderBySimple", testOrderBySimple),
        ("testOrderByWithNulls", testOrderByWithNulls),
        ("testOrderByDirection", testOrderByDirection)
    ]
}
