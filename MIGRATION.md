# Migrating from SwifQL 1.5.x to 2.0.0

SwifQL 1.5.0 is the last stable Swift 5 release.

If you already have a Vapor 4 / Swift 5 project and don't need the new major version yet, you can stay on 1.5.x.

Starting a new project? Target the upcoming 2.0.0 line 🚀 It is still being prepared and is not published yet.

This guide covers the things worth checking when you move an existing project to 2.0.0.

## Swift 6

SwifQL 2.0.0 uses:

```swift
// swift-tools-version:6.0
swiftLanguageModes: [.v6]
```

The final build/test pass was done with Apple Swift 6.3.3 and complete strict-concurrency checking.

The macOS deployment target is still 10.15, so moving to Swift 6 does not raise the runtime platform floor by itself.

## `SwifQLable.parts` is structural now

This is the biggest source-level change for advanced SwifQL extensions.

In 1.x, statement/subquery/set-result contents were easy to treat as one flat top-level `parts` array.

In 2.0.0, real SQL regions are kept structurally so ownership/context survives things like:

- incremental query building;
- helper functions;
- copied `parts`;
- nested statements and CTEs;
- UNION / set-result composition;
- PIVOT / UNPIVOT;
- builders.

Normal SQL-shaped query code usually stays the same.

The migration mainly matters if your own extension manually appends or pattern-matches `parts`.

### Before

```swift
extension SwifQLable {
    func appendingMyFragment(_ fragment: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: self.parts + fragment.parts)
    }
}
```

### After

If your helper means "continue the current query", use:

```swift
extension SwifQLable {
    func appendingMyFragment(_ fragment: SwifQLable) -> SwifQLable {
        structurallyAppending(fragment)
    }
}
```

`structurallyAppending(_:)` continues the current root SQL region without trying to rediscover query history from tokens.

Don't mechanically replace every copied-parts use with this method. Two separately built framed queries are still two separate structural values.

## Inspecting structural parts

The structural types are public/read-only so advanced extensions can inspect them safely:

```swift
if let frame = query.parts.first as? SwifQLStructuralFramePart {
    print(frame.region)

    for child in frame.children {
        if let groupBy = child as? SwifQLGroupByPart {
            print(groupBy.owner as Any)
            print(groupBy.fields.count)
        }

        if let orderBy = child as? SwifQLOrderByPart {
            print(orderBy.owner as Any)
            print(orderBy.items.count)
        }
    }
}
```

Copying still works:

```swift
let copied = SwifQLableParts(parts: query.parts)
```

The structural tree is preserved with the copied parts.

## Custom structural ownership

`SwifQLClauseOwner` and `SwifQLClauseKind` use open namespaced identities so external extensions can define their own values:

```swift
extension SwifQLClauseOwner {
    static let report = SwifQLClauseOwner(
        namespace: "com.example.reporting",
        name: "report"
    )
}

extension SwifQLClauseKind {
    static let reportOrder = SwifQLClauseKind(
        namespace: "com.example.reporting",
        name: "reportOrder"
    )
}

let scope = SwifQLClauseOwner.report.renderScope(for: .reportOrder)
```

Keep custom extensions on normal SwifQL parts / preparation rather than creating unknown `SwifQLPart` types that the core renderer cannot understand.

## DuckDB 🦆

2.0.0 adds DuckDB as a first-class dialect:

```swift
query.prepare(.duck)
```

and:

```swift
SQLDialect.all // [.psql, .mysql, .duck]
```

If your tests or tools assumed that `SQLDialect.all` always contained exactly PostgreSQL + MySQL, update that assumption.

### What the first DuckDB release covers

The first DuckDB support wave focuses on ordinary application / analytics / schema SQL, including the implemented/validated parts of:

- core values, binds, dates and identifiers;
- catalog/path/JSON support;
- scalar and nested types/values;
- common functions/operators;
- SELECT-family analytics;
- grouping, joins and set operations;
- LIST/lambda helpers;
- star/COLUMNS support;
- PIVOT / UNPIVOT;
- ordinary DML / RETURNING / MERGE where supported;
- common table/schema/view/type/index/constraint DDL;
- sequences and macros that do not need the deferred generic `:=` API;
- ATTACH / DETACH / USE;
- COPY;
- common table/file functions.

### PIVOT GROUP BY

Keep the normal SQL-shaped source:

```swift
query = query.groupBy(cities.column("country"))
```

SwifQL does not add a fake PIVOT-only global overload after the receiver has already been erased to `SwifQLable`.

`KeyPathLastPath` still exists for APIs that can truthfully enforce a column-name-only type restriction.

### Dynamic PIVOT without `IN (...)`

DuckDB v1.5.5 can execute simplified PIVOT without an explicit `IN (...)` as plain SQL, but that dynamic form cannot be prepared as one C prepared statement because DuckDB expands it internally while discovering output columns.

If your execution path requires one prepared statement, use a prepare-able PIVOT form such as an explicit `IN (...)` list where that fits your query.

### Not in the first DuckDB release

The first release intentionally leaves some administration/runtime areas for later, including:

- INSTALL / LOAD;
- secrets;
- broad PRAGMA/configuration APIs;
- CHECKPOINT;
- VACUUM / ANALYZE administration;
- SET / RESET VARIABLE;
- EXPORT / IMPORT DATABASE;
- SHOW / DESCRIBE / SUMMARIZE;
- extension-specific SQL universes.

The generic SQL `name := expression` API is also intentionally deferred. It is a different grammar from table-function `name = value` options.

## Strict concurrency and actors

SwifQL 2.0.0 compiles cleanly in Swift 6 strict-concurrency mode, but that does **not** mean the whole DSL is `Sendable`.

Don't assume these are Sendable:

```text
SwifQLable query graphs
SwifQLPart graphs
SwifQLPrepared / SwifQLSplittedQuery
arbitrary [Encodable] binds
mutable aliases / columns / builders / table aliases
open mutable SQLDialect subclasses
```

That is intentional. SwifQL does not use blanket `@unchecked Sendable` or force arbitrary binds into `Encodable & Sendable` just to silence the compiler.

### Recommended actor boundary

Prepare/normalize on the caller side, convert to your own truthful Sendable representation, then send that snapshot to the actor.

For example:

```swift
import SwifQL

enum BindSnapshot: Sendable {
    case string(String)
    case int(Int)
}

struct QuerySnapshot: Sendable {
    let sql: String
    let binds: [BindSnapshot]
}

enum SnapshotError: Error {
    case unsupportedBind
}

func makeSnapshot(_ split: SwifQLSplittedQuery) throws -> QuerySnapshot {
    let binds = try split.values.map { value -> BindSnapshot in
        if let value = value as? String { return .string(value) }
        if let value = value as? Int { return .int(value) }
        throw SnapshotError.unsupportedBind
    }

    return QuerySnapshot(sql: split.query, binds: binds)
}

actor ConnectionActor {
    func execute(_ snapshot: QuerySnapshot) {
        // Send snapshot to your DB driver here
    }
}

final class Wrapper {
    let connection: ConnectionActor

    init(connection: ConnectionActor) {
        self.connection = connection
    }

    nonisolated(nonsending)
    func execute(_ query: SwifQLable) async throws {
        let split = query.prepare(.duck).splitted
        let snapshot = try makeSnapshot(split)
        await connection.execute(snapshot)
    }
}
```

Your real snapshot should support exactly the bind types your DB layer needs. Only mark the representation `Sendable` when the stored values really are Sendable.

Don't send `SwifQLable`, `SwifQLSplittedQuery`, or an arbitrary `[Encodable]` directly across actors and hide the problem with unchecked conformance.

`prepare(_:)` stays synchronous; SwifQL does not add internal actor hops just for consumer wrappers.

## `Fn.Name` predefined values are immutable

If you only read predefined names, nothing changes.

This old customization style no longer works:

```swift
Fn.Name.coalesce = .custom("my_coalesce")
```

Use a custom name explicitly:

```swift
let name = Fn.Name.custom("my_coalesce")
let fn = Fn.build(name)
```

This setter removal is an intentional 2.0.0 source break.

## Fresh predefined roots/options

These keep the same call syntax:

```swift
SwifQL
AttachOption.readOnly
CopyOption.header
CopyOption.array
CopyOption.schema
```

but they now return fresh values instead of sharing stored non-Sendable instances.

Don't rely on object identity for those predefined query/options values.

## Static `raw(_:)` fix

Static raw now uses the text you pass to it.

The established route-specific spacing remains:

```swift
SwifQLableParts.raw("TAIL").prepare(.psql).plain // " TAIL"
"TAIL".raw.prepare(.psql).plain                  // "TAIL"
```

and normal flat composition produces:

```text
BASE TAIL
```

The same behavior is covered for PostgreSQL, MySQL and Duck.

## PostgreSQL dates

PostgreSQL date formatting is instance-local in 2.0.0 instead of using the old formatter subclass/shared pattern.

The generated PostgreSQL date SQL stays compatible with the previous behavior.

## Quick migration checklist

- [ ] Move the project/toolchain to Swift 6 when adopting SwifQL 2.0.0.
- [ ] Check extensions that manually manipulate `SwifQLable.parts`.
- [ ] Use `structurallyAppending(_:)` for helpers that continue a framed query.
- [ ] Check code that assumes `SQLDialect.all` contains only PostgreSQL + MySQL.
- [ ] Replace mutations of predefined `Fn.Name` values with `Fn.Name.custom(_:)` / `Fn.build(_:)`.
- [ ] Keep SwifQL query/bind graphs on caller isolation and cross actors with your own Sendable snapshot.
- [ ] Review the DuckDB deferred families before assuming a specific administration/runtime feature exists.

The final Swift 6.3.3 validation passed 448 tests in 42 suites with zero concurrency errors and zero concurrency warnings.
