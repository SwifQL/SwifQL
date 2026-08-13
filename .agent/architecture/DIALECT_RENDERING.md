# Dialect Rendering Architecture

This file is the sole owner of cross-dialect `DIALECT-*` rules.

Per-dialect details have separate owners under `architecture/dialects/` and should not be duplicated here:

- `dialects/DUCK.md` -> `DUCK-*`
- `dialects/POSTGRES.md` -> `POSTGRES-*`
- `dialects/MYSQL.md` -> `MYSQL-*`

Load this base owner plus only the dialect-specific owner needed by the task. Cross-dialect audits may load more than one dialect owner deliberately.

## Verified common model

`SQLDialect` is an open class. Equality compares dialect identity through `id`.

The dialect is selected at preparation time:

```swift
query.prepare(dialect)
```

The public DSL should normally stay SQL-shaped and dialect-transparent. Differences in identifier spelling, key-path rendering, values, dates, bind markers, collection syntax, and other exact syntax belong behind dialect-aware preparation rather than database-prefixed wrappers scattered through ordinary query code.

`.any` is a base `SQLDialect` intended only for short truly universal SQL. It is not a substitute for a concrete dialect when parts require database-specific rendering.

`SQLDialect` is public/open compatibility surface. New contextual hooks must preserve existing external subclasses where technically possible, normally by adding forwarding overloads rather than replacing established signatures.

## Ownership boundary

This base file owns:

- common dialect identity/factory rules;
- common hook architecture;
- bind-syntax ownership boundaries;
- hybrid/operator dispatch rules;
- semantic/context-aware rendering policy;
- custom/open dialect compatibility;
- routing to per-dialect owners.

Per-dialect owners contain:

- canonical public dialect factory spelling;
- internal dialect id;
- identifier/string/date/data behavior;
- collection/JSON/type semantics;
- exact feature support and limitations;
- native validation evidence;
- dialect-specific UX and naming constraints;
- dialect-specific pre-release blockers.

Prepared marker traversal, collected-value order, and formatter mechanics remain owned by `QUERY_PREPARATION.md`.

Public API identity, naming, and dialect-transparent UX remain owned by `DSL_DESIGN_AND_UX.md`.

## Rules

### DIALECT-001 - Dialect hooks

Dialect-sensitive rendering stays behind `SQLDialect` hooks used by the single preparation pipeline.

Do not create an independent renderer for one database when the existing parts/preparation architecture can express the behavior cleanly.

### DIALECT-002 - Support claims are feature-specific

A dialect being implemented does not imply that every SQL construct or another dialect's historical helper is portable to it.

Support claims must match current source, tests, and where required native database evidence.

### DIALECT-003 - Universal dialect limits

`.any` is only for short universal SQL such as transaction control when no dialect-sensitive part is involved.

Do not use `.any` to avoid defining proper behavior for a supported dialect.

### DIALECT-004 - Compatibility research

Adding or materially extending a dialect requires explicit research of at least:

- identifiers and quoting;
- strings and primitive values;
- dates/timestamps/time zones;
- bind syntax;
- arrays/lists/nested values;
- JSON/key paths;
- casts/types and inference;
- DML/DDL;
- operators/functions;
- hybrid behavior;
- native database-specific features;
- preparation limitations;
- test and `SQLDialect.all` impact.

Similarity to another database is not evidence.

### DIALECT-005 - Bind ownership split

Dialect-specific placeholder spelling belongs to the dialect owner.

Traversal order, marker replacement, value collection, and prepared-output mechanics belong to `QUERY_PREPARATION.md`.

### DIALECT-006 - Hybrid behavior must be explicit

Every supported dialect needs an explicit representation for `SwifQLHybridOperator` or any future dialect-polymorphic operator mechanism.

A new dialect must never silently inherit another dialect's syntax as a fallback.

### DIALECT-007 - Rendering follows the public design contract

Dialect hooks may adapt the syntax/qualification required to express the same modeled SQL idea, but must not silently substitute a different SQL construct or degrade semantics.

Use `DSL_DESIGN_AND_UX.md` for exact-SQL identity, convenience boundaries, and dialect-transparent user-facing API rules.

### DIALECT-008 - Semantic context beats token heuristics

When the same structured part requires different rendering in a particular SQL grammar position, pass explicit semantic/contextual information through the parts/preparation pipeline rather than guessing context by scanning neighboring raw operator strings.

Do not accumulate database-specific `previous token` / `next token` parsing heuristics inside `prepare(_:)` as a normal architecture pattern.

The exact contextual-rendering primitive must remain compatible with the existing parts pipeline and open `SQLDialect` surface.

### DIALECT-009 - Preserve custom dialect subclasses

When evolving an existing `SQLDialect` hook, prefer an additive context-aware overload whose default implementation forwards to the established hook.

Example direction:

```swift
open func keyPath(_ keyPath: SwifQLPartKeyPath) -> String

open func keyPath(
    _ keyPath: SwifQLPartKeyPath,
    context: SwifQLRenderContext
) -> String {
    keyPath(keyPath)
}
```

The concrete context type/mechanism is an architecture decision and should be introduced only with reviewed source/tests. The compatibility principle in this rule is already stable.

### DIALECT-010 - Dialect-transparent ordinary query source

The selected dialect should normally affect preparation/rendering, not force ordinary user queries to name database implementation wrappers.

A construct being currently supported by only one dialect does not automatically justify a database-prefixed public API.

If the common parts pipeline lacks the semantic information required to render a clean API correctly, improve the shared architecture instead of pushing renderer limitations into user code.

### DIALECT-011 - Per-dialect detail ownership

Do not expand this base file with feature matrices or database-specific syntax details.

Route those facts to exactly one dialect owner under `architecture/dialects/` and link to it from supporting docs.

This keeps normal context loading bounded while allowing each dialect owner to become detailed over time.
