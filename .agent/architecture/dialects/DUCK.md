# Duck Dialect Architecture

This file is the sole owner of `DUCK-*` rules and verified DuckDB-specific behavior for SwifQL.

Load it together with `../DIALECT_RENDERING.md` for Duck work. Load `../DSL_DESIGN_AND_UX.md` only when public API/UX design is involved, and `../QUERY_PREPARATION.md` only when preparation/value mechanics change.

This file intentionally distinguishes:

- stable Duck API/rendering contracts;
- verified DuckDB v1.5.5 engine behavior;
- current implementation state;
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

The public Duck factory is `.duck`. `SQLDialect.all` intentionally remains `[.psql, .mysql]` until Duck passes its final support/compatibility/native-validation closure gate, because adding Duck changes the semantic reach of every existing `check(..., all:)` assertion.

Focused Duck tests use `.duck` explicitly. Internal product identity may still use `"duckdb"`.

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

### DUCK-007 - Foundation Data and exact base64 SQL stay transparent

Historical direct `Data.parts` is protected compatibility surface and remains PostgreSQL-shaped. Duck support must not globally reinterpret that existing expression and must not introduce a semantic `binary(...)` facade that chooses different named SQL functions by dialect.

Base64 SQL is modeled through exact function identity:

- PostgreSQL `decode(..., 'base64')` remains the `decode` construct;
- Duck `from_base64(...)` and MySQL `FROM_BASE64(...)` are the same exact function name with dialect-preferred casing and use canonical Swift `Fn.fromBase64(...)`;
- when included by the approved migration plan, `Fn.from_base64(...)` exists only as an immediately deprecated `renamed: "fromBase64"` compatibility bridge.

Selecting `.duck` may change casing/rendering details of the same exact function, bind markers, identifiers, and other dialect-owned syntax. It must not silently translate `decode` into `from_base64` or vice versa.

Any direct Duck BLOB/Data binding support must use normal explicit value/binding primitives and exact SQL APIs without changing historical direct `Data.parts`.

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

The approved architecture is dialect-transparent semantic render scopes through the shared parts/preparation pipeline, consistent with `DIALECT-008` and DESIGN-014/015.

For PIVOT grammar regions that accept normal expressions but require Duck-specific qualification behavior, the relevant expression parts carry a structural scope such as the ON/USING/ORDER BY grammar role. That scope travels with the expression regardless of whether the query is written as one fluent chain, assembled through `var`/conditionals, or produced by helper methods.

Duck rendering reads this explicit scope from the recursive render context. It must not infer PIVOT context by inspecting neighboring raw operator strings or by keeping ambient mutable "inside PIVOT" state on the query.

Do not attach a generic Duck operator scope to every ordinary predicate/arithmetic/operator constructor. Contextual scopes belong only to the semantic construct whose grammar actually requires them; ordinary established part shape must remain unchanged.

Neighbor-token heuristics such as inspecting previous/next raw operators are not acceptable architecture for Duck grammar context. Remaining Duck operator-precedence requirements must be researched and solved at the narrowest truthful semantic boundary without changing ordinary PostgreSQL/MySQL composition.

## Collections and nested types

### DUCK-011 - LIST and fixed ARRAY

Duck distinguishes:

- variable-length LIST type syntax such as `INTEGER[]`;
- fixed-size ARRAY type syntax such as `INTEGER[3]`.

A fixed ARRAY length must be strictly positive.

The future public type API uses clean SQL-shaped names under `Type`, including:

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

Public value-construction APIs for LIST/ARRAY/MAP/STRUCT/UNION/VARIANT are not yet approved. Fresh research must decide whether each concept reuses existing SwifQL, receives a clean SQL-shaped surface, stays internal, or needs no dedicated API.

## Type mapping

### DUCK-013 - Exact type mapping over PostgreSQL convenience

Do not claim PostgreSQL-only type semantics as Duck equivalents merely because names look similar.

The Duck type surface may reuse exact shared SQL type names where semantics are compatible, but PostgreSQL-specific serial/range/OID/catalog/jsonb/network/geometry helpers are not automatically Duck APIs.

If a future dialect-aware `Type.auto(from:dialect:isPrimary:)` convenience is approved, it must return `nil` when SwifQL cannot infer a semantics-preserving Duck type/default behavior. Reuse one semantic mapping owner rather than duplicating type inference across dialect-specific helpers.

In particular, primary-key integer inference must not silently invent PostgreSQL `serial` semantics for Duck.

Sequence/default behavior is modeled separately.

## Functions

### DUCK-014 - Function API stays clean

Duck-specific SQL functions live under normal camelCase `Fn.*` Swift names while emitted SQL retains the exact Duck function spelling.

Researched candidate coverage includes JSON, numeric, string, time, and sequence functions.

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

Duck-specific/native features already researched as candidate SwifQL coverage include:

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

Do not introduce PIVOT-specific public wrapper types for columns, ON expressions, aggregates, or ordering when existing SwifQL expressions and paths can model the SQL cleanly.

Ordinary PIVOT source should stay clean and use existing SwifQL expressions, paths, functions, aliases, and ordering concepts.

Required clean source direction:

```swift
SwifQL.pivot(cities)
    .on(cities.column("year"), in: 2000, 2010)
    .using(Fn.sum(cities.column("population")) => "total")
    .groupBy(cities.column("country"))
    .orderBy(.desc(cities.column("country")))
    .limit(2)
```

The dialect renderer, not the user, owns Duck's unqualification requirement in PIVOT grammar zones.

For simplified PIVOT `GROUP BY`, the documented correct source remains a column-name path such as:

```swift
.groupBy(cities.column("country"))
```

DuckDB v1.5.5 accepts column names there and rejects qualified/expression forms. However, after `var query: SwifQLable` existential erasure, the unchanged global `.groupBy(_ fields: SwifQLable...)` surface cannot truthfully become a PIVOT-only compile-time `KeyPathLastPath` constraint without either changing ordinary GROUP BY overload behavior, adding hidden PIVOT routing, or changing the clean call shape. Do not add a global PIVOT-validation overload or wrapper to simulate a static guarantee the erased receiver cannot express.

`KeyPathLastPath` remains established public compatibility/extension surface and remains appropriate for APIs whose own static grammar is genuinely column-name-only. For PIVOT GROUP BY, preserve the generic SQL DSL surface, render correct column paths according to the structural owner, document/native-test the valid Duck grammar, and allow DuckDB to reject dialect-invalid arbitrary expressions rather than distorting established global GROUP BY semantics.

For ON and USING expression regions, use bounded structural semantic render scopes rather than PIVOT-specific expression wrappers. The reconciled diagnostic has established that bounded scopes survive `var SwifQLable`, helpers, copied parts, nesting, independent scopes, and ordered binding collection when the semantic owner can attach the scope to a bounded subtree.

For simplified PIVOT `GROUP BY` and `ORDER BY`, clause ownership remains separate from grammar validity. The structural frame owns qualification/rendering context; it does not attempt to turn the erased global GROUP BY API into a PIVOT-only compile-time grammar checker.

The independent root clause-ownership audit and focused disposable evidence diagnostic have validated the cross-dialect major-version architecture: a generic SQL-region frame selects ownership for open clause kinds through one generic root-frame-aware continuation primitive; dedicated owner-sensitive GROUP BY / ORDER BY parts persist the selected owner; bounded semantic render scopes apply Duck's contextual qualification rules only to the affected children. PIVOT is a consumer of this shared composition architecture, not the owner of it.

The focused Gate B diagnostic passed the required nested SELECT/PIVOT, nested PIVOT, set-result/CTE, copied-`parts`, external-extension, binding-order, QueryParts/builder, raw-composition, and byte-for-byte PostgreSQL/MySQL compatibility matrix. `PIVOT-CLAUSE-OWNERSHIP-001` is closed. This validates the architecture, not broad Duck production implementation; implementation still requires the reconciled and independently audited production plan.

Do not automatically escalate to semantic statement objects. Do not implement Duck-specific frame routing, scan receiver history for PIVOT, use free-floating forward ownership directives, infer ownership from paths/tables, or expose `belong: .pivot` / PIVOT-specific wrappers in ordinary query source.

## Native validation evidence

### DUCK-019 - Native validation is a release gate for grammar-sensitive features

Renderer tests prove SwifQL output, not DuckDB parser/binder/execution acceptance.

For new grammar-sensitive Duck features, native DuckDB validation is required when the API relies on assumptions that string tests cannot prove.

Native DuckDB v1.5.5 validation has already established:

- COLUMNS regex prepared form;
- COLUMNS explicit-name prepared form;
- COLUMNS lambda prepared form;
- corrected nested STRUCT/UNION identifier cases;
- the complete MERGE B1-B11 matrix described in DUCK-020B;
- the complete PIVOT qualification/binding matrix described in DUCK-017.

The broader mandatory native matrix is not yet complete.

UNPIVOT, remaining sequence/macro/ATTACH/COPY cases and any other not-yet-reached mandatory cases must not be described as native-validated until the continuation matrix actually runs.

## DML / DDL and advanced statements

### DUCK-020 - SQL fidelity for advanced statements

Duck DML/DDL support is additive and exact-SQL oriented.

Researched candidate surface includes normal INSERT/UPDATE/DELETE compatibility plus Duck extensions, CREATE/ALTER/DROP forms, schemas, enums, sequences, indexes, MERGE, COPY, macros, and catalog/database statements.

Do not hide unsupported Duck semantics behind PostgreSQL-looking helpers. Examples from research include PostgreSQL index methods and unsupported constraint/foreign-key behaviors that must remain unclaimed unless current Duck documentation/native tests prove support.

The detailed feature matrix should be expanded here as each advanced area completes native validation rather than duplicated in the common dialect owner.

### DUCK-020A - Ordinary DML support and unclaimed boundaries

The verified DuckDB v1.5.5 ordinary-DML contract is:

- `INSERT ... VALUES` and `INSERT ... SELECT` are supported with normal SQL-shaped composition and prepared values. A String supplied as a table target is a structural identifier and does not become a value bind.
- `INSERT ... BY NAME` is supported when the source is a `SELECT`; matching is by source and target column name, including omitted target columns that have defaults. `BY NAME VALUES` is rejected by DuckDB and remains mechanically renderable but unclaimed by SwifQL.
- `INSERT OR IGNORE` and `INSERT OR REPLACE` are supported as their exact SQL identities. SwifQL does not remap either form by dialect or expose them as a portable conflict policy.
- `ON CONFLICT DO NOTHING` without a target and `ON CONFLICT (<column>) DO NOTHING` with a column target are supported. Column-target `DO UPDATE SET` using the `EXCLUDED` source, with an optional `WHERE`, is supported when expressed through the ordinary SQL-shaped `set(_:)` composition.
- Historical `ON CONFLICT ON CONSTRAINT ...` remains mechanically renderable for compatibility, but DuckDB v1.5.5 rejects it as unimplemented; it is unclaimed for Duck.
- `INSERT ... RETURNING` and `DELETE ... RETURNING` support structural columns, `*`, and literal expressions. DuckDB v1.5.5 rejects prepared parameters inside these RETURNING expressions during preparation. SwifQL preserves ordinary binding and does not add runtime validation or rejection for that database limitation.
- Ordinary `UPDATE` `SET`, `FROM`, and scalar-subquery `SET`/`WHERE` forms are supported and remain direct SQL composition. Multi-target `UPDATE` is rejected by DuckDB v1.5.5 and remains mechanically renderable but unclaimed. `UPDATE ... RETURNING` executes in the verified runtime but remains mechanically expressible and unclaimed because the current official Duck UPDATE contract does not document it.
- `DELETE ... USING` supports table sources, an aliased parenthesized subquery source, and multiple comma-separated sources. In the verified qualified RETURNING boundary, target-qualified columns are accepted while source-qualified columns are rejected because the USING source is not visible to RETURNING; the latter remains unclaimed without SwifQL-side runtime rejection. Columns, `*`, literal expressions, and USING composition otherwise remain direct SQL forms.
- Basic `TRUNCATE <table>` is supported, including schema-qualified structural table targets.

These are feature-specific support and unclaimed claims for the verified runtime,
not a general portability promise. The final Duck closure gate must revalidate
these ordinary-DML boundaries, together with the rest of the approved Duck
surface and downstream compatibility, before `.duck` is added to
`SQLDialect.all`.

### DUCK-020B - MERGE direct-composition contract and native boundaries

DuckDB v1.5.5 native validation establishes the following MERGE contract:

- `SwifQL.merge(into:using:on:)` and the incremental
  `SwifQL.merge(into:).using(...).on(...)` form are composition-equivalent
  generic SQL builders. Neither form introduces a Duck-only builder, AST, or
  renderer hook.
- Structural table targets, source tables, aliases, parenthesized source
  queries, prepared predicates, and normal left-to-right binding all work.
- Duck's one- and multi-column `USING (<columns>)` shorthand is supported and
  renders structural last-path identifiers. The public `using(columns:)`
  overload is a structural column-name API: a qualified key path is reduced by
  SwifQL to its last path. Separately, raw qualified source/target expressions
  in Duck's `USING (<columns>)` grammar are native-invalid.
- `WHEN MATCHED`, `WHEN NOT MATCHED`, `WHEN NOT MATCHED BY SOURCE`, and
  `WHEN NOT MATCHED BY TARGET` branches preserve append order and reuse the
  established `.then.update.set(...)`, `.then.delete`, `.then.insert`,
  `.then.insert.byName`, and
  `.then.insert.fields(...).values.values(...)` action vocabulary.
- Conditional branches, multi-column updates, whole-row updates, conditional
  deletes, INSERT BY NAME, explicit-column INSERT values, a BY SOURCE explicit
  column/value INSERT whose values do not depend on a source row, and the
  verified transaction rollback boundary execute with normal prepared
  parameters.
- MERGE `RETURNING` exposes the bare Duck `merge_action` identifier, `*`,
  target columns, and expressions. `merge_action()` is a different unsupported
  function-shaped form and is not synthesized by SwifQL.
- A complete fail-closed B1-B11 matrix verified runtime identity
  `v1.5.5`, prepare/bind/execute status, parameter counts, every bind,
  results/post-state, branch order, transaction behavior, RETURNING visibility,
  BY SOURCE/BY TARGET, INSERT BY NAME, USING shorthand, and the required
  dangerous siblings.

The following remain mechanically renderable but unclaimed or rejected by
DuckDB v1.5.5: raw qualified `USING` shorthand (the public overload emits
unqualified last paths), `MATCHED BY TARGET`, UPDATE/DELETE actions on
`NOT MATCHED BY TARGET`, DELETE on `NOT MATCHED`, bare or source-dependent
INSERT actions on `NOT MATCHED BY SOURCE` because that branch has no source-row
visibility, source-qualified MERGE RETURNING expressions, prepared parameters
inside MERGE RETURNING, and function-shaped `merge_action()`. Explicit
column/value INSERT under `NOT MATCHED BY SOURCE` is supported when its values
are target-independent. These boundaries are native engine behavior; SwifQL
keeps MERGE as direct SQL composition and does not translate it to an upsert
form.

## Catalog paths

### DUCK-021 - Catalog is a SQL namespace concept, not a Duck-branded user concept

Public catalog qualification should use a clean generic SQL namespace API rather than a Duck-branded user concept. Target direction is:

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

The canonical unreleased spelling is already `.duck`; no compatibility alias for `.duckdb` is required because that spelling has not shipped. New Duck API symbols still require the full API review described by DUCK-023.

This rule does not authorize changing established pre-Duck SwifQL APIs used by existing users.

### DUCK-023 - Complete API-surface review before continuing feature implementation

Before any new Duck feature implementation resumes, classify the intended unreleased Duck surface into:

1. reuse existing SwifQL API unchanged;
2. generic clean SQL-concept API;
3. clean inferred helper type that users normally do not name;
4. genuinely Duck-specific implementation symbol using `Duck...` / `duck...`;
5. unresolved UX requiring focused research.

Known areas requiring this review include PIVOT, UNPIVOT, MERGE, COLUMNS, star modifiers, nested values, sequences, macros, catalog paths, sampling helper types, and COPY/ATTACH option types.

The fresh `duck-sql-surface-redesign` research has completed this classification at planning level. Bounded semantic render scope has passed Gate A, and the focused clause-ownership diagnostic has passed Gate B. Production implementation remains blocked only on reconciliation and independent audit of the detailed implementation/migration plan. Future source changes must follow the audited final plan rather than repeating a broad API inventory.

### DUCK-024 - First `.duck` closure boundary

The first release that adds `.duck` to `SQLDialect.all` must cover and native-/compatibility-validate the ordinary application/analytics/schema surface approved by the maintainer: core rendering/binds/values/date exact behavior; paths/catalogs/JSON; exact scalar/nested types and values that do not require the deferred generic `:=` abstraction; high-value exact functions/operators; SELECT-family clauses; GROUPING SETS/ROLLUP/CUBE; future-safe lambdas/list functions; joins; set operations; star/COLUMNS; scope-proven PIVOT/UNPIVOT; DML/RETURNING/MERGE where clean composition is proven; truthful CREATE/ALTER/DROP for tables/schemas/views/types/indexes/constraints; sequences/macros only where they do not require the deferred generic `:=` abstraction; ATTACH/DETACH/USE; COPY; common table/file functions; full DuckDB v1.5.5 native validation; and downstream compatibility validation.

Later typed waves do not block `.duck` closure: INSTALL/LOAD, CREATE SECRET, broad PRAGMA/configuration, CHECKPOINT, VACUUM/ANALYZE administration, SET/RESET VARIABLE, EXPORT/IMPORT DATABASE, SHOW/DESCRIBE/SUMMARIZE convenience, and extension-specific SQL universes.

`SQLDialect.all` remains `[.psql, .mysql]` until that first closure passes.

### DUCK-025 - Generic SQL `name := expression` is deferred

Do not introduce a premature generic `name := expression` public abstraction in the current Duck wave. STRUCT/UNION value constructors, macro defaults/named calls, or other features that strictly require a reusable first-class `:=` abstraction are deferred unless they can be represented cleanly through an already-established exact API without inventing a generic named-argument layer.

Do not conflate SQL `name := expression` with table-function `name = value` options. The future generic `:=` design remains explicit technical/API debt, not an implementation shortcut for this closure.
