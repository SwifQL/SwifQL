@testable import SwifQL
import Testing

@Suite("Established operator compatibility")
struct EstablishedOperatorCompatibilityTests {
    @Test("PostgreSQL and MySQL comparison rendering stays unchanged")
    func establishedComparison() {
        let nested = FormattedKeyPath("events", "payload", "profile", "name")
        let query = nested == "Ada"
        #expect(query.prepare(.psql).plain == #""events"."payload"->'profile'->'name' = 'Ada'"#)
        #expect(query.prepare(.mysql).plain == "events.name = 'Ada'")
    }
}
