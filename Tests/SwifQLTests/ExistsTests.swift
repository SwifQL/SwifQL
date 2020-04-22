import XCTest
@testable import SwifQL

final class ExistsTests: SwifQLTestCase {
    //MARK: - EXISTS
    
    func testExists() {
        check(
            SwifQL.exists(1),
            .psql("EXISTS (1)"),
            .mysql("EXISTS (1)")
        )
    }
    
    //MARK: - NOT EXISTS
    
    func testNotExists() {
        check(
            SwifQL.notExists(1),
            .psql("NOT EXISTS (1)"),
            .mysql("NOT EXISTS (1)")
        )
    }
    
    //MARK: - WHERE EXISTS
    
    func testWhereExists() {
        check(
            SwifQL.whereExists(1),
            .psql("WHERE EXISTS (1)"),
            .mysql("WHERE EXISTS (1)")
        )
    }
    
    //MARK: - WHERE NOT EXISTS
    
    func testWhereNotExists() {
        check(
            SwifQL.whereNotExists(1),
            .psql("WHERE NOT EXISTS (1)"),
            .mysql("WHERE NOT EXISTS (1)")
        )
    }
    
    static var allTests = [
        ("testExists", testExists),
        ("testNotExists", testNotExists),
        ("testWhereExists", testWhereExists),
        ("testWhereNotExists", testWhereNotExists)
    ]
}
