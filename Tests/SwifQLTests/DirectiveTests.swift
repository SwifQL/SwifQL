import XCTest
@testable import SwifQL

final class DirectiveTests: SwifQLTestCase {
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
    
    static var allTests = [
        ("testOnConflict", testOnConflict),
        ("testOnConflictOnConstraintDoNothing", testOnConflictOnConstraintDoNothing),
        ("testDoNothing", testDoNothing),
        ("testNotAndBetween", testNotAndBetween),
        ("testReturning", testReturning),
        ("testDelete", testDelete)
    ]
}
