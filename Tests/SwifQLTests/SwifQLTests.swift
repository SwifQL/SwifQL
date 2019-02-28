import XCTest
@testable import SwifQL
@testable import SwifQLPure

final class SwifQLTests: XCTestCase {
    struct CarBrands: Codable, Reflectable {
        var id: UUID
        var name: String
        var createdAt: Date
    }
    
    let cb = CarBrands.as("cb")
    
    func checkAllDialects(_ query: SwifQLable, pg: String, mySQL: String) {
        XCTAssertEqual(query.prepare(.psql).plain, pg)
        XCTAssertEqual(query.prepare(.mysql).plain, mySQL)
    }
    
    func testSelect() {
        checkAllDialects(SwifQL.select(), pg: "SELECT ", mySQL: "SELECT ")
    }
    
    func testSelectString() {
        checkAllDialects(SwifQL.select("hello"), pg: "SELECT 'hello'", mySQL: "SELECT 'hello'")
    }
    
    func testSelectInt() {
        checkAllDialects(SwifQL.select(1), pg: "SELECT 1", mySQL: "SELECT 1")
    }
    
    func testSelectDouble() {
        checkAllDialects(SwifQL.select(1.234), pg: "SELECT 1.234", mySQL: "SELECT 1.234")
    }
    
    func testSelectSeveralSimpleValues() {
        checkAllDialects(SwifQL.select("hello", 1, 1.234), pg: "SELECT 'hello', 1, 1.234", mySQL: "SELECT 'hello', 1, 1.234")
    }
    
    func testSelectCarBrands() {
        checkAllDialects(SwifQL.select(\CarBrands.id), pg: """
            SELECT "CarBrands"."id"
            """, mySQL: """
            SELECT CarBrands.id
            """)
    }
    
    func testSelectCarBrandsSeveralFields() {
        checkAllDialects(SwifQL.select(\CarBrands.id, \CarBrands.name), pg: """
            SELECT "CarBrands"."id", "CarBrands"."name"
            """, mySQL: """
            SELECT CarBrands.id, CarBrands.name
            """)
    }
    
    func testSelectCarBrandsWithAlias() {
        checkAllDialects(SwifQL.select(cb~\.id), pg: """
            SELECT "cb"."id"
            """, mySQL: """
            SELECT cb.id
            """)
    }
    
    func testSelectCarBrandsWithAliasSeveralFields() {
        checkAllDialects(SwifQL.select(cb~\.id, cb~\.name), pg: """
            SELECT "cb"."id", "cb"."name"
            """, mySQL: """
            SELECT cb.id, cb.name
            """)
    }
    
    func testSelectCarBrandsSeveralFieldsMixed() {
        checkAllDialects(SwifQL.select(\CarBrands.id, cb~\.name, \CarBrands.createdAt), pg: """
            SELECT "CarBrands"."id", "cb"."name", "CarBrands"."createdAt"
            """, mySQL: """
            SELECT CarBrands.id, cb.name, CarBrands.createdAt
            """)
    }
    
    //MARK: PostgreSQL Functions
    
    func testSelectFnAbs() {
        checkAllDialects(SwifQL.select(Fn.abs(1)), pg: "SELECT abs(1)", mySQL: "SELECT abs(1)")
    }
    
    func testSelectFnAvg() {
        checkAllDialects(SwifQL.select(Fn.avg(1)), pg: "SELECT avg(1)", mySQL: "SELECT avg(1)")
    }
    
    func testSelectFnBitLength() {
        checkAllDialects(SwifQL.select(Fn.bit_length("hello")), pg: "SELECT bit_length('hello')", mySQL: "SELECT bit_length('hello')")
    }
    
    func testSelectFnBtrim() {
        checkAllDialects(SwifQL.select(Fn.btrim("hello", "ll")), pg: "SELECT btrim('hello', 'll')", mySQL: "SELECT btrim('hello', 'll')")
    }
    
    func testSelectFnCeil() {
        checkAllDialects(SwifQL.select(Fn.ceil(1.5)), pg: "SELECT ceil(1.5)", mySQL: "SELECT ceil(1.5)")
    }
    
    func testSelectFnCeiling() {
        checkAllDialects(SwifQL.select(Fn.ceiling(1.5)), pg: "SELECT ceiling(1.5)", mySQL: "SELECT ceiling(1.5)")
    }
    
    func testSelectFnCharLength() {
        checkAllDialects(SwifQL.select(Fn.char_length("hello")), pg: "SELECT char_length('hello')", mySQL: "SELECT char_length('hello')")
    }
    
    func testSelectFnCharacter_length() {
        checkAllDialects(SwifQL.select(Fn.character_length("hello")), pg: "SELECT character_length('hello')", mySQL: "SELECT character_length('hello')")
    }
    
    func testSelectFnInitcap() {
        checkAllDialects(SwifQL.select(Fn.initcap("hello")), pg: "SELECT initcap('hello')", mySQL: "SELECT initcap('hello')")
    }
    
    func testSelectFnLength() {
        checkAllDialects(SwifQL.select(Fn.length("hello")), pg: "SELECT length('hello')", mySQL: "SELECT length('hello')")
    }
    
    func testSelectFnLower() {
        checkAllDialects(SwifQL.select(Fn.lower("hello")), pg: "SELECT lower('hello')", mySQL: "SELECT lower('hello')")
    }
    
    func testSelectFnLpad() {
        checkAllDialects(SwifQL.select(Fn.lpad("hello", 3, "lo")), pg: "SELECT lpad('hello', 3, 'lo')", mySQL: "SELECT lpad('hello', 3, 'lo')")
    }
    
    func testSelectFnLtrim() {
        checkAllDialects(SwifQL.select(Fn.ltrim("hello", "he")), pg: "SELECT ltrim('hello', 'he')", mySQL: "SELECT ltrim('hello', 'he')")
    }
    
    func testSelectFnPosition() {
        checkAllDialects(SwifQL.select(Fn.position("el", in: "hello")), pg: "SELECT position('el' IN 'hello')", mySQL: "SELECT position('el' IN 'hello')")
    }
    
    func testSelectFnRepeat() {
        checkAllDialects(SwifQL.select(Fn.repeat("hello", 2)), pg: "SELECT repeat('hello', 2)", mySQL: "SELECT repeat('hello', 2)")
    }
    
    func testSelectFnReplace() {
        checkAllDialects(SwifQL.select(Fn.replace("hello", "el", "ol")), pg: "SELECT replace('hello', 'el', 'ol')", mySQL: "SELECT replace('hello', 'el', 'ol')")
    }
    
    func testSelectFnRpad() {
        checkAllDialects(SwifQL.select(Fn.rpad("hello", 2, "ho")), pg: "SELECT rpad('hello', 2, 'ho')", mySQL: "SELECT rpad('hello', 2, 'ho')")
    }
    
    func testSelectFnRtrim() {
        checkAllDialects(SwifQL.select(Fn.rtrim(" hello ", " ")), pg: "SELECT rtrim(' hello ', ' ')", mySQL: "SELECT rtrim(' hello ', ' ')")
    }
    
    func testSelectFnStrpos() {
        checkAllDialects(SwifQL.select(Fn.strpos("hello", "ll")), pg: "SELECT strpos('hello', 'll')", mySQL: "SELECT strpos('hello', 'll')")
    }
    
    func testSelectFnSubstring() {
        checkAllDialects(SwifQL.select(Fn.substring("hello", from: 1)), pg: "SELECT substring('hello' FROM 1)", mySQL: "SELECT substring('hello' FROM 1)")
        checkAllDialects(SwifQL.select(Fn.substring("hello", for: 4)), pg: "SELECT substring('hello' FOR 4)", mySQL: "SELECT substring('hello' FOR 4)")
        checkAllDialects(SwifQL.select(Fn.substring("hello", from: 1, for: 4)), pg: "SELECT substring('hello' FROM 1 FOR 4)", mySQL: "SELECT substring('hello' FROM 1 FOR 4)")
    }
    
    func testSelectFnTranslate() {
        checkAllDialects(SwifQL.select(Fn.translate("hola", "hola", "hello")), pg: "SELECT translate('hola', 'hola', 'hello')", mySQL: "SELECT translate('hola', 'hola', 'hello')")
    }
    
    func testSelectFnLTrim() {
        checkAllDialects(SwifQL.select(Fn.ltrim("hello", "he")), pg: "SELECT ltrim('hello', 'he')", mySQL: "SELECT ltrim('hello', 'he')")
    }
    
    func testSelectFnUpper() {
        checkAllDialects(SwifQL.select(Fn.upper("hello")), pg: "SELECT upper('hello')", mySQL: "SELECT upper('hello')")
    }
    
    func testSelectFnCount() {
        checkAllDialects(SwifQL.select(Fn.count(\CarBrands.id)), pg: """
            SELECT count("CarBrands"."id")
            """, mySQL: """
            SELECT count(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.count(cb~\.id)), pg: """
            SELECT count("cb"."id")
            """, mySQL: """
            SELECT count(cb.id)
            """)
    }
    
    func testSelectFnDiv() {
        checkAllDialects(SwifQL.select(Fn.div(12, 4)), pg: "SELECT div(12, 4)", mySQL: "SELECT div(12, 4)")
    }
    
    func testSelectFnExp() {
        checkAllDialects(SwifQL.select(Fn.exp(12, 4)), pg: "SELECT exp(12, 4)", mySQL: "SELECT exp(12, 4)")
    }
    
    func testSelectFnFloor() {
        checkAllDialects(SwifQL.select(Fn.floor(12)), pg: "SELECT floor(12)", mySQL: "SELECT floor(12)")
    }
    
    func testSelectFnMax() {
        checkAllDialects(SwifQL.select(Fn.max(\CarBrands.id)), pg: """
            SELECT max("CarBrands"."id")
            """, mySQL: """
            SELECT max(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.max(cb~\.id)), pg: """
            SELECT max("cb"."id")
            """, mySQL: """
            SELECT max(cb.id)
            """)
    }
    
    func testSelectFnMin() {
        checkAllDialects(SwifQL.select(Fn.min(\CarBrands.id)), pg: """
            SELECT min("CarBrands"."id")
            """, mySQL: """
            SELECT min(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.min(cb~\.id)), pg: """
            SELECT min("cb"."id")
            """, mySQL: """
            SELECT min(cb.id)
            """)
    }
    
    func testSelectFnMod() {
        checkAllDialects(SwifQL.select(Fn.mod(12, 4)), pg: "SELECT mod(12, 4)", mySQL: "SELECT mod(12, 4)")
    }
    
    func testSelectFnPower() {
        checkAllDialects(SwifQL.select(Fn.power(12, 4)), pg: "SELECT power(12, 4)", mySQL: "SELECT power(12, 4)")
    }
    
    func testSelectFnRandom() {
        checkAllDialects(SwifQL.select(Fn.random()), pg: "SELECT random()", mySQL: "SELECT random()")
    }
    
    func testSelectFnRound() {
        checkAllDialects(SwifQL.select(Fn.round(12.43)), pg: "SELECT round(12.43)", mySQL: "SELECT round(12.43)")
        checkAllDialects(SwifQL.select(Fn.round(12.43, 1)), pg: "SELECT round(12.43, 1)", mySQL: "SELECT round(12.43, 1)")
    }
    
    func testSelectFnSetSeed() {
        checkAllDialects(SwifQL.select(Fn.setseed(12)), pg: "SELECT setseed(12)", mySQL: "SELECT setseed(12)")
    }
    
    func testSelectFnSign() {
        checkAllDialects(SwifQL.select(Fn.sign(12)), pg: "SELECT sign(12)", mySQL: "SELECT sign(12)")
    }
    
    func testSelectFnSqrt() {
        checkAllDialects(SwifQL.select(Fn.sqrt(16)), pg: "SELECT sqrt(16)", mySQL: "SELECT sqrt(16)")
    }
    
    func testSelectFnSum() {
        checkAllDialects(SwifQL.select(Fn.sum(\CarBrands.id)), pg: """
            SELECT sum("CarBrands"."id")
            """, mySQL: """
            SELECT sum(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.sum(cb~\.id)), pg: """
            SELECT sum("cb"."id")
            """, mySQL: """
            SELECT sum(cb.id)
            """)
    }
    
    //MARK: - FROM
    
    func testSelectFrom() {
        checkAllDialects(SwifQL.select(1).from(), pg: "SELECT 1 FROM ", mySQL: "SELECT 1 FROM ")
    }
    
    func testFrom() {
        checkAllDialects(SwifQL.from(), pg: "FROM ", mySQL: "FROM ")
    }
    
    func testFromOneTable() {
        checkAllDialects(SwifQL.from(CarBrands.table), pg: """
            FROM "CarBrands"
            """, mySQL: """
            FROM CarBrands
            """)
    }
    
    func testFromTwoTables() {
        checkAllDialects(SwifQL.from(CarBrands.table, CarBrands.table), pg: """
            FROM "CarBrands", "CarBrands"
            """, mySQL: """
            FROM CarBrands, CarBrands
            """)
    }
    
    func testFromOneTableAlias() {
        checkAllDialects(SwifQL.from(cb), pg: """
            FROM "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb
            """)
    }
    
    func testFromTwoTableAliases() {
        checkAllDialects(SwifQL.from(cb, cb), pg: """
            FROM "CarBrands" AS "cb", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb, CarBrands AS cb
            """)
    }
    
    func testFromTableAndTableAlias() {
        checkAllDialects(SwifQL.from(CarBrands.table, cb), pg: """
            FROM "CarBrands", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands, CarBrands AS cb
            """)
    }
    
    //MARK: - WHERE
    
    func testWhere() {
        checkAllDialects(SwifQL.where("" == 1), pg: "WHERE '' = 1", mySQL: "WHERE '' = 1")
    }
    
    //MARK: - UNION
    
    //MARK: - INSERT INTO
    
    func testInsertInto() {
        checkAllDialects(SwifQL.insertInto(CarBrands.table, fields: \CarBrands.id), pg: """
        INSERT INTO "CarBrands" ("id")
        """, mySQL: """
        INSERT INTO CarBrands (id)
        """)
        checkAllDialects(SwifQL.insertInto(CarBrands.table, fields: \CarBrands.id, \CarBrands.name, \CarBrands.createdAt), pg: """
        INSERT INTO "CarBrands" ("id", "name", "createdAt")
        """, mySQL: """
        INSERT INTO CarBrands (id, name, createdAt)
        """)
        checkAllDialects(SwifQL.insertInto(cb, fields: cb~\.id), pg: """
        INSERT INTO "CarBrands" AS "cb" ("id")
        """, mySQL: """
        INSERT INTO CarBrands AS cb (id)
        """)
        checkAllDialects(SwifQL.insertInto(cb, fields: cb~\.id, cb~\.name, cb~\.createdAt), pg: """
        INSERT INTO "CarBrands" AS "cb" ("id", "name", "createdAt")
        """, mySQL: """
        INSERT INTO CarBrands AS cb (id, name, createdAt)
        """)
        checkAllDialects(SwifQL.insertInto(cb, fields: \CarBrands.id, cb~\.name, \CarBrands.createdAt), pg: """
        INSERT INTO "CarBrands" AS "cb" ("id", "name", "createdAt")
        """, mySQL: """
        INSERT INTO CarBrands AS cb (id, name, createdAt)
        """)
    }
    
    //MARK: - VALUES
    
    func testValues() {
        checkAllDialects(SwifQL.values(1, 1.2, 1.234, "hello"), pg: """
        VALUES (1, 1.2, 1.234, 'hello')
        """, mySQL: """
        VALUES (1, 1.2, 1.234, 'hello')
        """)
        checkAllDialects(SwifQL.values(array: [1, 1.2, 1.234, "hello"], [2, 2.3, 2.345, "bye"]), pg: """
        VALUES (1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')
        """, mySQL: """
        VALUES (1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')
        """)
    }

    static var allTests = [
        ("testPureSelect", testSelect),
        ("testSimpleString", testSelectString),
        ("testSelectInt", testSelectInt),
        ("testSelectDouble", testSelectDouble),
        ("testSelectSeveralSimpleValues", testSelectSeveralSimpleValues),
        ("testSelectCarBrands", testSelectCarBrands),
        ("testSelectCarBrandsSeveralFields", testSelectCarBrandsSeveralFields),
        ("testSelectCarBrandsWithAlias", testSelectCarBrandsWithAlias),
        ("testSelectCarBrandsWithAliasSeveralFields", testSelectCarBrandsWithAliasSeveralFields),
        ("testSelectCarBrandsSeveralFieldsMixed", testSelectCarBrandsSeveralFieldsMixed),
        ("testSelectFnAvg", testSelectFnAvg),
        ("testSelectFnBitLength", testSelectFnBitLength),
        ("testSelectFnBtrim", testSelectFnBtrim),
        ("testSelectFnCeil", testSelectFnCeil),
        ("testSelectFnCeiling", testSelectFnCeiling),
        ("testSelectFnCharLength", testSelectFnCharLength),
        ("testSelectFnCharacter_length", testSelectFnCharacter_length),
        ("testSelectFnInitcap", testSelectFnInitcap),
        ("testSelectFnLength", testSelectFnLength),
        ("testSelectFnLower", testSelectFnLower),
        ("testSelectFnLpad", testSelectFnLpad),
        ("testSelectFnLtrim", testSelectFnLtrim),
        ("testSelectFnPosition", testSelectFnPosition),
        ("testSelectFnRepeat", testSelectFnRepeat),
        ("testSelectFnReplace", testSelectFnReplace),
        ("testSelectFnRpad", testSelectFnRpad),
        ("testSelectFnRtrim", testSelectFnRtrim),
        ("testSelectFnStrpos", testSelectFnStrpos),
        ("testSelectFnSubstring", testSelectFnSubstring),
        ("testSelectFnTranslate", testSelectFnTranslate),
        ("testSelectFnLTrim", testSelectFnLTrim),
        ("testSelectFnUpper", testSelectFnUpper),
        ("testSelectFnCount", testSelectFnCount),
        ("testSelectFnDiv", testSelectFnDiv),
        ("testSelectFnExp", testSelectFnExp),
        ("testSelectFnFloor", testSelectFnFloor),
        ("testSelectFnMax", testSelectFnMax),
        ("testSelectFnMin", testSelectFnMin),
        ("testSelectFnMod", testSelectFnMod),
        ("testSelectFnPower", testSelectFnPower),
        ("testSelectFnRandom", testSelectFnRandom),
        ("testSelectFnRound", testSelectFnRound),
        ("testSelectFnSetSeed", testSelectFnSetSeed),
        ("testSelectFnSign", testSelectFnSign),
        ("testSelectFnSqrt", testSelectFnSqrt),
        ("testSelectFnSum", testSelectFnSum),
        ("testSelectFrom", testSelectFrom),
        ("testFrom", testFrom),
        ("testFromOneTable", testFromOneTable),
        ("testFromTwoTables", testFromTwoTables),
        ("testFromOneTableAlias", testFromOneTableAlias),
        ("testFromTwoTableAliases", testFromTwoTableAliases),
        ("testFromTableAndTableAlias", testFromTableAndTableAlias),
    ]
}
