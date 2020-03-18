import XCTest
@testable import SwifQL

final class CaseTests: SwifQLTestCase {
    // MARK: - Case When Then Else
    
    func testCaseWhenThenElse1() {
        let query = Case
            .when(CarBrands.column("name") == "BMW")
            .then("Crazy driver")
            .when(CarBrands.column("name") == "Tesla")
            .then("Fancy driver")
            .else("Normal driver")
            .end
        let pg = """
        CASE WHEN "CarBrands"."name" = 'BMW' THEN 'Crazy driver' WHEN "CarBrands"."name" = 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END
        """
        let mySQL = """
        CASE WHEN CarBrands.name = 'BMW' THEN 'Crazy driver' WHEN CarBrands.name = 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    func testCaseWhenThenElse2() {
        let query = Case(CarBrands.column("name"))
            .when("BMW")
            .then("Crazy driver")
            .when("Tesla")
            .then("Fancy driver")
            .else("Normal driver")
            .end
        let pg = """
        CASE "CarBrands"."name" WHEN 'BMW' THEN 'Crazy driver' WHEN 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END
        """
        let mySQL = """
        CASE CarBrands.name WHEN 'BMW' THEN 'Crazy driver' WHEN 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    static var allTests = [
        ("testCaseWhenThenElse1", testCaseWhenThenElse1),
        ("testCaseWhenThenElse2", testCaseWhenThenElse2)
    ]
}
