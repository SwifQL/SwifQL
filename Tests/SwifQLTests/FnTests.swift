import XCTest
@testable import SwifQL

final class FnTests: SwifQLTestCase {
    // MARK: - Fn.array_remove
    
    func testFn_array_remove() {
        check(
            SwifQL.select(Fn.array_remove(PgArray(1,2,3,2), 2)),
            .psql("SELECT array_remove(ARRAY[1, 2, 3, 2], 2)"),
            .mysql("SELECT array_remove(ARRAY[1, 2, 3, 2], 2)")
        )
    }
    
    // MARK: - Concat
    
    func testConcat() {
        check(
            Fn.concat("Hello ", CarBrands.column("name")),
            .psql(#"concat('Hello ', "CarBrands"."name")"#),
            .mysql("concat('Hello ', CarBrands.name)")
        )
        check(
            Fn.concat_ws(", ", "Hello", CarBrands.column("name")),
            .psql(#"concat_ws(', ', 'Hello', "CarBrands"."name")"#),
            .mysql("concat_ws(', ', 'Hello', CarBrands.name)")
        )
    }
    
    // MARK: - Fn.to_tsvector
    
    func testFn_to_tsvector() {
        check(
            SwifQL.select(Fn.to_tsvector("english", "a fat  cat sat on a mat - it ate a fat rats")),
            .psql(#"SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')"#),
            .mysql("SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')")
        )
        check(
            SwifQL.select(Fn.to_tsvector("english")),
            .psql("SELECT to_tsvector('english')"),
            .mysql("SELECT to_tsvector('english')")
        )
    }
    
    // MARK: - Fn.to_tsquery
    
    func testFn_to_tsquery() {
        check(
            SwifQL.select(Fn.to_tsquery("english", "The & Fat & Rats")),
            .psql("SELECT to_tsquery('english', 'The & Fat & Rats')"),
            .mysql("SELECT to_tsquery('english', 'The & Fat & Rats')")
        )
        check(
            SwifQL.select(Fn.to_tsquery("english")),
            .psql("SELECT to_tsquery('english')"),
            .mysql("SELECT to_tsquery('english')")
        )
    }
    
    // MARK: - Fn.plainto_tsquery
    
    func testFn_plainto_tsquery() {
        check(
            SwifQL.select(Fn.plainto_tsquery("english", "The Fat Rats")),
            .psql("SELECT plainto_tsquery('english', 'The Fat Rats')"),
            .mysql("SELECT plainto_tsquery('english', 'The Fat Rats')")
        )
        check(
            SwifQL.select(Fn.plainto_tsquery("english")),
            .psql("SELECT plainto_tsquery('english')"),
            .mysql("SELECT plainto_tsquery('english')")
        )
    }
    
    // MARK: - Fn.ts_rank_cd
    
    func testFn_ts_rank_cd() {
        check(
            SwifQL.select(Fn.ts_rank_cd(FormattedKeyPath(CarBrands.self, "id"), Fn.to_tsquery("The Fat Rats"))),
            .psql(#"SELECT ts_rank_cd("CarBrands"."id", to_tsquery('The Fat Rats'))"#),
            .mysql("SELECT ts_rank_cd(CarBrands.id, to_tsquery('The Fat Rats'))")
        )
    }
    
    // MARK - Generate Series
    
    func testGenerateSeriesNumbers() {
        check(
            SwifQL.select(Fn.generate_series(1, 4)),
            .psql("SELECT generate_series(1, 4)"),
            .mysql("SELECT generate_series(1, 4)")
        )
        check(
            SwifQL.select(Fn.generate_series(1, 4, 2)),
            .psql("SELECT generate_series(1, 4, 2)"),
            .mysql("SELECT generate_series(1, 4, 2)")
        )
    }
    
    func testGenerateSeriesDates() {
        check(
            SwifQL.select(Fn.generate_series("2019-10-01", "2019-10-04", "1 day")),
            .psql("SELECT generate_series('2019-10-01', '2019-10-04', '1 day')"),
            .mysql("SELECT generate_series('2019-10-01', '2019-10-04', '1 day')")
        )
        check(
            SwifQL.select(Fn.generate_series("2019-10-01" => .date, "2019-10-04" => .date, "1 day")),
            .psql("SELECT generate_series('2019-10-01'::date, '2019-10-04'::date, '1 day')"),
            .mysql("SELECT generate_series('2019-10-01'::date, '2019-10-04'::date, '1 day')")
        )
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        let pdf = PostgresDateFormatter()
        let date1 = df.date(from: "2019-10-01 00:00:00")!
        let date2 = df.date(from: "2019-10-04 00:00:00")!
        check(
            SwifQL.select(Fn.generate_series(date1, date2, "1 day")),
            .psql("SELECT generate_series(('\(pdf.string(from: date1))'::timestamptz), ('\(pdf.string(from: date2))'::timestamptz), '1 day')"),
            .mysql("SELECT generate_series(FROM_UNIXTIME(1569888000.0), FROM_UNIXTIME(1570147200.0), '1 day')")
        )
    }

    // MARK: - MySQL DATE_FORMAT

    func testFn_date_format() {
        check(
            SwifQL.select(Fn.date_format(CarBrands.column("createdAt"), "%y-%m")),
            .psql(#"SELECT DATE_FORMAT("CarBrands"."createdAt", '%y-%m')"#),
            .mysql("SELECT DATE_FORMAT(CarBrands.createdAt, '%y-%m')")
        )
    }
    
    static var allTests = [
        ("testFn_to_tsvector", testFn_to_tsvector),
        ("testFn_to_tsquery", testFn_to_tsquery),
        ("testFn_plainto_tsquery", testFn_plainto_tsquery),
        ("testConcat", testConcat),
        ("testGenerateSeriesNumbers", testGenerateSeriesNumbers),
        ("testGenerateSeriesDates", testGenerateSeriesDates),
        ("testFn_date_format", testFn_date_format)
    ]
}
