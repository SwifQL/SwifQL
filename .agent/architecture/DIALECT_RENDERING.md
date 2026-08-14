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

Preserve the established public two-argument PostgreSQL/MySQL initializer for downstream source compatibility. A future additive three-argument initializer may provide an explicit Duck representation. Before Duck reaches final closure, separately decide/document what preparing an old two-argument custom hybrid with `.duck` means.

A new dialect support claim must not rely on another dialect's syntax as semantic evidence.

### DIALECT-007 - Rendering follows the public design contract

Dialect hooks may adapt the syntax/qualification required to express the same modeled SQL idea, but must not silently substitute a different SQL construct or degrade semantics.

Use `DSL_DESIGN_AND_UX.md` for exact-SQL identity, convenience boundaries, and dialect-transparent user-facing API rules.

### DIALECT-008 - Semantic context beats token heuristics

When the same structured part requires different rendering in a particular SQL grammar position, pass explicit semantic/contextual information through the parts/preparation pipeline rather than guessing context by scanning neighboring raw operator strings.

Do not accumulate database-specific `previous token` / `next token` parsing heuristics inside `prepare(_:)` as a normal architecture pattern.

The approved mechanism is a structural semantic render scope carried with the affected nested parts. Scope is metadata about the grammar role of those parts, not ambient mutable state on a builder/query and not begin/end raw tokens.

Render scopes must be attached by the semantic owner that actually needs contextual rendering. Do not globally wrap ordinary predicates, arithmetic, LIKE/IN/BETWEEN/NULL operators, or other established expression constructors merely so one dialect can infer a grammar position. If a scope leaks into unrelated structural consumers and needs compatibility unwraps or special-case bridges, that is evidence that the scope was attached at the wrong layer and the design must be reconsidered.

The canonical public Duck factory is `SQLDialect.duck`; the product identity remains DuckDB and the internal dialect id may remain `"duckdb"`.

A scoped part must remain one composable structural unit when it is copied, appended, stored in a `SwifQLable` variable, returned by a helper, conditionally included, nested inside a function/subquery, or assembled later in another method. Rendering semantics must therefore not depend on one uninterrupted fluent call chain or on neighboring clauses remaining adjacent in the original Swift source.

Preparation should recursively render nested scoped parts with a value-semantic render-context stack while preserving one shared ordered binding/value collection state. Entering a scope produces a derived context for its children; leaving it restores the parent context naturally through value semantics rather than mutable global/query state.

The scope primitive must remain compatible with the existing parts pipeline and established `SQLDialect` hooks.

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

Context-aware overloads should continue to forward to established hooks by default so existing behavior does not need to understand new scopes.

Current source exposes a public `SQLDialect.init()`. The external-consumer fixture verified custom subclass construction from another module and the additive context-aware hook path. Future hook changes must preserve that source-compatible boundary.

### DIALECT-010 - Dialect-transparent ordinary query source

The selected dialect should normally affect preparation/rendering, not force ordinary user queries to name database implementation wrappers.

A construct being currently supported by only one dialect does not automatically justify a database-prefixed public API.

If the common parts pipeline lacks the semantic information required to render a clean API correctly, improve the shared architecture instead of pushing renderer limitations into user code.

### DIALECT-011 - Per-dialect detail ownership

Do not expand this base file with feature matrices or database-specific syntax details.

Route those facts to exactly one dialect owner under `architecture/dialects/` and link to it from supporting docs.

This keeps normal context loading bounded while allowing each dialect owner to become detailed over time.

### DIALECT-012 - Render scopes are extension-friendly without exposing renderer internals

The render-scope abstraction should provide a narrow public, value-semantic extension point when that can be done without exposing mutable preparation state or requiring third-party code to invent an unknown `SwifQLPart` that the core renderer would silently drop.

The current narrow extension point is the public, value-semantic `SwifQLRenderScope(namespace:name:)` plus `SwifQLable.scoped(_:)`. `SwifQLRenderContext` is public and read-only, while the concrete scoped part and recursive renderer remain library-owned. A downstream module can define a semantic scope, wrap a normal `SwifQLable`, and observe that scope through an additive context-aware dialect hook without relying on mutable ambient state.

Keep scope identifiers namespaced and value-semantic. Do not expose mutable preparation state, raw global strings with collision-prone semantics, or unknown-part escape hatches.

Extensibility is a design goal, not permission to add unsafe escape hatches. If a clean public extension point would require leaking renderer internals or false compatibility guarantees, keep that portion internal until the underlying API can support it honestly.

### DIALECT-013 - Semantic statement representation is an escalation path, not a foundation

Render scopes solve local contextual rendering differences while preserving the existing parts pipeline. They are not required to model every possible cross-dialect statement transformation forever.

Do not pre-install generic semantic-statement routing into established methods such as `groupBy`, `orderBy`, `limit`, or `returning` merely because a future unreleased builder might benefit from hidden state retention through type erasure. That changes old composition semantics for speculative future needs and is not an acceptable foundation.

Only if verified dialect grammar later requires structural reordering, omission, duplication, or whole-statement decisions that cannot be expressed truthfully by ordinary/scoped parts may a focused semantic statement representation be proposed. That proposal requires its own research, compatibility analysis, plan audit, and maintainer approval before implementation.

Any future semantic statement representation must re-enter the same recursive preparation/binding pipeline and must not become a generalized full-query AST or parallel renderer unless a separate architecture decision explicitly proves that such a redesign is required.

This is a documented extension boundary, not current technical debt and not permission to build the layer preemptively.
