import XCTest
@testable import SwifQL

final class BuilderTests: SwifQLTestCase {
    func testSelectBuilderLimitShort() {
        let builder = SwifQLSelectBuilder()
        let query = builder.select(CarBrands.table.*).from(CarBrands.table).limit(0, 10).build()
        check(
            query,
            .psql(#"SELECT "CarBrands".* FROM "CarBrands" LIMIT 10 OFFSET 0"#),
            .mysql("SELECT CarBrands.* FROM CarBrands LIMIT 10 OFFSET 0")
        )
    }
    
    func testSelectBuilderCopy() {
        let builder = SwifQLSelectBuilder()
        builder.select(CarBrands.table.*).from(CarBrands.table).join(.left, CarBrands.table, on: "id1 = id2").where("item1 = item2").groupBy("item1").limit(10).offset(20).having("count > 10").orderBy(.asc("item1"))
        
        let copy = builder.copy()
        let prepareBuildMySQL = builder.build().prepare(.mysql).plain
        let prepareCopyMySQL = copy.build().prepare(.mysql).plain
        
        XCTAssertEqual(prepareBuildMySQL , prepareCopyMySQL)
        
        let prepareBuildPSQL = builder.build().prepare(.psql).plain
        let prepareCopyPSQL = copy.build().prepare(.psql).plain
        
        XCTAssertEqual(prepareBuildPSQL , prepareCopyPSQL)
    }
    
    static var allTests = [
        ("testSelectBuilderLimitShort", testSelectBuilderLimitShort),
        ("testSelectBuilderCopy", testSelectBuilderCopy)
    ]
}
