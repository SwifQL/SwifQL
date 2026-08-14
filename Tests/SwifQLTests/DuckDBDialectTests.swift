@testable import SwifQL
import Foundation
import Testing

@Suite("Duck dialect foundation")
struct DuckDBDialectTests: SwifQLTests {
    @Test("Duck identity stays explicit without expanding SQLDialect.all")
    func identity() {
        #expect(SQLDialect.duck.id == "duckdb")
        #expect(SQLDialect.all.map { $0.id } == ["psql", "mysql"])
    }

    @Test("Duck identifiers and strings escape correctly")
    func escaping() {
        check(
            SwifQL.select(Path.Schema("ana\"lytics").table("event\"s").column("id\"value")),
            .duck(#"SELECT "ana""lytics"."event""s"."id""value""#)
        )
        check(SwifQL.select("O'Reilly"), .duck("SELECT 'O''Reilly'"))
    }

    @Test("Duck bindings preserve value order")
    func bindings() {
        let prepared = SwifQL.select("alpha", 42).prepare(.duck)
        #expect(prepared.splitted.query == "SELECT $1, $2")
        #expect(prepared.splitted.values[0] as? String == "alpha")
        #expect(prepared.splitted.values[1] as? Int == 42)
    }

    @Test("Duck Date uses deterministic UTC microseconds")
    func date() {
        let value = Date(timeIntervalSince1970: 1_577_934_245.123456)
        #expect(SwifQL.select(value).prepare(.duck).plain == "SELECT TIMESTAMPTZ '2020-01-02 03:04:05.123456+00:00'")
    }
}
