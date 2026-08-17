import Foundation
import Testing
@testable import SwifQL

@Suite("Duck SELECT feature tests")
struct DuckSelectFeatureTests {
    private func expectDuck(_ query: SwifQLable, _ expected: String) {
        #expect(query.prepare(.duck).plain == expected)
    }

    @Test("GROUP BY ALL reuses the existing generic groupBy surface")
    func groupByAllReuse() {
        let table = Path.Table("events")
        let category = table.column("category")
        let amount = table.column("amount")
        let base = SwifQL.select(category, Fn.sum(amount)).from(table)

        let fluent = base.groupBy(SwifQL.all)
        expectDuck(
            fluent,
            #"SELECT "events"."category", sum("events"."amount") FROM "events" GROUP BY ALL"#
        )

        var erased: SwifQLable = base
        erased = erased.groupBy(SwifQL.all)
        let copied = SwifQLableParts(parts: erased.parts)
        expectDuck(copied, fluent.prepare(.duck).plain)

        let frame = copied.parts.first as? SwifQLStructuralFramePart
        let group = frame?.children.compactMap { $0 as? SwifQLGroupByPart }.first
        #expect(group?.owner == nil)
    }

    @Test("GROUPING SETS, ROLLUP, and CUBE are ordinary GROUP BY expressions")
    func groupingExpressions() {
        let table = Path.Table("events")
        let category = table.column("category")
        let region = table.column("region")
        let amount = table.column("amount")

        let sets = GroupingSets([category, region], [category], [])
        let groupingSetsQuery = SwifQL
            .select(category, region, Fn.sum(amount), Fn.groupingId(category, region))
            .from(table)
            .groupBy(sets)

        expectDuck(
            groupingSetsQuery,
            #"SELECT "events"."category", "events"."region", sum("events"."amount"), grouping_id("events"."category", "events"."region") FROM "events" GROUP BY GROUPING SETS (("events"."category", "events"."region"), ("events"."category"), ())"#
        )

        let owner = SwifQLClauseOwner(namespace: "task13", name: "grouping")
        let owned = SwifQLableParts(parts: SwifQLStructuralFramePart(
            region: .statement,
            owners: [.groupBy: owner]
        )).groupBy(sets)
        let ownedRoot = owned.parts.first as? SwifQLStructuralFramePart
        let ownedGroup = ownedRoot?.children.compactMap { $0 as? SwifQLGroupByPart }.first
        #expect(ownedGroup?.owner == owner)

        expectDuck(
            SwifQL.select(category, region, Fn.sum(amount))
                .from(table)
                .groupBy(Rollup(category, region)),
            #"SELECT "events"."category", "events"."region", sum("events"."amount") FROM "events" GROUP BY ROLLUP("events"."category", "events"."region")"#
        )

        expectDuck(
            SwifQL.select(category, region, Fn.sum(amount))
                .from(table)
                .groupBy(Cube(category, region)),
            #"SELECT "events"."category", "events"."region", sum("events"."amount") FROM "events" GROUP BY CUBE("events"."category", "events"."region")"#
        )

        func rollupFragment(_ lhs: SwifQLable, _ rhs: SwifQLable) -> SwifQLable {
            Rollup(lhs, rhs)
        }
        var query: SwifQLable = SwifQL.select(category).from(table)
        query = query.groupBy(rollupFragment(category, region))
        query = SwifQLableParts(parts: query.parts)
        expectDuck(
            query,
            #"SELECT "events"."category" FROM "events" GROUP BY ROLLUP("events"."category", "events"."region")"#
        )
    }

    @Test("Grouping ID and count overloads preserve exact function shapes")
    func groupingFunctionsAndCount() {
        let table = Path.Table("events")
        let value = table.column("value")
        let query = SwifQL.select(Fn.count(), Fn.count(value)).from(table)

        let expected = #"SELECT count(), count("events"."value") FROM "events""#
        #expect(query.prepare(.duck).plain == expected)
        #expect(query.prepare(.psql).plain == expected)
        #expect(query.prepare(.mysql).plain == "SELECT count(), count(events.value) FROM events")
    }

    @Test("QUALIFY composes with a real window expression")
    func qualifyWindowComposition() {
        let table = Path.Table("events")
        let category = table.column("category")
        let sequence = table.column("seq")
        let ranked = Fn.rowNumber()
            .over(partitionBy: category, orderBy: .asc(sequence))

        func predicate() -> SwifQLable {
            Path.Column("rn") == 1
        }

        var query: SwifQLable = SwifQL
            .select(category, sequence, ranked => "rn")
            .from(table)
        query = query.qualify(predicate()).orderBy(.asc(category))
        expectDuck(
            query,
            #"SELECT "events"."category", "events"."seq", row_number() OVER (PARTITION BY "events"."category" ORDER BY "events"."seq" ASC) as "rn" FROM "events" QUALIFY "rn" = 1 ORDER BY "events"."category" ASC"#
        )
    }

    @Test("ORDER BY ALL uses the existing owner-bearing order part")
    func orderByAll() {
        let table = Path.Table("events")
        let category = table.column("category")
        let region = table.column("region")
        let base = SwifQL.select(category, region).from(table)

        expectDuck(
            base.orderByAll,
            #"SELECT "events"."category", "events"."region" FROM "events" ORDER BY ALL"#
        )
        expectDuck(
            base.orderByAll(.desc, nulls: .last),
            #"SELECT "events"."category", "events"."region" FROM "events" ORDER BY ALL DESC NULLS LAST"#
        )
        expectDuck(
            base.orderByAll(nulls: .first),
            #"SELECT "events"."category", "events"."region" FROM "events" ORDER BY ALL NULLS FIRST"#
        )

        let owner = SwifQLClauseOwner(namespace: "task13", name: "select")
        let framed = SwifQLableParts(parts: SwifQLStructuralFramePart(
            region: .statement,
            owners: [.orderBy: owner]
        ))
        let owned = framed.orderByAll
        let root = owned.parts.first as? SwifQLStructuralFramePart
        let order = root?.children.compactMap { $0 as? SwifQLOrderByPart }.first
        #expect(order?.owner == owner)
        #expect(order?.items.count == 1)
    }

    @Test("Percentage LIMIT keeps ordinary LIMIT binding and SQL identity")
    func limitPercent() {
        let table = Path.Table("events")
        let value = table.column("value")
        let query = SwifQL.select(value).from(table).limit(percent: 30)
        let prepared = query.prepare(.duck)

        #expect(prepared.plain == #"SELECT "events"."value" FROM "events" LIMIT 30%"#)
        #expect(prepared.splitted.query == #"SELECT "events"."value" FROM "events" LIMIT $1%"#)
        #expect(prepared.splitted.values.map { String(describing: $0) } == ["30"])

        let ordinary = SwifQL.select(value).from(table).limit(30)
        #expect(ordinary.prepare(.duck).plain == #"SELECT "events"."value" FROM "events" LIMIT 30"#)
        #expect(ordinary.prepare(.psql).plain == #"SELECT "events"."value" FROM "events" LIMIT 30"#)
    }

    @Test("USING SAMPLE and TABLESAMPLE use distinct typed SQL shapes")
    func sampling() {
        let table = Path.Table("events")
        let value = table.column("value")
        let using = SwifQL
            .select(value)
            .from(table)
            .usingSample(Sample(SampleSize(percentage: 10), method: .reservoir, seed: 42))
            .orderBy(.asc(value))
            .limit(2)

        expectDuck(
            using,
            #"SELECT "events"."value" FROM "events" USING SAMPLE 10% (reservoir, 42) ORDER BY "events"."value" ASC LIMIT 2"#
        )
        #expect(using.prepare(.duck).splitted.values.map { String(describing: $0) } == ["2"])

        let usingWithoutLimit = SwifQL
            .select(value)
            .from(table)
            .usingSample(Sample(SampleSize(percentage: 10), method: .reservoir, seed: 42))
        #expect(usingWithoutLimit.prepare(.duck).splitted.values.isEmpty)

        expectDuck(
            SwifQL.select(value)
                .from(table)
                .usingSample(Sample(SampleSize(rows: 10))),
            #"SELECT "events"."value" FROM "events" USING SAMPLE 10"#
        )

        let sampledTable = table.tableSample(
            TableSample(SampleSize(percentage: 10), method: .reservoir, repeatable: 42)
        )
        expectDuck(
            SwifQL.select(value).from(sampledTable),
            #"SELECT "events"."value" FROM "events" TABLESAMPLE reservoir(10 PERCENT) REPEATABLE (42)"#
        )
        expectDuck(
            SwifQL.select(value).from(table.tableSample(TableSample(SampleSize(percentage: 10)))),
            #"SELECT "events"."value" FROM "events" TABLESAMPLE (10 PERCENT)"#
        )
    }

    @Test("Existing DISTINCT, FILTER, WINDOW, OFFSET, and FROM-first forms remain exact")
    func existingSelectReuse() {
        let table = Path.Table("events")
        let category = table.column("category")
        let value = table.column("value")

        let distinct = SwifQL.select(Distinct(category)).from(table)
        #expect(distinct.prepare(.duck).plain == #"SELECT DISTINCT "events"."category" FROM "events""#)

        let distinctOn = Distinct(on: category).andAlso(category, value)
        let distinctOnQuery = SwifQL.select(distinctOn).from(table).orderBy(.asc(category))
        #expect(
            distinctOnQuery.prepare(.duck).plain
                == #"SELECT DISTINCT ON ("events"."category") "events"."category", "events"."value" FROM "events" ORDER BY "events"."category" ASC"#
        )

        let filtered = SwifQL.select(Fn.count(value).filter(where: value > 20)).from(table)
        #expect(
            filtered.prepare(.duck).plain
                == #"SELECT count("events"."value") FILTER (WHERE "events"."value" > 20) FROM "events""#
        )

        let windowed = SwifQL.select(
            Fn.rowNumber().over(partitionBy: category, orderBy: .asc(value))
        ).from(table)
        #expect(
            windowed.prepare(.duck).plain
                == #"SELECT row_number() OVER (PARTITION BY "events"."category" ORDER BY "events"."value" ASC) FROM "events""#
        )

        let fromFirst = SwifQL.from(table).select(value).limit(2).offset(1)
        #expect(
            fromFirst.prepare(.duck).plain
                == #"FROM "events" SELECT "events"."value" LIMIT 2 OFFSET 1"#
        )
    }
}
