import XCTest
@testable import SwifQL

final class SwifQLTests: SwifQLTestCase {
    
    //MARK: - Operators
    
    func testOperatorToSwifQLable() {
        check(SwifQL.select(Operator.null), .mysql("SELECT NULL"), .psql("SELECT NULL"))
    }
        
    //MARK: - ARRAY
    
    func testArray() {
        let emptyIntArray: [Int] = []
        check(
            emptyIntArray,
//            .mysql(""),
            .psql("")
        )
        check(
            SwifQLableParts(parts: emptyIntArray),
//            .mysql("''"),
            .psql("'{}'")
        )

        let nonEmptyIntArray: [Int] = [1,3,7]
        check(
            nonEmptyIntArray,
//            .mysql("1, 3, 7"),
            .psql("1, 3, 7")
        )
        check(
            SwifQLableParts(parts: nonEmptyIntArray),
//            .mysql("'1,3,7'"),
            .psql("ARRAY[1,3,7]", "ARRAY[$1,$2,$3]")
        )
        
        let emptyStringArray: [Int] = []
        check(
            emptyStringArray,
//            .mysql(""),
            .psql("")
        )
        check(
            SwifQLableParts(parts: emptyStringArray),
//            .mysql("''"),
            .psql("'{}'")
        )

        let nonEmptyStringArray: [String] = ["a", "b", "c"]
        check(
            nonEmptyStringArray,
//            .mysql("'a', 'b', 'c'"),
            .psql("'a', 'b', 'c'")
        )
        check(
            SwifQLableParts(parts: nonEmptyStringArray),
//            .mysql("'a','b','c'"),
            .psql("ARRAY['a','b','c']", "ARRAY[$1,$2,$3]")
        )
    }
    
    //MARK: - WHERE
    
    func testWhere() {
        check(SwifQL.where("" == 1), all: "WHERE '' = 1")
        check(SwifQL.where, all: "WHERE")
    }
    
    //MARK: - UNION
    func testUnion() {
        let table1 = Path.Table("Table1")
        let table2 = Path.Table("Table2")
        let table3 = Path.Table("Table3")
        check(
            Union(
                SwifQL.select(table1.*).from(table1),
                SwifQL.select(table2.*).from(table2),
                SwifQL.select(table3.*).from(table3)
            ),
            .psql(#"(SELECT "Table1".* FROM "Table1") UNION (SELECT "Table2".* FROM "Table2") UNION (SELECT "Table3".* FROM "Table3")"#),
            .mysql(#"(SELECT Table1.* FROM Table1) UNION (SELECT Table2.* FROM Table2) UNION (SELECT Table3.* FROM Table3)"#)
        )
        
        check(
            SwifQL
                .select(Distinct(Path.Column("uniqueName")) => .text => "name")
                .from(
                    Union(
                        SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table1),
                        SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table2)
                    )
            ),
            .psql(#"SELECT DISTINCT "uniqueName"::text as "name" FROM (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table1") UNION (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table2")"#),
            .mysql(#"SELECT DISTINCT uniqueName::text as name FROM (SELECT DISTINCT name::text as uniqueName FROM Table1) UNION (SELECT DISTINCT name::text as uniqueName FROM Table2)"#)
        )
    }

    //MARK: - VALUES
    
    func testValues() {
        check(
            SwifQL.values(1, 1.2, 1.234, "hello"),
            .psql("(1, 1.2, 1.234, 'hello')"),
            .mysql("(1, 1.2, 1.234, 'hello')")
        )
        check(
            SwifQL.values(array: [1, 1.2, 1.234, "hello"], [2, 2.3, 2.345, "bye"]),
            .psql("(1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')"),
            .mysql("(1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')")
        )
    }
    
    // MARK: - BINDINGS
    
    func testBindingForPostgreSQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.psql).splitted.query
        XCTAssertEqual(query, """
        WHERE "CarBrands"."name" = $1 OR "CarBrands"."name" = $2
        """)
    }
    
    func testBindingForMySQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.mysql).splitted.query
        XCTAssertEqual(query, """
        WHERE CarBrands.name = ? OR CarBrands.name = ?
        """)
    }
    
    // MARK: - FormattedKeyPath
    
    func testFormattedKeyPath() {
        check(
            SwifQL.select(FormattedKeyPath(CarBrands.self, "id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
        check(
            SwifQL.select(CarBrands.mkp("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    static var allTests = [
        ("testOperatorToSwifQLable", testOperatorToSwifQLable),
        ("testArray", testArray),
        ("testBindingForPostgreSQL", testBindingForPostgreSQL),
        ("testBindingForMySQL", testBindingForMySQL),
        ("testUnion", testUnion),
        ("testFormattedKeyPath", testFormattedKeyPath)
    ]
}
