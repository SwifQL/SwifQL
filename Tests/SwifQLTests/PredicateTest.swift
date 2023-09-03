//
//  PredicateTest.swift
//  
//
//  Created by Tierra Cero on 9/3/23.
//

import XCTest
@testable import SwifQL

final class PredicateTest: SwifQLTestCase {
    
    // MARK: - Greater Than (Number)
    
    func testGreaterThan() {
        check(
            SwifQL.where(\CarBrandReferences.$score > 10),
            .psql(#"WHERE "CarBrandReferences"."score" > 10"#),
            .mysql("WHERE CarBrandReferences.score > 10")
        )
    }
    
    // MARK: - Less Than (Number)
    
    func testLessThan() {
        check(
            SwifQL.where(\CarBrandReferences.$score < 10),
            .psql(#"WHERE "CarBrandReferences"."score" < 10"#),
            .mysql("WHERE CarBrandReferences.score < 10")
        )
    }
    
    // MARK: - Greater Than Or Equal (Number)
    
    func testGreaterThanOrEqual() {
        check(
            SwifQL.where(\CarBrandReferences.$score >= 10),
            .psql(#"WHERE "CarBrandReferences"."score" >= 10"#),
            .mysql("WHERE CarBrandReferences.score >= 10")
        )
    }
    
    // MARK: - Less Than Or Equal (Number)
    
    func testLessThanOrEqual() {
        check(
            SwifQL.where(\CarBrandReferences.$score <= 10),
            .psql(#"WHERE "CarBrandReferences"."score" <= 10"#),
            .mysql("WHERE CarBrandReferences.score <= 10")
        )
    }
    
    // MARK: - Equal (Number)
    
    func testEqualNumber() {
        check(
            SwifQL.where(\CarBrandReferences.$score == 10),
            .psql(#"WHERE "CarBrandReferences"."score" = 10"#),
            .mysql("WHERE CarBrandReferences.score = 10")
        )
    }
    
    // MARK: - Equal (String)
    
    func testEqualString() {
        check(
            SwifQL.where(\CarBrandReferences.$model == "x001"),
            .psql(#"WHERE "CarBrandReferences"."model" = 'x001'"#),
            .mysql("WHERE CarBrandReferences.model = 'x001'")
        )
    }
    
    // MARK: - Equal (Boolean)
    
    func testEqualBoolean() {
        check(
            SwifQL.where(\CarBrandReferences.$available == true),
            .psql(#"WHERE "CarBrandReferences"."available" = TRUE"#),
            .mysql("WHERE CarBrandReferences.available = TRUE")
        )
    }

    // MARK: - Equal (Enum)
    
    func testEqualAType() {
        check(
            SwifQL.where(\CarBrandReferences.$mainGers == GearboxType.manual),
            .psql(#"WHERE "CarBrandReferences"."mainGers" = 'manual'"#),
            .mysql("WHERE CarBrandReferences.mainGers = 'manual'")
        )
    }
    
    // MARK: - Equal (Null)
    
    func testEqualNULL() {
        check(
            SwifQL.where(\CarBrandReferences.$model == nil),
            .psql(#"WHERE "CarBrandReferences"."model" IS NULL"#),
            .mysql("WHERE CarBrandReferences.model IS NULL")
        )
    }
    
    // MARK: - Not Equal (Number)
    
    func testNotEqualNumber() {
        check(
            SwifQL.where(\CarBrandReferences.$score != 10),
            .psql(#"WHERE "CarBrandReferences"."score" != 10"#),
            .mysql("WHERE CarBrandReferences.score != 10")
        )
    }
    
    // MARK: - Not Equal (String)
    
    func testNotEqualString() {
        check(
            SwifQL.where(\CarBrandReferences.$model != "x001"),
            .psql(#"WHERE "CarBrandReferences"."model" != 'x001'"#),
            .mysql("WHERE CarBrandReferences.model != 'x001'")
        )
    }
    
    // MARK: - Not Equal (Boolean)
    
    func testNotEqualBoolean() {
        check(
            SwifQL.where(\CarBrandReferences.$available != true),
            .psql(#"WHERE "CarBrandReferences"."available" != TRUE"#),
            .mysql("WHERE CarBrandReferences.available != TRUE")
        )
    }
    
    // MARK: - Not Equal (Enum)

    func testNotEqualAType() {
        check(
            SwifQL.where(\CarBrandReferences.$mainGers != GearboxType.manual),
            .psql(#"WHERE "CarBrandReferences"."mainGers" != 'manual'"#),
            .mysql("WHERE CarBrandReferences.mainGers != 'manual'")
        )
    }
    
    // MARK: - Not Equal (Null)
    
    func testNotEqualNULL() {
        check(
            SwifQL.where(\CarBrandReferences.$model != nil),
            .psql(#"WHERE "CarBrandReferences"."model" IS NOT NULL"#),
            .mysql("WHERE CarBrandReferences.model IS NOT NULL")
        )
    }
    
    // MARK: - Between (Int)
    
    func testBetweenInt () {
        check(
            SwifQL.where(\CarBrandReferences.$score <> 5 && 20),
            .psql(#"WHERE "CarBrandReferences"."score" BETWEEN 5 AND 20"#),
            .mysql("WHERE CarBrandReferences.score BETWEEN 5 AND 20")
        )
    }
    
    // MARK: - Between (String)
    
    func testBetweenString () {
        check(
            SwifQL.where(\CarBrandReferences.$model <> "a" && "t"),
            .psql(#"WHERE "CarBrandReferences"."model" BETWEEN 'a' AND 't'"#),
            .mysql("WHERE CarBrandReferences.model BETWEEN 'a' AND 't'")
        )
    }
    
    // MARK: - Range @> ([Enum])
    
    func testRangeLeftEnum() {
        check(
            SwifQL.where(\CarBrandReferences.$availableGers ||> [GearboxType.manual]),
            .psql(#"WHERE "CarBrandReferences"."availableGers" @> '{manual}'"#)
        )
    }
    
    // MARK: - Range <@ ([Enum])
    
    func testRangeRightEnum() {
        check(
            SwifQL.where(\CarBrandReferences.$availableGers <|| [GearboxType.manual]),
            .psql(#"WHERE "CarBrandReferences"."availableGers" <@ '{manual}'"#)
        )
    }
    
    // MARK: - Range @> ([String])
    
    func testRangeLeftString() {
        check(
            SwifQL.where(\CarBrandReferences.$tags ||> PgArray(["red"])),
            .psql(#"WHERE "CarBrandReferences"."tags" @> ARRAY['red']"#)
        )
    }
    
    // MARK: - Range <@ ([String])
    
    func testRangeRightString() {
        check(
            SwifQL.where(\CarBrandReferences.$tags <|| PgArray(["red"])),
            .psql(#"WHERE "CarBrandReferences"."tags" <@ ARRAY['red']"#)
        )
    }
    
    // MARK: - Range @> ([Int])
    
    func testRangeLeftInt() {
        check(
            SwifQL.where(\CarBrandReferences.$availableYears ||> PgArray([1, 2, 3])),
            .psql(#"WHERE "CarBrandReferences"."availableYears" @> ARRAY[1, 2, 3]"#)
        )
    }
    
    // MARK: - Range <@ ([Int])
    
    func testRangeRightInt() {
        check(
            SwifQL.where(\CarBrandReferences.$availableYears <|| PgArray([1, 2, 3])),
            .psql(#"WHERE "CarBrandReferences"."availableYears" <@ ARRAY[1, 2, 3]"#)
        )
    }
    
    // MARK: - Range @> ([UUID])
    
    func testRangeLeftUUID() {
        check(
            SwifQL.where(\CarBrandReferences.$knowedIssues ||> PgArray([UUID(uuidString: "25afebec-179e-43ff-8c7b-a0a460c7c996")!, UUID(uuidString: "25afebec-179e-43ff-8c7b-a0a460c7c996")!])),
            .psql(#"WHERE "CarBrandReferences"."knowedIssues" @> ARRAY['25AFEBEC-179E-43FF-8C7B-A0A460C7C996', '25AFEBEC-179E-43FF-8C7B-A0A460C7C996']"#)
        )
    }
    
    // MARK: - Range <@ ([UUID])
    
    func testRangeRightUUID() {
        check(
            SwifQL.where(\CarBrandReferences.$knowedIssues <|| PgArray([UUID(uuidString: "25afebec-179e-43ff-8c7b-a0a460c7c996")!, UUID(uuidString: "25afebec-179e-43ff-8c7b-a0a460c7c996")!])),
            .psql(#"WHERE "CarBrandReferences"."knowedIssues" <@ ARRAY['25AFEBEC-179E-43FF-8C7B-A0A460C7C996', '25AFEBEC-179E-43FF-8C7B-A0A460C7C996']"#)
        )
    }
    
    
    static var allTests = [
        ("testGreaterThan", testGreaterThan),
        ("testLessThan", testLessThan),
        ("testGreaterThanOrEqual", testGreaterThanOrEqual),
        ("testLessThanOrEqual", testLessThanOrEqual),
        ("testEqualNumber", testEqualNumber),
        ("testEqualString", testEqualString),
        ("testEqualBoolean", testEqualBoolean),
        ("testEqualAType", testEqualAType),
        ("testEqualNULL", testEqualNULL),
        ("testNotEqualNumber", testNotEqualNumber),
        ("testNotEqualString", testNotEqualString),
        ("testNotEqualBoolean", testNotEqualBoolean),
        ("testNotEqualAType", testNotEqualAType),
        ("testNotEqualNULL", testNotEqualNULL),
        ("testBetweenInt", testBetweenInt),
        ("testBetweenString", testBetweenString),
        ("testRangeLeftEnum", testRangeLeftEnum),
        ("testRangeRightEnum", testRangeLeftString),
        ("testRangeLeftString", testRangeLeftString),
        ("testRangeRightString", testRangeRightString),
        ("testRangeLeftInt", testRangeLeftInt),
        ("testRangeRightInt", testRangeRightInt),
        ("testRangeLeftUUID", testRangeLeftUUID),
        ("testRangeRightUUID", testRangeRightUUID)
    ]
    
}
