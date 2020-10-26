import XCTest
@testable import SwifQL

class SwifQLTestCase: XCTestCase {
    struct DeletedSchema: Schemable {
        static var schemaName: String { "deleted" }
    }
    
    enum GearboxType: String, SwifQLEnum {
        case manual, auto, cvt
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
        let plainQuery: String
        let bindedQuery: String?
        
        static func psql(_ plainQuery: String, _ bindedQuery: String? = nil) -> Self {
            .init(dialect: .psql, plainQuery: plainQuery, bindedQuery: bindedQuery)
        }
        
        static func mysql(_ plainQuery: String, _ bindedQuery: String? = nil) -> Self {
            .init(dialect: .mysql, plainQuery: plainQuery, bindedQuery: bindedQuery)
        }
    }
    
    func check(_ query: SwifQLable, _ dialects: QueryWithDialect...) {
        dialects.forEach {
            XCTAssertEqual(query.prepare($0.dialect).plain, $0.plainQuery)
            if let bindedQuery = $0.bindedQuery {
                let prepared = query.prepare($0.dialect)
                let splitted = prepared.splitted
                XCTAssertEqual(splitted.query, bindedQuery)
            }
        }
    }
    
    func check(_ query: SwifQLable, all rawQuery: String) {
        SQLDialect.all.forEach {
            XCTAssertEqual(query.prepare($0).plain, rawQuery)
        }
    }
}
