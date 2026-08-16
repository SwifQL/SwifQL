@testable import SwifQL
import Testing

@Suite("Established operator compatibility")
struct EstablishedOperatorCompatibilityTests {
    private final class CustomDialect: SQLDialect {
        override func hybridOperator(_ hybrid: SwifQLHybridOperator) -> SwifQLPartOperator {
            SwifQLPartOperator("custom()")
        }
    }

    @Test("PostgreSQL and MySQL comparison rendering stays unchanged")
    func establishedComparison() {
        let nested = FormattedKeyPath("events", "payload", "profile", "name")
        let query = nested == "Ada"
        #expect(query.prepare(.psql).plain == #""events"."payload"->'profile'->'name' = 'Ada'"#)
        #expect(query.prepare(.mysql).plain == "events.name = 'Ada'")
    }

    @Test("Hybrid dialect hook remains open to downstream dialects")
    func hybridDialectHook() {
        let hybrid = SwifQLHybridOperator(SwifQLPartOperator("pg()"), SwifQLPartOperator("mysql()"))
        #expect(hybrid.prepare(CustomDialect()).plain == "custom()")
    }
}
