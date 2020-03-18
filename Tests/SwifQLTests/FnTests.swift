import XCTest
@testable import SwifQL

final class FnTests: SwifQLTestCase {
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
        ("testFn_to_tsvector", testFn_to_tsvector),
        ("testFn_to_tsquery", testFn_to_tsquery),
        ("testFn_plainto_tsquery", testFn_plainto_tsquery),
        ("testConcat", testConcat),
        ("testGenerateSeriesNumbers", testGenerateSeriesNumbers),
        ("testGenerateSeriesDates", testGenerateSeriesDates)
    ]
}
