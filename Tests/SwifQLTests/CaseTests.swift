import XCTest
@testable import SwifQL

final class CaseTests: SwifQLTestCase {
    // MARK: - Case When Then Else
    
    func testCaseWhenThenElse1() {
        check(
            Case
                .when(CarBrands.column("name") == "BMW")
            .then("Crazy driver")
                .when(CarBrands.column("name") == "Tesla")
            .then("Fancy driver")
                .else("Normal driver")
            .end,
            .psql(#"CASE WHEN "CarBrands"."name" = 'BMW' THEN 'Crazy driver' WHEN "CarBrands"."name" = 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END"#),
            .mysql("CASE WHEN CarBrands.name = 'BMW' THEN 'Crazy driver' WHEN CarBrands.name = 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END")
        )
    }
    
    func testCaseWhenThenElse2() {
        check(
            Case(CarBrands.column("name"))
                .when("BMW")
            .then("Crazy driver")
                .when("Tesla")
            .then("Fancy driver")
                .else("Normal driver")
            .end,
            .psql(#"CASE "CarBrands"."name" WHEN 'BMW' THEN 'Crazy driver' WHEN 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END"#),
            .mysql("CASE CarBrands.name WHEN 'BMW' THEN 'Crazy driver' WHEN 'Tesla' THEN 'Fancy driver' ELSE 'Normal driver' END")
        )
    }
    
    static var allTests = [
        ("testCaseWhenThenElse1", testCaseWhenThenElse1),
        ("testCaseWhenThenElse2", testCaseWhenThenElse2)
    ]
}
