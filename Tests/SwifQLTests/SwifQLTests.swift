import XCTest
@testable import SwifQL

final class SwifQLTests: XCTestCase {
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
    
    func testSelect() {
        checkAllDialects(SwifQL.select(), pg: "SELECT ", mySQL: "SELECT ")
        checkAllDialects(SwifQL.select, pg: "SELECT", mySQL: "SELECT")
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
    
    func testSelectColumn() {
        checkAllDialects(SwifQL.select(Column("id")), pg: """
            SELECT "id"
            """, mySQL: """
            SELECT id
            """)
    }
    
    func testSelectColumnWithTable() {
        checkAllDialects(SwifQL.select(Table("CarBrands").column("id")), pg: """
            SELECT "CarBrands"."id"
            """, mySQL: """
            SELECT CarBrands.id
            """)
    }
    
    func testSelectColumnWithoutTable() {
        checkAllDialects(SwifQL.select(Column("id")), pg: """
            SELECT "id"
            """, mySQL: """
            SELECT id
            """)
    }
    
    func testSelectCarBrands() {
        checkAllDialects(SwifQL.select(CarBrands.column("id")), pg: """
            SELECT "CarBrands"."id"
            """, mySQL: """
            SELECT CarBrands.id
            """)
    }
    
    func testSelectCarBrandsSeveralFields() {
        checkAllDialects(SwifQL.select(CarBrands.column("id"), CarBrands.column("name")), pg: """
            SELECT "CarBrands"."id", "CarBrands"."name"
            """, mySQL: """
            SELECT CarBrands.id, CarBrands.name
            """)
    }
    
    func testSelectCarBrandsWithAlias() {
        checkAllDialects(SwifQL.select(cb.column("id")), pg: """
            SELECT "cb"."id"
            """, mySQL: """
            SELECT cb.id
            """)
    }
    
    func testSelectCarBrandsWithAliasSeveralFields() {
        checkAllDialects(SwifQL.select(cb.column("id"), cb.column("name")), pg: """
            SELECT "cb"."id", "cb"."name"
            """, mySQL: """
            SELECT cb.id, cb.name
            """)
    }
    
    func testSelectCarBrandsSeveralFieldsMixed() {
        checkAllDialects(SwifQL.select(CarBrands.column("id"), cb.column("name"), CarBrands.column("createdAt")), pg: """
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
        checkAllDialects(SwifQL.select(Fn.count(CarBrands.column("id"))), pg: """
            SELECT count("CarBrands"."id")
            """, mySQL: """
            SELECT count(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.count(cb.column("id"))), pg: """
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
        checkAllDialects(SwifQL.select(Fn.max(CarBrands.column("id"))), pg: """
            SELECT max("CarBrands"."id")
            """, mySQL: """
            SELECT max(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.max(cb.column("id"))), pg: """
            SELECT max("cb"."id")
            """, mySQL: """
            SELECT max(cb.id)
            """)
    }
    
    func testSelectFnMin() {
        checkAllDialects(SwifQL.select(Fn.min(CarBrands.column("id"))), pg: """
            SELECT min("CarBrands"."id")
            """, mySQL: """
            SELECT min(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.min(cb.column("id"))), pg: """
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
        checkAllDialects(SwifQL.select(Fn.sum(CarBrands.column("id"))), pg: """
            SELECT sum("CarBrands"."id")
            """, mySQL: """
            SELECT sum(CarBrands.id)
            """)
        checkAllDialects(SwifQL.select(Fn.sum(cb.column("id"))), pg: """
            SELECT sum("cb"."id")
            """, mySQL: """
            SELECT sum(cb.id)
            """)
    }

    func testSelectFnStringAgg() {
        checkAllDialects(SwifQL.select(Fn.string_agg(CarBrands.column("name"), ", ")), pg: """
            SELECT string_agg("CarBrands"."name", ', ')
            """, mySQL: """
            SELECT string_agg(CarBrands.name, ', ')
            """)
    }

    func testSelectFnRegexpReplace() {
        checkAllDialects(SwifQL.select(Fn.regexp_replace("/full/path/to/filename", "^.+/", "")), pg: """
            SELECT regexp_replace('/full/path/to/filename', '^.+/', '')
            """, mySQL: """
            SELECT regexp_replace('/full/path/to/filename', '^.+/', '')
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
        checkAllDialects(SwifQL.from(cb.table), pg: """
            FROM "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb
            """)
    }
    
    func testFromTwoTableAliases() {
        checkAllDialects(SwifQL.from(cb.table, cb.table), pg: """
            FROM "CarBrands" AS "cb", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands AS cb, CarBrands AS cb
            """)
    }
    
    func testFromTableAndTableAlias() {
        checkAllDialects(SwifQL.from(CarBrands.table, cb.table), pg: """
            FROM "CarBrands", "CarBrands" AS "cb"
            """, mySQL: """
            FROM CarBrands, CarBrands AS cb
            """)
    }
    
    func testSelectBuilderLimitShort() {
        let builder = SwifQLSelectBuilder()
        let query = builder.select(CarBrands.table.*).from(CarBrands.table).limit(0, 10).build()
        
        checkAllDialects(query, pg: """
            SELECT "CarBrands".* FROM "CarBrands" LIMIT 10 OFFSET 0
            """, mySQL: """
            SELECT CarBrands.* FROM CarBrands LIMIT 10 OFFSET 0
            """)
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
    
    //MARK: - WHERE
    
    func testWhere() {
        checkAllDialects(SwifQL.where("" == 1), pg: "WHERE '' = 1", mySQL: "WHERE '' = 1")
        checkAllDialects(SwifQL.where, pg: "WHERE", mySQL: "WHERE")
    }
    
    //MARK: - UNION
    func testUnion() {
        let table1 = Table("Table1")
        let table2 = Table("Table2")
        let table3 = Table("Table3")
        
        let sql = Union(
            SwifQL.select(table1.*).from(table1),
            SwifQL.select(table2.*).from(table2),
            SwifQL.select(table3.*).from(table3)
        )
        
        checkAllDialects(sql, pg: """
        (SELECT "Table1".* FROM "Table1") UNION (SELECT "Table2".* FROM "Table2") UNION (SELECT "Table3".* FROM "Table3")
        """, mySQL: """
        (SELECT Table1.* FROM Table1) UNION (SELECT Table2.* FROM Table2) UNION (SELECT Table3.* FROM Table3)
        """)
        
        let adv = SwifQL
            .select(Distinct(Column("uniqueName")) => .text => "name")
            .from(
                Union(
                    SwifQL.select(Distinct(Column("name")) => .text => "uniqueName").from(table1),
                    SwifQL.select(Distinct(Column("name")) => .text => "uniqueName").from(table2)
                )
        )
        
        checkAllDialects(adv, pg: """
        SELECT DISTINCT "uniqueName"::text as "name" FROM (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table1") UNION (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table2")
        """, mySQL: """
        SELECT DISTINCT uniqueName::text as name FROM (SELECT DISTINCT name::text as uniqueName FROM Table1) UNION (SELECT DISTINCT name::text as uniqueName FROM Table2)
        """)
    }
    
    // MARK: - With
    func testWith() {
        let sql = SwifQL
            .with(.init(Table("Table1"), SwifQL.select(Table("Table2").*).from(Table("Table2"))))
            .select(Table("Table1").*)
            .from(Table("Table1"))
        
        checkAllDialects(sql, pg: """
        WITH "Table1" as (SELECT "Table2".* FROM "Table2") SELECT "Table1".* FROM "Table1"
        """, mySQL: """
        WITH Table1 as (SELECT Table2.* FROM Table2) SELECT Table1.* FROM Table1
        """)
    }
    
    func testWithColumns() {
        struct Table1: Codable, Tableable {}
        
        let sql = SwifQL
            .with(
                .init(Table1.table, SwifQL.select(Table1.table.*).from(Table1.table)),
                .init(Table("Table2"), columns: [Column("hi"), Column("there")], SwifQL.select(Table("Table2").*).from(Table("Table2")))
        )
            .select(Table("Table3").*)
            .from(Table("Table3"))
        
        checkAllDialects(sql, pg: """
        WITH "Table1" as (SELECT "Table1".* FROM "Table1"), "Table2" ("hi", "there") as (SELECT "Table2".* FROM "Table2") SELECT "Table3".* FROM "Table3"
        """, mySQL: """
        WITH Table1 as (SELECT Table1.* FROM Table1), Table2 (hi, there) as (SELECT Table2.* FROM Table2) SELECT Table3.* FROM Table3
        """)
    }
    
    //MARK: - INSERT INTO
    
    func testInsertInto() {
        checkAllDialects(SwifQL.insertInto(CarBrands.table, fields: CarBrands.column("id")), pg: """
        INSERT INTO "CarBrands" ("id")
        """, mySQL: """
        INSERT INTO CarBrands (id)
        """)
        checkAllDialects(SwifQL.insertInto(CarBrands.table, fields: CarBrands.column("id"), CarBrands.column("name"), CarBrands.column("createdAt")), pg: """
        INSERT INTO "CarBrands" ("id", "name", "createdAt")
        """, mySQL: """
        INSERT INTO CarBrands (id, name, createdAt)
        """)
        checkAllDialects(SwifQL.insertInto(cb.table, fields: cb.column("id")), pg: """
        INSERT INTO "CarBrands" AS "cb" ("id")
        """, mySQL: """
        INSERT INTO CarBrands AS cb (id)
        """)
        checkAllDialects(SwifQL.insertInto(cb.table, fields: cb.column("id"), cb.column("name"), cb.column("createdAt")), pg: """
        INSERT INTO "CarBrands" AS "cb" ("id", "name", "createdAt")
        """, mySQL: """
        INSERT INTO CarBrands AS cb (id, name, createdAt)
        """)
        checkAllDialects(SwifQL.insertInto(cb.table, fields: CarBrands.column("id"), cb.column("name"), CarBrands.column("createdAt")), pg: """
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
    
    // MARK: - BINDINGS
    
    func testBingingForPostgreSQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.psql).splitted.query
        XCTAssertEqual(query, """
        WHERE "CarBrands"."name" = $1 OR "CarBrands"."name" = $2
        """)
    }
    
    func testBingingForMySQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.mysql).splitted.query
        XCTAssertEqual(query, """
        WHERE CarBrands.name = ? OR CarBrands.name = ?
        """)
    }
    
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
    
    // MARK: - SELECT with alias in select params
    
    func testSelectWithAliasInSelectParams() {
        let query = SwifQL.select("hello", =>"aaa").from(|SwifQL.select(CarBrands.column("name")).from(CarBrands.table))| => "aaa"
        checkAllDialects(query, pg: """
        SELECT 'hello', "aaa" FROM (SELECT "CarBrands"."name" FROM "CarBrands") as "aaa"
        """, mySQL: """
        SELECT 'hello', aaa FROM (SELECT CarBrands.name FROM CarBrands) as aaa
        """)
    }
    
    // MARK: - ON CONFLICT DO NOTHING
    
    func testOnConflict() {
        let query = SwifQL.on.conflict(CarBrands.column("id"), CarBrands.column("name"))
        let pg = """
        ON CONFLICT ("id", "name")
        """
        let mySQL = """
        ON CONFLICT (id, name)
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = query.do.nothing
        checkAllDialects(query2, pg: pg + " DO NOTHING", mySQL: mySQL + " DO NOTHING")
    }
    
    // MARK: - ON CONFLICT ON CONSTRAINT DO NOTHING
    
    func testOnConflictOnConstraintDoNothing() {
        let query = SwifQL.on.conflict.on.constraint("hello_world")
        let pg = """
        ON CONFLICT ON CONSTRAINT "hello_world"
        """
        let mySQL = """
        ON CONFLICT ON CONSTRAINT hello_world
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = query.do.nothing
        checkAllDialects(query2, pg: pg + " DO NOTHING", mySQL: mySQL + " DO NOTHING")
        let query3 = SwifQL.on.conflict.on.constraint(CarBrands.column("name"))
        let pg3 = """
        ON CONFLICT ON CONSTRAINT "name"
        """
        let mySQL3 = """
        ON CONFLICT ON CONSTRAINT name
        """
        checkAllDialects(query3, pg: pg3, mySQL: mySQL3)
    }
    
    // MARK: - DO NOTHING
    
    func testDoNothing() {
        let query = SwifQL.do.nothing
        checkAllDialects(query, pg: """
        DO NOTHING
        """, mySQL: """
        DO NOTHING
        """)
    }
    
    // MARK: - NOT / NOT BETWEEN / BETWEEN
    
    func testNotAndBetween() {
        let query = SwifQL.between(10.and(20))
        let pg = """
        BETWEEN 10 AND 20
        """
        let mySQL = """
        BETWEEN 10 AND 20
        """
        let query2 = SwifQL.between((CarBrands.column("id")).and(CarBrands.column("name")))
        let pg2 = """
        BETWEEN "CarBrands"."id" AND "CarBrands"."name"
        """
        let mySQL2 = """
        BETWEEN CarBrands.id AND CarBrands.name
        """
        let query3 = SwifQL.not(query)
        let pg3 = "NOT " + pg
        let mySQL3 = "NOT " + mySQL
        let query4 = SwifQL.not(query2)
        let pg4 = "NOT " + pg2
        let mySQL4 = "NOT " + mySQL2
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
        checkAllDialects(query3, pg: pg3, mySQL: mySQL3)
        checkAllDialects(query4, pg: pg4, mySQL: mySQL4)
    }
    
    // MARK: - S?UBQUERY WITH ALIAS
    
    func testSubqueryWithAlias() {
        let a = CarBrands.as("a")
        let b = CarBrands.as("b")
        // WRONG EXAMPLE because of `|` postfix operator near `alias1`
        //        let query = SwifQL.select(
        //            a~\.name,
        //            |SwifQL.select(Fn.json_agg(=>"alias1") => "test1" )
        //                .from(
        //                    |SwifQL.select(b~\.name => "someName")
        //                        .from(b.table)
        //                        .where(b~\.id == a~\.id)|
        //                ) => "alias1"|
        //            )
        //            .from(a.table)
        // RIGHT EXAMPLE
        // so use subquery inside brackets or even better move it into variable (it'd be more beautiful and easy to support)
        let query = SwifQL.select(
            a.column("name"),
            |(SwifQL.select(Fn.json_agg(=>"alias1") => "test1")
                .from(
                    |SwifQL.select(b.column("name") => "someName")
                        .from(b.table)
                        .where(b.column("id") == a.column("id"))|
                ) => "alias1")|
        )
            .from(a.table)
        checkAllDialects(query, pg: """
        SELECT "a"."name", (SELECT json_agg("alias1") as "test1" FROM (SELECT "b"."name" as "someName" FROM "CarBrands" AS "b" WHERE "b"."id" = "a"."id") as "alias1") FROM "CarBrands" AS "a"
        """, mySQL: """
        SELECT a.name, (SELECT json_agg(alias1) as test1 FROM (SELECT b.name as someName FROM CarBrands AS b WHERE b.id = a.id) as alias1) FROM CarBrands AS a
        """)
    }
    
    // MARK: - RETURNING
    
    func testReturning() {
        let query = SwifQL.returning("hello_world", "bye_world")
        let pg = """
        RETURNING "hello_world", "bye_world"
        """
        let mySQL = """
        RETURNING hello_world, bye_world
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = SwifQL.returning(CarBrands.column("id"), CarBrands.column("name"))
        let pg2 = """
        RETURNING "id", "name"
        """
        let mySQL2 = """
        RETURNING id, name
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Fn.to_tsvector
    
    func testFn_to_tsvector() {
        let query = SwifQL.select(Fn.to_tsvector("english", "a fat  cat sat on a mat - it ate a fat rats"))
        let pg = """
        SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')
        """
        let mySQL = """
        SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = SwifQL.select(Fn.to_tsvector("english"))
        let pg2 = """
        SELECT to_tsvector('english')
        """
        let mySQL2 = """
        SELECT to_tsvector('english')
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Fn.to_tsquery
    
    func testFn_to_tsquery() {
        let query = SwifQL.select(Fn.to_tsquery("english", "The & Fat & Rats"))
        let pg = """
        SELECT to_tsquery('english', 'The & Fat & Rats')
        """
        let mySQL = """
        SELECT to_tsquery('english', 'The & Fat & Rats')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = SwifQL.select(Fn.to_tsquery("english"))
        let pg2 = """
        SELECT to_tsquery('english')
        """
        let mySQL2 = """
        SELECT to_tsquery('english')
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Fn.plainto_tsquery
    
    func testFn_plainto_tsquery() {
        let query = SwifQL.select(Fn.plainto_tsquery("english", "The Fat Rats"))
        let pg = """
        SELECT plainto_tsquery('english', 'The Fat Rats')
        """
        let mySQL = """
        SELECT plainto_tsquery('english', 'The Fat Rats')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = SwifQL.select(Fn.plainto_tsquery("english"))
        let pg2 = """
        SELECT plainto_tsquery('english')
        """
        let mySQL2 = """
        SELECT plainto_tsquery('english')
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Fn.ts_rank_cd
    
    func testFn_ts_rank_cd() {
        let query = SwifQL.select(Fn.ts_rank_cd(FormattedKeyPath(CarBrands.self, "id"), Fn.to_tsquery("The Fat Rats")))
        let pg = """
        SELECT ts_rank_cd("CarBrands"."id", to_tsquery('The Fat Rats'))
        """
        let mySQL = """
        SELECT ts_rank_cd(CarBrands.id, to_tsquery('The Fat Rats'))
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    // MARK: - FormattedKeyPath
    
    func testFormattedKeyPath() {
        let query = SwifQL.select(FormattedKeyPath(CarBrands.self, "id"))
        let pg = """
        SELECT "CarBrands"."id"
        """
        let mySQL = """
        SELECT CarBrands.id
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = SwifQL.select(CarBrands.mkp("id"))
        let pg2 = """
        SELECT "CarBrands"."id"
        """
        let mySQL2 = """
        SELECT CarBrands.id
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Concat
    
    func testConcat() {
        let query = Fn.concat("Hello ", CarBrands.column("name"))
        let pg = """
        concat('Hello ', "CarBrands"."name")
        """
        let mySQL = """
        concat('Hello ', CarBrands.name)
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
        let query2 = Fn.concat_ws(", ", "Hello", CarBrands.column("name"))
        let pg2 = """
        concat_ws(', ', 'Hello', "CarBrands"."name")
        """
        let mySQL2 = """
        concat_ws(', ', 'Hello', CarBrands.name)
        """
        checkAllDialects(query2, pg: pg2, mySQL: mySQL2)
    }
    
    // MARK: - Delete
    
    func testDelete() {
        let query = SwifQL.delete(from: CarBrands.table).where(CarBrands.column("name") == "BMW")
        let pg = """
        DELETE FROM "CarBrands" WHERE "CarBrands"."name" = 'BMW'
        """
        let mySQL = """
        DELETE FROM CarBrands WHERE CarBrands.name = 'BMW'
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    // MARK: - Order by simple
    
    func testOrderBySimple() {
        let query = SwifQL.orderBy(.asc(CarBrands.column("name")), .desc(CarBrands.column("id")))
        let pg = """
        ORDER BY "CarBrands"."name" ASC, "CarBrands"."id" DESC
        """
        let mySQL = """
        ORDER BY CarBrands.name ASC, CarBrands.id DESC
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    // MARK: - Order by with nulls
    
    func testOrderByWithNulls() {
        let pgQuery = SwifQL.orderBy(.asc(CarBrands.column("name"), nulls: .first), .desc(CarBrands.column("id"), nulls: .last))
        let pg = """
        ORDER BY "CarBrands"."name" ASC NULLS FIRST, "CarBrands"."id" DESC NULLS LAST
        """
        let mysqlQuery = SwifQL.orderBy(.asc(CarBrands.column("name") == nil, CarBrands.column("name")), .desc(CarBrands.column("id") != nil, CarBrands.column("id")))
        let mySQL = """
        ORDER BY CarBrands.name IS NULL, CarBrands.name ASC, CarBrands.id IS NOT NULL, CarBrands.id DESC
        """
        checkAllDialects(pgQuery, pg: pg)
        checkAllDialects(mysqlQuery, mySQL: mySQL)
    }
    
    // MARK: - Order by with direction
    
    func testOrderByDirection() {
        let pgQuery = SwifQL.orderBy(.direction(.asc, CarBrands.column("name"), nulls: .last))
        let pg = """
        ORDER BY "CarBrands"."name" ASC NULLS LAST
        """
        let mysqlQuery = SwifQL.orderBy(.direction(.desc, CarBrands.column("id"), nulls: .first))
        let mySQL = """
        ORDER BY CarBrands.id DESC NULLS FIRST
        """
        checkAllDialects(pgQuery, pg: pg)
        checkAllDialects(mysqlQuery, mySQL: mySQL)
    }
    
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
    
    // MARK - Generate Series
    
    func testGenerateSeriesNumbers() {
        checkAllDialects(SwifQL.select(Fn.generate_series(1, 4)), pg: "SELECT generate_series(1, 4)", mySQL: "SELECT generate_series(1, 4)")
        checkAllDialects(SwifQL.select(Fn.generate_series(1, 4, 2)), pg: "SELECT generate_series(1, 4, 2)", mySQL: "SELECT generate_series(1, 4, 2)")
    }
    
    func testGenerateSeriesDates() {
        let queryString = SwifQL.select(Fn.generate_series("2019-10-01", "2019-10-04", "1 day"))
        let pgString = """
        SELECT generate_series('2019-10-01', '2019-10-04', '1 day')
        """
        let mySQLString = """
        SELECT generate_series('2019-10-01', '2019-10-04', '1 day')
        """
        checkAllDialects(queryString, pg: pgString, mySQL: mySQLString)
        
        let queryStringCast = SwifQL.select(Fn.generate_series("2019-10-01" => .date, "2019-10-04" => .date, "1 day"))
        let pgStringCast = """
        SELECT generate_series('2019-10-01'::date, '2019-10-04'::date, '1 day')
        """
        let mySQLStringCast = """
        SELECT generate_series('2019-10-01'::date, '2019-10-04'::date, '1 day')
        """
        checkAllDialects(queryStringCast, pg: pgStringCast, mySQL: mySQLStringCast)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        
        let queryDate = SwifQL.select(Fn.generate_series(df.date(from: "2019-10-01 00:00:00")!, df.date(from: "2019-10-04 00:00:00")!, "1 day"))
        let pgDate = """
        SELECT generate_series((TIMESTAMP 'EPOCH' + make_interval(secs => 1569888000.0)), (TIMESTAMP 'EPOCH' + make_interval(secs => 1570147200.0)), '1 day')
        """
        let mySQLDate = """
        SELECT generate_series(FROM_UNIXTIME(1569888000.0), FROM_UNIXTIME(1570147200.0), '1 day')
        """
        checkAllDialects(queryDate, pg: pgDate, mySQL: mySQLDate)
    }
    
    static var allTests = [
        ("testPureSelect", testSelect),
        ("testSimpleString", testSelectString),
        ("testSelectInt", testSelectInt),
        ("testSelectDouble", testSelectDouble),
        ("testSelectSeveralSimpleValues", testSelectSeveralSimpleValues),
        ("testSelectColumn", testSelectColumn),
        ("testSelectColumnWithTable", testSelectColumnWithTable),
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
        ("testSelectFnStringAgg", testSelectFnStringAgg),
        ("testSelectFnRegexpReplace", testSelectFnRegexpReplace),
        ("testSelectFrom", testSelectFrom),
        ("testFrom", testFrom),
        ("testFromOneTable", testFromOneTable),
        ("testFromTwoTables", testFromTwoTables),
        ("testFromOneTableAlias", testFromOneTableAlias),
        ("testFromTwoTableAliases", testFromTwoTableAliases),
        ("testFromTableAndTableAlias", testFromTableAndTableAlias),
        ("testSelectBuilderLimitShort", testSelectBuilderLimitShort),
        ("testSelectBuilderCopy", testSelectBuilderCopy),
        ("testBingingForPostgreSQL", testBingingForPostgreSQL),
        ("testBingingForMySQL", testBingingForMySQL),
        ("testExists", testExists),
        ("testNotExists", testNotExists),
        ("testUnion", testUnion),
        ("testWith", testWith),
        ("testWithColumns", testWithColumns),
        ("testWhereExists", testWhereExists),
        ("testWhereNotExists", testWhereNotExists),
        ("testSelectWithAliasInSelectParams", testSelectWithAliasInSelectParams),
        ("testOnConflict", testOnConflict),
        ("testOnConflictOnConstraintDoNothing", testOnConflictOnConstraintDoNothing),
        ("testDoNothing", testDoNothing),
        ("testNotAndBetween", testNotAndBetween),
        ("testSubqueryWithAlias", testSubqueryWithAlias),
        ("testReturning", testReturning),
        ("testFn_to_tsvector", testFn_to_tsvector),
        ("testFn_to_tsquery", testFn_to_tsquery),
        ("testFn_plainto_tsquery", testFn_plainto_tsquery),
        ("testFormattedKeyPath", testFormattedKeyPath),
        ("testConcat", testConcat),
        ("testDelete", testDelete),
        ("testOrderBySimple", testOrderBySimple),
        ("testOrderByWithNulls", testOrderByWithNulls),
        ("testOrderByDirection", testOrderByDirection),
        ("testCaseWhenThenElse1", testCaseWhenThenElse1),
        ("testCaseWhenThenElse2", testCaseWhenThenElse2),
        ("testGenerateSeriesNumbers", testGenerateSeriesNumbers),
        ("testGenerateSeriesDates", testGenerateSeriesDates)
    ]
}
