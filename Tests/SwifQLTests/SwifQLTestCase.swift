import XCTest
@testable import SwifQL

class SwifQLTestCase: XCTestCase {
    struct DeletedSchema: Schemable {
        static var schemaName: String { "deleted" }
    }
    
    struct SchemableCarBrands: Table, Schemable {
        static var tableName: String { "CarBrands" }
        
        @Column("id")
        var id: UUID
        @Column("name")
        var name: String
        @Column("createdAt")
        var createdAt: Date
        
        init() {}
    }
    
    struct CarBrands: Table {
        @Column("id")
        var id: UUID
        @Column("name")
        var name: String
        @Column("createdAt")
        var createdAt: Date
        
        init() {}
    }
    
    let cb = CarBrands.as("cb")
    
    struct QueryWithDialect {
        let dialect: SQLDialect
        let query: String
        
        static func psql(_ query: String) -> Self {
            .init(dialect: .psql, query: query)
        }
        
        static func mysql(_ query: String) -> Self {
            .init(dialect: .mysql, query: query)
        }
    }
    
    func check(_ query: SwifQLable, _ dialects: QueryWithDialect...) {
        dialects.forEach {
            XCTAssertEqual(query.prepare($0.dialect).plain, $0.query)
        }
    }
    
    func check(_ query: SwifQLable, all rawQuery: String) {
        SQLDialect.all.forEach {
            XCTAssertEqual(query.prepare($0).plain, rawQuery)
        }
    }
}
