@testable import SwifQL
import Testing

@Suite("Fn camelCase compatibility")
struct FnCamelCaseCompatibilityTests {
    private func expectEquivalent(
        _ canonical: SwifQLable,
        _ legacy: SwifQLable,
        expected: String,
        dialect: SQLDialect = .psql
    ) {
        let canonicalSQL = SwifQL.select(canonical).prepare(dialect).plain
        let legacySQL = SwifQL.select(legacy).prepare(dialect).plain
        #expect(canonicalSQL == expected)
        #expect(legacySQL == expected)
        #expect(canonicalSQL == legacySQL)
    }

    @Test("Shared zero-argument Fn alias")
    func sharedZeroArgumentAlias() {
        expectEquivalent(
            Fn.rowNumber(),
            Fn.row_number(),
            expected: "SELECT row_number()"
        )
    }

    @Test("Shared variadic and array Fn aliases")
    func sharedVariadicAndArrayAliases() {
        expectEquivalent(
            Fn.arrayRemove(PgArray(1, 2, 3, 2), 2),
            Fn.array_remove(PgArray(1, 2, 3, 2), 2),
            expected: "SELECT array_remove(ARRAY[1, 2, 3, 2], 2)"
        )

        let items: [SwifQLable] = [PgArray(1, 2, 3, 2), 2]
        expectEquivalent(
            Fn.arrayRemove(items),
            Fn.array_remove(items),
            expected: "SELECT array_remove(ARRAY[1, 2, 3, 2], 2)"
        )
    }

    @Test("PostgreSQL JSON variadic and array aliases")
    func postgreSQLJSONVariadicAndArrayAliases() {
        expectEquivalent(
            Fn.jsonBuildArray("one", 2),
            Fn.json_build_array("one", 2),
            expected: "SELECT json_build_array('one', 2)"
        )

        let items: [SwifQLable] = ["one", 2]
        expectEquivalent(
            Fn.jsonBuildArray(items),
            Fn.json_build_array(items),
            expected: "SELECT json_build_array('one', 2)"
        )
    }

    @Test("PostgreSQL JSON path aliases preserve labels")
    func postgreSQLJSONPathAliases() {
        let json = #"{"f4":{"f6":"foo"}}"#
        let path = ["f4", "f6"]
        expectEquivalent(
            Fn.jsonExtractPath(json, pathElems: path),
            Fn.json_extract_path(json, path_elems: path),
            expected: #"SELECT json_extract_path('{"f4":{"f6":"foo"}}', 'f4', 'f6')"#
        )
    }

    @Test("PostgreSQL time default argument alias")
    func postgreSQLTimeDefaultArgumentAlias() {
        expectEquivalent(
            Fn.makeInterval(days: 10),
            Fn.make_interval(days: 10),
            expected: "SELECT make_interval(days => 10)"
        )
    }

    @Test("PostgreSQL generateSeries alias")
    func postgreSQLGenerateSeriesAlias() {
        expectEquivalent(
            Fn.generateSeries(1, 4),
            Fn.generate_series(1, 4),
            expected: "SELECT generate_series(1, 4)"
        )
    }

    @Test("PostgreSQL JSONB representative alias")
    func postgreSQLJSONBRepresentativeAlias() {
        expectEquivalent(
            Fn.jsonbBuildArray("one", 2),
            Fn.jsonb_build_array("one", 2),
            expected: "SELECT jsonb_build_array('one', 2)"
        )
    }

    @Test("MySQL Fn aliases")
    func mySQLAliases() {
        expectEquivalent(
            Fn.fromUnixtime(123),
            Fn.from_unixtime(123),
            expected: "SELECT FROM_UNIXTIME(123)",
            dialect: .mysql
        )
        expectEquivalent(
            Fn.dateFormat(CarBrands.column("createdAt"), "%y-%m"),
            Fn.date_format(CarBrands.column("createdAt"), "%y-%m"),
            expected: "SELECT DATE_FORMAT(CarBrands.createdAt, '%y-%m')",
            dialect: .mysql
        )
    }
}
