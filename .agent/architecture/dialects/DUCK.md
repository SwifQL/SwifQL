# Duck Dialect Architecture

This file is the sole owner of `DUCK-*` rules and verified DuckDB-specific behavior for SwifQL.

Load it together with `../DIALECT_RENDERING.md` for Duck work. Load `../DSL_DESIGN_AND_UX.md` only when public API/UX design is involved, and `../QUERY_PREPARATION.md` only when preparation/value mechanics change.

This file intentionally distinguishes:

- stable Duck API/rendering contracts;
- verified DuckDB v1.5.5 engine behavior;
- current unreleased implementation state;
- pre-release blockers that must be corrected before the Duck dialect can be considered finished.

Do not duplicate these details in the cross-dialect base owner.

## Context-budget growth rule

Keep this file as one Duck owner while it remains practical to load for a focused Duck task. If future PostgreSQL-level breadth makes it too large, split only by genuinely independent Duck domains and move ownership rather than copying rules. Likely future split candidates are types/values, query features, DML/DDL, and native-validation evidence. Do not pre-create empty chunks for symmetry.

A split must keep `DUCK-*` ownership unambiguous through `ARCH_INDEX.md` and preserve the rule that a normal task loads only the Duck detail actually needed.

## Identity and naming

### DUCK-001 - Canonical Swift dialect spelling

The canonical public Swift dialect factory is:

```swift
SQLDialect.duck
```

Ordinary preparation is:

```swift
query.prepare(.duck)
```

The final supported-dialect collection is expected to use:

```swift
[.psql, .mysql, .duck]
```

The current unreleased local implementation still contains `.duckdb` in source/tests. That spelling is a pre-release naming defect and must be removed directly, not preserved as a deprecated alias.

### DUCK-002 - Internal database identity

The actual database product remains DuckDB.

The internal dialect id may remain:

```swift
"duckdb"
```

Human-facing prose may say DuckDB.

Swift implementation naming uses `Duck...` / `duck...` when a database-specific prefix is genuinely needed. Do not introduce new `DuckDB...` / `duckDB...` Swift symbol prefixes.

Examples of preferred implementation spelling:

- `DuckDialect`
- `Dialect+Duck.swift`
- `Functions+DuckJSON.swift`
- `duckCatalogPathParts(...)`

Before adding a Duck prefix, first ask whether the user-facing concept should instead have a clean generic SQL name.

## Core scalar rendering

### DUCK-003 - Identifiers

Duck identifiers use double quotes.

Embedded double quotes are escaped by doubling them.

This applies to schema/table/alias/column identifiers and any nested STRUCT/UNION member/tag identifier handled by SwifQL.

Examples:

```sql
"events"
"x space"
"a""b"
```

Do not reject identifiers merely because they require quoting.

### DUCK-004 - Strings

String literals use single quotes.

Embedded apostrophes are escaped by doubling them.

Example:

```sql
'O''Reilly'
```

Do not raw-interpolate user string values.

### DUCK-005 - Bind markers

Duck prepared placeholders use positional `$N` markers:

```sql
$1, $2, $3
```

Value traversal/order remains owned by `QUERY_PREPARATION.md`.

Native DuckDB v1.5.5 validation has confirmed normal binding behavior for representative scalar values, PIVOT `IN (...)` values, and PIVOT `LIMIT` when the statement is otherwise prepare-able.

### DUCK-006 - Foundation Date

A Foundation `Date` is rendered deterministically as a UTC Duck TIMESTAMPTZ literal with microsecond precision:

```sql
TIMESTAMPTZ 'YYYY-MM-DD HH:MM:SS.ffffff+00:00'
```

Do not use local time zone behavior for Duck Date rendering.

### DUCK-007 - Foundation Data

Foundation `Data` uses Duck base64 decoding semantics:

```sql
from_base64('<base64>')
```

This is dialect rendering of the existing Foundation value API, not a public `Fn.fromBase64` substitution.

## Paths, JSON, and contextual rendering

### DUCK-008 - Normal key paths

Outside a grammar-specific context, a normal table column path remains qualified:

```swift
Path.Table("events").column("payload")
```

renders as:

```sql
"events"."payload"
```

Nested JSON path segments use Duck JSON operators and string path fields.

`asText` on the final path segment uses `->>`; otherwise JSON traversal uses `->`.

### DUCK-009 - JSON/list indexing semantics

Duck JSON indexing is zero-based.

Duck LIST/ARRAY indexing is one-based.

Do not unify these semantics under a fake common index abstraction that changes SQL meaning.

### DUCK-010 - Context-sensitive qualification must stay invisible to ordinary query source

Duck simplified PIVOT is a verified case where source-qualified column references are rejected by the engine in specific grammar positions.

Users should not have to replace normal SwifQL table/column expressions with Duck-prefixed wrappers merely to satisfy this renderer requirement.

The approved architecture direction is dialect-transparent contextual rendering through the shared parts/preparation pipeline, consistent with `DIALECT-008` and DESIGN-014.

The exact render-scope implementation is still under architecture review and must not be improvised as neighboring-token heuristics.

The current `shouldGroupDuckDBKeyPath(...)` preparation heuristic is not a precedent for future contextual rendering and should eventually be replaced by a structured mechanism once that mechanism is approved and tested.

## Collections and nested types

### DUCK-011 - LIST and fixed ARRAY

Duck distinguishes:

- variable-length LIST type syntax such as `INTEGER[]`;
- fixed-size ARRAY type syntax such as `INTEGER[3]`.

A fixed ARRAY length must be strictly positive.

The current corrected public type API uses clean SQL-shaped names under `Type`, including:

```swift
Type.list(...)
Type.array(..., length: ...)
```

Do not expose a new Duck-prefixed type API for SQL type names when the clean `Type.*` surface is truthful.

### DUCK-012 - MAP / STRUCT / UNION / VARIANT

Duck supports nested values/types including MAP, STRUCT, UNION, and VARIANT.

For the type system, clean SQL-shaped `Type.*` names are preferred.

The STRUCT type function is intentionally expressed with Swift escaped-keyword syntax:

```swift
Type.`struct`(...)
```

not `structure(...)` and not `structType(...)`.

Nested STRUCT/UNION identifiers must use proper quoted identifier rendering, including reserved words, spaces, Unicode, and embedded quotes.

The current unreleased value-construction types still include `DuckDBList`, `DuckDBArray`, `DuckDBMap`, `DuckDBStruct`, `DuckDBUnion`, and `DuckDBVariant`. Their final public UX is not approved. They must be reviewed against the dialect-transparent DSL rules before release rather than mechanically renamed.

## Type mapping

### DUCK-013 - Exact type mapping over PostgreSQL convenience

Do not claim PostgreSQL-only type semantics as Duck equivalents merely because names look similar.

The Duck type surface may reuse exact shared SQL type names where semantics are compatible, but PostgreSQL-specific serial/range/OID/catalog/jsonb/network/geometry helpers are not automatically Duck APIs.

The dialect-aware `Type.auto(from:dialect:isPrimary:)` path must return `nil` when SwifQL cannot infer a semantics-preserving Duck type/default behavior.

In particular, primary-key integer inference must not silently invent PostgreSQL `serial` semantics for Duck.

Sequence/default behavior is modeled separately.

## Functions

### DUCK-014 - Function API stays clean

Duck-specific SQL functions live under normal camelCase `Fn.*` Swift names while emitted SQL retains the exact Duck function spelling.

Examples already implemented/researched include JSON, numeric, string, time, and sequence functions.

Do not prefix ordinary function calls with `Duck` merely because current support is Duck-only.

Do not silently map a Duck function to a differently named PostgreSQL/MySQL function.

## Query features

### DUCK-015 - Reuse common SQL DSL first

Duck support should reuse existing common SwifQL composition whenever the SQL concept is already expressible.

Examples:

- FROM-first composition reuses `SwifQL.from(...).select(...)`;
- GROUP BY ALL reuses `.groupBy(SwifQL.all)`;
- normal ORDER BY / LIMIT / OFFSET reuse shared query primitives when grammar matches;
- generic expressions/functions/aliases remain normal SwifQL expressions.

Do not add parallel Duck builders only for visual symmetry.

### DUCK-016 - Native Duck query features remain clean at call sites

Duck-specific/native features currently implemented or researched include:

- QUALIFY;
- ORDER BY ALL;
- SAMPLE/TABLESAMPLE;
- UNION BY NAME / ALL BY NAME;
- SEMI / ANTI / POSITIONAL / ASOF joins;
- NATURAL / USING join forms;
- star EXCLUDE / REPLACE / RENAME;
- COLUMNS(...);
- PIVOT / UNPIVOT;
- INSERT BY NAME / OR IGNORE / OR REPLACE;
- MERGE;
- ATTACH / DETACH / USE;
- COPY;
- macros;
- sequences;
- nested values;
- table-function composition.

A feature being Duck-only today does not automatically authorize a `Duck...` public query API. Apply DESIGN-014 and the clean SQL-concept rule first.

## PIVOT

### DUCK-017 - Simplified PIVOT native contract

DuckDB v1.5.5 native validation established the following for simplified PIVOT:

- unqualified ON expressions work;
- source-table-qualified columns in ON fail with a binder error;
- source-table-qualified columns inside USING aggregate expressions fail;
- GROUP BY works with unqualified column names and rejects qualified source paths;
- ORDER BY works with unqualified PIVOT output column names and rejects source-table-qualified paths;
- explicit `IN` values work as normal prepared parameters;
- numeric, apostrophe-containing text, and Unicode `IN` values passed prepare/bind/execute;
- LIMIT works as a normal prepared parameter when explicit IN makes the statement structurally prepare-able;
- dynamic simplified PIVOT without explicit IN can execute as plain SQL but DuckDB v1.5.5 cannot prepare it as one C prepared statement because dynamic output-column discovery expands internally into multiple statements.

Do not misclassify the no-IN preparation limitation as a general placeholder or LIMIT defect.

### DUCK-018 - PIVOT UX contract

The rejected wrapper design (`DuckDBPivotColumn`, `DuckDBPivotOn`, `DuckDBPivotAggregate`, PIVOT-specific order wrappers) must not be implemented.

Ordinary PIVOT source should stay clean and use existing SwifQL expressions, paths, functions, aliases, and ordering concepts.

Target direction under architecture discussion:

```swift
SwifQL.pivot(cities)
    .on(cities.column("year"), in: 2000, 2010)
    .using(Fn.sum(cities.column("population")) => "total")
    .groupBy(cities.column("country"))
    .orderBy(.desc(cities.column("country")))
    .limit(2)
```

The dialect renderer, not the user, owns Duck's unqualification requirement in PIVOT grammar zones.

For simplified PIVOT `GROUP BY`, reuse the historical `KeyPathLastPath` protocol as the public input constraint. DuckDB v1.5.5 accepts column names there and rejects qualified/expression forms; `KeyPathLastPath` models that grammar without changing the normal clean call site:

```swift
.groupBy(cities.column("country"))
```

Do not introduce a PIVOT-specific column wrapper for this clause. The shared contextual-rendering architecture remains unresolved for ON/USING/ORDER BY and must be approved/planned before PIVOT source correction resumes.

## Native validation evidence

### DUCK-019 - Native validation is a release gate for grammar-sensitive features

Renderer tests prove SwifQL output, not DuckDB parser/binder/execution acceptance.

For new grammar-sensitive Duck features, native DuckDB validation is required when the API relies on assumptions that string tests cannot prove.

Current v1.5.5 correction evidence has already proven:

- COLUMNS regex prepared form;
- COLUMNS explicit-name prepared form;
- COLUMNS lambda prepared form;
- corrected nested STRUCT/UNION identifier cases;
- representative MERGE;
- the complete PIVOT qualification/binding matrix described in DUCK-017.

The broader mandatory native matrix has not yet completed because work stopped at the PIVOT architecture correction point.

UNPIVOT, remaining sequence/macro/ATTACH/COPY cases and any other not-yet-reached mandatory cases must not be described as native-validated until the continuation matrix actually runs.

## DML / DDL and advanced statements

### DUCK-020 - SQL fidelity for advanced statements

Duck DML/DDL support is additive and exact-SQL oriented.

Implemented/researched surface includes normal INSERT/UPDATE/DELETE compatibility plus Duck extensions, CREATE/ALTER/DROP forms, schemas, enums, sequences, indexes, MERGE, COPY, macros, and catalog/database statements.

Do not hide unsupported Duck semantics behind PostgreSQL-looking helpers. Examples from research include PostgreSQL index methods and unsupported constraint/foreign-key behaviors that must remain unclaimed unless current Duck documentation/native tests prove support.

The detailed feature matrix should be expanded here as each advanced area completes native validation rather than duplicated in the common dialect owner.

## Catalog paths

### DUCK-021 - Catalog is a SQL namespace concept, not a Duck-branded user concept

The current unreleased source uses `Path.DuckDBCatalog...` types and `duckDBCatalogPathParts(...)`.

That public naming is not approved.

Target direction is a clean generic catalog namespace API such as:

```swift
Path.Catalog("warehouse")
    .schema("reporting")
    .table("events")
```

with dialect-aware rendering/support determining where catalog qualification is valid.

If an internal Duck-specific helper remains necessary, use `duck...` naming.

## Pre-release cleanup gate

### DUCK-022 - Unreleased Duck API may be corrected directly

Duck support has not shipped from this working tree.

Therefore incorrect new Duck API names/shapes should be fixed directly before release, without compatibility aliases whose only purpose would be preserving an unreleased mistake.

This explicitly includes the current `.duckdb` Swift factory and new `DuckDB...` / `duckDB...` Swift symbols where they violate the approved naming/UX rules.

This rule does not authorize changing established pre-Duck SwifQL APIs used by existing users.

### DUCK-023 - Complete API-surface review before continuing feature implementation

Before resuming the blocked PIVOT/C02 path, classify the entire new unreleased Duck public surface into:

1. reuse existing SwifQL API unchanged;
2. generic clean SQL-concept API;
3. clean inferred helper type that users normally do not name;
4. genuinely Duck-specific implementation symbol using `Duck...` / `duck...`;
5. unresolved UX requiring focused research.

Known areas requiring this review include PIVOT, UNPIVOT, MERGE, COLUMNS, star modifiers, nested values, sequences, macros, catalog paths, sampling helper types, COPY/ATTACH option types, and remaining `DuckDB...` symbols.

No new implementation task should treat the current unreleased `DuckDB...` surface as design authority.
