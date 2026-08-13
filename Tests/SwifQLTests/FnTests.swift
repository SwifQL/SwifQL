@testable import SwifQL
import Foundation
import Testing

@Suite("Fn Tests")
struct FnTests: SwifQLTests {
    // MARK: - Fn.arrayRemove
    
    @Test("Test arrayRemove")
    func arrayRemove() {
        check(
            SwifQL.select(Fn.arrayRemove(PgArray(1,2,3,2), 2)),
            .psql("SELECT array_remove(ARRAY[1, 2, 3, 2], 2)"),
            .mysql("SELECT array_remove(ARRAY[1, 2, 3, 2], 2)")
        )
    }
    
    // MARK: - Concat
    
    @Test("Test concat")
    func concat() {
        check(
            Fn.concat("Hello ", CarBrands.column("name")),
            .psql(#"concat('Hello ', "CarBrands"."name")"#),
            .mysql("concat('Hello ', CarBrands.name)")
        )
        check(
            Fn.concatWs(", ", "Hello", CarBrands.column("name")),
            .psql(#"concat_ws(', ', 'Hello', "CarBrands"."name")"#),
            .mysql("concat_ws(', ', 'Hello', CarBrands.name)")
        )
    }
    
    // MARK: - Fn.toTsvector
    
    @Test("Test toTsvector")
    func toTsvector() {
        check(
            SwifQL.select(Fn.toTsvector("english", "a fat  cat sat on a mat - it ate a fat rats")),
            .psql(#"SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')"#),
            .mysql("SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats')")
        )
        check(
            SwifQL.select(Fn.toTsvector("english")),
            .psql("SELECT to_tsvector('english')"),
            .mysql("SELECT to_tsvector('english')")
        )
    }
    
    // MARK: - Fn.toTsquery
    
    @Test("Test toTsquery")
    func toTsquery() {
        check(
            SwifQL.select(Fn.toTsquery("english", "The & Fat & Rats")),
            .psql("SELECT to_tsquery('english', 'The & Fat & Rats')"),
            .mysql("SELECT to_tsquery('english', 'The & Fat & Rats')")
        )
        check(
            SwifQL.select(Fn.toTsquery("english")),
            .psql("SELECT to_tsquery('english')"),
            .mysql("SELECT to_tsquery('english')")
        )
    }
    
    // MARK: - Fn.plaintoTsquery
    
    @Test("Test plaintoTsquery")
    func plaintoTsquery() {
        check(
            SwifQL.select(Fn.plaintoTsquery("english", "The Fat Rats")),
            .psql("SELECT plainto_tsquery('english', 'The Fat Rats')"),
            .mysql("SELECT plainto_tsquery('english', 'The Fat Rats')")
        )
        check(
            SwifQL.select(Fn.plaintoTsquery("english")),
            .psql("SELECT plainto_tsquery('english')"),
            .mysql("SELECT plainto_tsquery('english')")
        )
    }
    
    // MARK: - Fn.tsRankCd
    
    @Test("Test tsRankCd")
    func tsRankCd() {
        check(
            SwifQL.select(Fn.tsRankCd(FormattedKeyPath(CarBrands.self, "id"), Fn.toTsquery("The Fat Rats"))),
            .psql(#"SELECT ts_rank_cd("CarBrands"."id", to_tsquery('The Fat Rats'))"#),
            .mysql("SELECT ts_rank_cd(CarBrands.id, to_tsquery('The Fat Rats'))")
        )
    }
    
    // MARK - Generate Series
    
    @Test("Test Generate Series Numbers")
    func generateSeriesNumbers() {
        check(
            SwifQL.select(Fn.generateSeries(1, 4)),
            .psql("SELECT generate_series(1, 4)"),
            .mysql("SELECT generate_series(1, 4)")
        )
        check(
            SwifQL.select(Fn.generateSeries(1, 4, 2)),
            .psql("SELECT generate_series(1, 4, 2)"),
            .mysql("SELECT generate_series(1, 4, 2)")
        )
    }
    
    @Test("Test Generate Series Dates")
    func generateSeriesDates() {
        check(
            SwifQL.select(Fn.generateSeries("2019-10-01", "2019-10-04", "1 day")),
            .psql("SELECT generate_series('2019-10-01', '2019-10-04', '1 day')"),
            .mysql("SELECT generate_series('2019-10-01', '2019-10-04', '1 day')")
        )
        check(
            SwifQL.select(Fn.generateSeries("2019-10-01" => .date, "2019-10-04" => .date, "1 day")),
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
            SwifQL.select(Fn.generateSeries(date1, date2, "1 day")),
            .psql("SELECT generate_series(('\(pdf.string(from: date1))'::timestamptz), ('\(pdf.string(from: date2))'::timestamptz), '1 day')"),
            .mysql("SELECT generate_series(FROM_UNIXTIME(1569888000.0), FROM_UNIXTIME(1570147200.0), '1 day')")
        )
    }

    // MARK: - MySQL DATE_FORMAT

    @Test("Test dateFormat")
    func dateFormat() {
        check(
            SwifQL.select(Fn.dateFormat(CarBrands.column("createdAt"), "%y-%m")),
            .psql(#"SELECT DATE_FORMAT("CarBrands"."createdAt", '%y-%m')"#),
            .mysql("SELECT DATE_FORMAT(CarBrands.createdAt, '%y-%m')")
        )
    }
}
