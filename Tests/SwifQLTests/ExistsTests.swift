import XCTest
@testable import SwifQL

final class ExistsTests: SwifQLTestCase {
    //MARK: - EXISTS
    
    func testExists() {
        checkAllDialects(SwifQL.exists(1), pg: """
        EXISTS (1)
        """, mySQL: """
        EXISTS (1)
        """)
    }
    
    //MARK: - NOT EXISTS
    
    func testNotExists() {
        checkAllDialects(SwifQL.notExists(1), pg: """
        NOT EXISTS (1)
        """, mySQL: """
        NOT EXISTS (1)
        """)
    }
    
    //MARK: - WHERE EXISTS
    
    func testWhereExists() {
        checkAllDialects(SwifQL.whereExists(1), pg: """
        WHERE EXISTS (1)
        """, mySQL: """
        WHERE EXISTS (1)
        """)
    }
    
    //MARK: - WHERE NOT EXISTS
    
    func testWhereNotExists() {
        checkAllDialects(SwifQL.whereNotExists(1), pg: """
        WHERE NOT EXISTS (1)
        """, mySQL: """
        WHERE NOT EXISTS (1)
        """)
    }
    
    static var allTests = [
        ("testExists", testExists),
        ("testNotExists", testNotExists),
        ("testWhereExists", testWhereExists),
        ("testWhereNotExists", testWhereNotExists)
    ]
}
