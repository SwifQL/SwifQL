import XCTest
@testable import SwifQL

final class OrderTests: SwifQLTestCase {
    // MARK: - Order by simple
    
    func testOrderBySimple() {
        check(
            SwifQL.orderBy(.asc(CarBrands.column("name")), .desc(CarBrands.column("id"))),
            .psql(#"ORDER BY "CarBrands"."name" ASC, "CarBrands"."id" DESC"#),
            .mysql("ORDER BY CarBrands.name ASC, CarBrands.id DESC")
        )
    }
    
    // MARK: - Order by with nulls
    
    func testOrderByWithNulls() {
        check(
            SwifQL.orderBy(.asc(CarBrands.column("name"), nulls: .first), .desc(CarBrands.column("id"), nulls: .last)),
            .psql(#"ORDER BY "CarBrands"."name" ASC NULLS FIRST, "CarBrands"."id" DESC NULLS LAST"#)
        )
        check(
            SwifQL.orderBy(.asc(CarBrands.column("name") == nil, CarBrands.column("name")), .desc(CarBrands.column("id") != nil, CarBrands.column("id"))),
            .mysql("ORDER BY CarBrands.name IS NULL, CarBrands.name ASC, CarBrands.id IS NOT NULL, CarBrands.id DESC")
        )
    }
    
    // MARK: - Order by with direction
    
    func testOrderByDirection() {
        check(
            SwifQL.orderBy(.direction(.asc, CarBrands.column("name"), nulls: .last)),
            .psql(#"ORDER BY "CarBrands"."name" ASC NULLS LAST"#)
        )
        check(
            SwifQL.orderBy(.direction(.desc, CarBrands.column("id"), nulls: .first)),
            .mysql("ORDER BY CarBrands.id DESC NULLS FIRST")
        )
    }
    
    static var allTests = [
        ("testOrderBySimple", testOrderBySimple),
        ("testOrderByWithNulls", testOrderByWithNulls),
        ("testOrderByDirection", testOrderByDirection)
    ]
}
