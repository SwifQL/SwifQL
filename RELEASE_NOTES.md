# SwifQL 2.0.0 🚀

SwifQL 2.0.0 is the new major version we're preparing for Swift 6 projects.

If you already have a long-lived Vapor 4 / Swift 5 project and don't want to migrate yet, **SwifQL 1.5.0 remains the last stable Swift 5 release**.

## What's new

### Swift 6

SwifQL now builds in Swift 6 language mode and was validated with Apple Swift 6.3.3 under complete strict-concurrency checking.

The macOS deployment target is still 10.15.

One important detail: strict-concurrency compatibility does **not** mean every query object is `Sendable`. SwifQL keeps the query/bind graph non-Sendable where that is the truthful model. If you use actors, prepare the query on the caller side and pass your own Sendable snapshot to the actor. There is a full example in [MIGRATION.md](MIGRATION.md).

### DuckDB support 🦆

DuckDB is now a first-class dialect:

```swift
query.prepare(.duck)
```

and:

```swift
SQLDialect.all // [.psql, .mysql, .duck]
```

The first DuckDB release covers the ordinary application / analytics / schema surface we validated: SELECT-family queries, joins, set operations, JSON, nested types and values, PIVOT / UNPIVOT, MERGE, DML with RETURNING where supported, common DDL, sequences, macros, ATTACH / DETACH / USE, COPY, and common table/file functions.

Some administration/runtime families are intentionally left for later: INSTALL / LOAD, secrets, broad PRAGMA/configuration, CHECKPOINT, VACUUM / ANALYZE administration, variables, EXPORT / IMPORT DATABASE, SHOW / DESCRIBE / SUMMARIZE, extension-specific SQL, and the generic SQL `name := expression` API.

### Better query composition

`SwifQLable.parts` now keeps real statement / subquery / set-result boundaries structurally instead of flattening everything into one top-level array.

Most normal SwifQL query source stays the same. The breaking change mainly affects advanced extensions that manually inspect or append `parts`.

For helpers that mean "continue this query", use:

```swift
query.structurallyAppending(fragment)
```

See [MIGRATION.md](MIGRATION.md) for before/after examples.

### `Fn.Name` predefined values are immutable

This no longer works:

```swift
Fn.Name.coalesce = .custom("my_coalesce")
```

Use a custom function name explicitly instead:

```swift
let name = Fn.Name.custom("my_coalesce")
let fn = Fn.build(name)
```

### `raw(_:)` fix

The static raw helper now uses the supplied text correctly.

The existing route-specific spacing is preserved:

```swift
SwifQLableParts.raw("TAIL") // " TAIL"
"TAIL".raw                  // "TAIL"
```

and a normal flat composition still produces:

```text
BASE TAIL
```

### Small Swift 6 cleanup

`SwifQL`, `AttachOption.readOnly`, `CopyOption.header`, `CopyOption.array`, and `CopyOption.schema` now return fresh values instead of sharing stored non-Sendable instances. Normal source syntax is unchanged.

PostgreSQL date formatting is also instance-local now; generated PostgreSQL date SQL stays unchanged.

## Breaking changes

The main things to check when moving from 1.5.x to 2.0.0 are:

- Swift 6 toolchain/language mode;
- code that manually manipulates `SwifQLable.parts`;
- code that mutates predefined `Fn.Name` values;
- actor-based wrappers that tried to send SwifQL query/bind objects directly across isolation boundaries.

Everything is covered in [MIGRATION.md](MIGRATION.md).

## Validation

The final Swift 6.3.3 validation passed:

```text
448 tests / 42 suites
concurrency errors: 0
concurrency warnings: 0
```

DuckDB behavior was validated against DuckDB v1.5.5 for the first supported surface.

Full version history: [CHANGELOG.md](CHANGELOG.md)
