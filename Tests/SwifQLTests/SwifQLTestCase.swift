import XCTest
@testable import SwifQL

class SwifQLTestCase: XCTestCase {
    struct DeletedSchema: Schemable {
        static var schemaName: String { "deleted" }
    }
    
    struct SchemableCarBrands: Codable, Tableable, Schemable {
        static var tableName: String { "CarBrands" }
        
        var id: UUID
        var name: String
        var createdAt: Date
    }
    
    struct CarBrands: Codable, Tableable {
        var id: UUID
        var name: String
        var createdAt: Date
    }
    
    let cb = CarBrands.as("cb")
    
    func checkAllDialects(_ query: SwifQLable, pg: String? = nil, mySQL: String? = nil) {
        if let pg = pg {
            XCTAssertEqual(query.prepare(.psql).plain, pg)
        }
        if let mySQL = mySQL {
            XCTAssertEqual(query.prepare(.mysql).plain, mySQL)
        }
    }
}
