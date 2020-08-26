import XCTest
@testable import SwifQL

final class DirectiveTests: SwifQLTestCase {
    // MARK: - UPDATE
    
    func testUpdate() {
        check(
            SwifQL.update(Path.Schema(nil).table("ttt")),
            .psql(#"UPDATE "ttt""#),
            .mysql("UPDATE ttt")
        )
        check(
            SwifQL.update(Path.Schema("sss").table("ttt")),
            .psql(#"UPDATE "sss"."ttt""#),
            .mysql("UPDATE sss.ttt")
        )
    }
    
    // MARK: - INSERT INTO
    
    func testInsertInto() {
        check(
            SwifQL.insertInto(Path.Schema(nil).table("ttt"), fields: "id"),
            .psql(#"INSERT INTO "ttt" ("id")"#),
            .mysql("INSERT INTO ttt (id)")
        )
        check(
            SwifQL.insertInto(Path.Schema("sss").table("ttt"), fields: "id"),
            .psql(#"INSERT INTO "sss"."ttt" ("id")"#),
            .mysql("INSERT INTO sss.ttt (id)")
        )
        check(
            SwifQL.insertInto(CarBrands.table, fields: CarBrands.column("id")),
            .psql(#"INSERT INTO "CarBrands" ("id")"#),
            .mysql("INSERT INTO CarBrands (id)")
        )
        check(
            SwifQL.insertInto(CarBrands.table, fields: CarBrands.column("id"), CarBrands.column("name"), CarBrands.column("createdAt")),
            .psql(#"INSERT INTO "CarBrands" ("id", "name", "createdAt")"#),
            .mysql("INSERT INTO CarBrands (id, name, createdAt)")
        )
        check(
            SwifQL.insertInto(cb.table, fields: cb.column("id")),
            .psql(#"INSERT INTO "CarBrands" AS "cb" ("id")"#),
            .mysql("INSERT INTO CarBrands AS cb (id)")
        )
        check(
            SwifQL.insertInto(cb.table, fields: cb.column("id"), cb.column("name"), cb.column("createdAt")),
            .psql(#"INSERT INTO "CarBrands" AS "cb" ("id", "name", "createdAt")"#),
            .mysql("INSERT INTO CarBrands AS cb (id, name, createdAt)")
        )
        check(
            SwifQL.insertInto(cb.table, fields: CarBrands.column("id"), cb.column("name"), CarBrands.column("createdAt")),
            .psql(#"INSERT INTO "CarBrands" AS "cb" ("id", "name", "createdAt")"#),
            .mysql("INSERT INTO CarBrands AS cb (id, name, createdAt)")
        )
    }
    
    // MARK: - Delete
    
    func testDelete() {
        check(
            SwifQL.delete(from: CarBrands.table).where(CarBrands.column("name") == "BMW"),
            .psql(#"DELETE FROM "CarBrands" WHERE "CarBrands"."name" = 'BMW'"#),
            .mysql("DELETE FROM CarBrands WHERE CarBrands.name = 'BMW'")
        )
    }
    
    // MARK: - RETURNING
    
    func testReturning() {
        check(
            SwifQL.returning("hello_world", "bye_world"),
            .psql(#"RETURNING "hello_world", "bye_world""#),
            .mysql("RETURNING hello_world, bye_world")
        )
        check(
            SwifQL.returning(CarBrands.column("id"), CarBrands.column("name")),
            .psql(#"RETURNING "id", "name""#),
            .mysql("RETURNING id, name")
        )
    }
    
    // MARK: - ON CONFLICT DO NOTHING
    
    func testOnConflict() {
        check(
            SwifQL.on.conflict(CarBrands.column("id"), CarBrands.column("name")),
            .psql(#"ON CONFLICT ("id", "name")"#),
            .mysql("ON CONFLICT (id, name)")
        )
        check(
            SwifQL.on.conflict(CarBrands.column("id"), CarBrands.column("name")).do.nothing,
            .psql(#"ON CONFLICT ("id", "name") DO NOTHING"#),
            .mysql("ON CONFLICT (id, name) DO NOTHING")
        )
    }
    
    // MARK: - ON CONFLICT ON CONSTRAINT DO NOTHING
    
    func testOnConflictOnConstraintDoNothing() {
        check(
            SwifQL.on.conflict.on.constraint("hello_world"),
            .psql(#"ON CONFLICT ON CONSTRAINT "hello_world""#),
            .mysql("ON CONFLICT ON CONSTRAINT hello_world")
        )
        check(
            SwifQL.on.conflict.on.constraint("hello_world").do.nothing,
            .psql(#"ON CONFLICT ON CONSTRAINT "hello_world" DO NOTHING"#),
            .mysql("ON CONFLICT ON CONSTRAINT hello_world DO NOTHING")
        )
        check(
            SwifQL.on.conflict.on.constraint(CarBrands.column("name")),
            .psql(#"ON CONFLICT ON CONSTRAINT "name""#),
            .mysql("ON CONFLICT ON CONSTRAINT name")
        )
    }
    
    // MARK: - DO NOTHING
    
    func testDoNothing() {
        check(
            SwifQL.do.nothing,
            .psql("DO NOTHING"),
            .mysql("DO NOTHING")
        )
    }
    
    // MARK: - NOT / NOT BETWEEN / BETWEEN
    
    func testNotAndBetween() {
        check(
            SwifQL.between(10.and(20)),
            .psql("BETWEEN 10 AND 20"),
            .mysql("BETWEEN 10 AND 20")
        )
        check(
            SwifQL.not(SwifQL.between(10.and(20))),
            .psql("NOT BETWEEN 10 AND 20"),
            .mysql("NOT BETWEEN 10 AND 20")
        )
        check(
            SwifQL.between((CarBrands.column("id")).and(CarBrands.column("name"))),
            .psql(#"BETWEEN "CarBrands"."id" AND "CarBrands"."name""#),
            .mysql("BETWEEN CarBrands.id AND CarBrands.name")
        )
        check(
            SwifQL.not(SwifQL.between((CarBrands.column("id")).and(CarBrands.column("name")))),
            .psql(#"NOT BETWEEN "CarBrands"."id" AND "CarBrands"."name""#),
            .mysql("NOT BETWEEN CarBrands.id AND CarBrands.name")
        )
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
