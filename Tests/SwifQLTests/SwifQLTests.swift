import XCTest
@testable import SwifQL

final class SwifQLTests: SwifQLTestCase {
        
    //MARK: - WHERE
    
    func testWhere() {
        checkAllDialects(SwifQL.where("" == 1), pg: "WHERE '' = 1", mySQL: "WHERE '' = 1")
        checkAllDialects(SwifQL.where, pg: "WHERE", mySQL: "WHERE")
    }
    
    //MARK: - UNION
    func testUnion() {
        let table1 = Path.Table("Table1")
        let table2 = Path.Table("Table2")
        let table3 = Path.Table("Table3")
        
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
            .select(Distinct(Path.Column("uniqueName")) => .text => "name")
            .from(
                Union(
                    SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table1),
                    SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table2)
                )
        )
        
        checkAllDialects(adv, pg: """
        SELECT DISTINCT "uniqueName"::text as "name" FROM (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table1") UNION (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table2")
        """, mySQL: """
        SELECT DISTINCT uniqueName::text as name FROM (SELECT DISTINCT name::text as uniqueName FROM Table1) UNION (SELECT DISTINCT name::text as uniqueName FROM Table2)
        """)
    }

    //MARK: - VALUES
    
    func testValues() {
        checkAllDialects(SwifQL.values(1, 1.2, 1.234, "hello"), pg: """
        (1, 1.2, 1.234, 'hello')
        """, mySQL: """
        (1, 1.2, 1.234, 'hello')
        """)
        checkAllDialects(SwifQL.values(array: [1, 1.2, 1.234, "hello"], [2, 2.3, 2.345, "bye"]), pg: """
        (1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')
        """, mySQL: """
        (1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')
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
    
    static var allTests = [
        ("testBingingForPostgreSQL", testBingingForPostgreSQL),
        ("testBingingForMySQL", testBingingForMySQL),
        ("testUnion", testUnion),
        ("testFormattedKeyPath", testFormattedKeyPath)
    ]
}
