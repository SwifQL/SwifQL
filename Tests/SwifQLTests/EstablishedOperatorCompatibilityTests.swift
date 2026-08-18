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

    @Test("Legacy custom dialects retain default contextual value binding")
    func legacyContextualValueBinding() {
        let star = SwifQL.asterisk.glob("metric*").prepare(CustomDialect()).splitted
        #expect(star.query == "* GLOB ?")
        #expect(star.values[0] as? String == "metric*")

        let ordinary = SwifQLableParts(parts: SwifQLPartColumn("metric"))
            .similarTo("metric.*")
            .prepare(CustomDialect())
            .splitted
        #expect(ordinary.query == "metric SIMILAR TO ?")
        #expect(ordinary.values[0] as? String == "metric.*")
    }

    @Test("Legacy custom dialects inherit structural star modifier lowering")
    func legacyStarModifierLowering() {
        let query = SwifQL.asterisk.replace(
            StarReplacement("fallback", as: "value")
        )
        let prepared = query.prepare(CustomDialect()).splitted

        #expect(prepared.query == "* REPLACE (? as value)")
        #expect(prepared.values[0] as? String == "fallback")
    }
}
