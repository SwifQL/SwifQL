import XCTest
@testable import SwifQL

final class SchemaTests: SwifQLTestCase {
    struct CarBrandss: Codable, Tableable {
        static let schemaName: String? = "custom"
        
        var id: UUID
        var name: String
        var createdAt: Date
    }
    
    func testSchema() {
        let query = SwifQL.select(CarBrandss.table.*).from(CarBrandss.table)
        
        checkAllDialects(query, pg: """
            SELECT "custom"."CarBrandss".* FROM "custom"."CarBrandss"
            """, mySQL: """
            SELECT CarBrandss.* FROM CarBrandss
            """)
    }
    
    static var allTests = [
        ("testSchema", testSchema)
    ]
}
