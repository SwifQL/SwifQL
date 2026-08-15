# DSL Design and UX

This document is the sole owner of SwifQL's durable public-API design and developer-experience principles. It explains how SwifQL should feel to use, how new SQL surfaces should be modeled, and how to decide whether an API belongs in the generic DSL, a dialect-specific surface, a semantic convenience layer, or an explicit raw escape hatch.

Detailed part composition lives in `DSL_COMPOSITION.md`. Dialect rendering mechanics live in `DIALECT_RENDERING.md`. Preparation mechanics live in `QUERY_PREPARATION.md`. Builder state/materialization lives in `BUILDERS_AND_QUERY_PARTS.md`.

## Primary design gates

`DESIGN-001` and `DESIGN-015` are the first two gates for every new public API or internal architecture that can affect query composition.

1. **SQL DSL first:** the user should feel that they are writing the SQL idea directly in Swift, with type safety and composition, not operating a database-driver object model or accommodating renderer internals.
2. **Composition invariance:** the same valid query must keep the same semantics when written as one fluent chain or assembled incrementally through variables, conditions, helpers, nested expressions, and separate methods/files.

If a proposal violates either gate, reject or redesign it before implementation even if it would be easy to test or internally convenient.

## DESIGN-001 — SQL-first mental model

SwifQL is type-safe Swift for writing SQL. It is not an ORM, database abstraction language, or semantic query language that hides SQL behind unrelated concepts.

The primary user mental model is:

> I already know the SQL dialect. SwifQL lets me write that SQL safely and compositionally in Swift.

A database programmer should be able to read a SwifQL query and predict the generated SQL without learning hidden translation rules.

## DESIGN-002 — Public API mirrors SQL vocabulary

A public API named after a concrete SQL keyword, type, function, operator, clause, or statement represents that concrete SQL construct.

Swift naming and SQL spelling are separate concerns:

- public Swift identifiers follow normal Swift lowerCamelCase / UpperCamelCase conventions;
- emitted SQL preserves the database's real keyword/function/type spelling, including `snake_case` or uppercase where the SQL grammar uses it;
- do not copy SQL underscores into new Swift API names merely because the SQL function contains underscores.

Examples:

- `Type.integer` represents SQL `INTEGER` and must not silently mean `SERIAL`, `IDENTITY`, or an implicit sequence-backed integer.
- `Fn.jsonBuildArray(...)` represents SQL `json_build_array(...)`; it must not silently become another dialect's differently named function.
- `Fn.jsonGroupArray(...)` represents DuckDB `json_group_array(...)`.
- `Fn.div(...)` represents SQL `div(...)`; it must not silently become `divide(...)` or `//`.
- `.qualify(...)` represents `QUALIFY`.
- a builder/entry point named for `MERGE` represents SQL `MERGE INTO`, not a generic upsert abstraction that happens to render MERGE.

When a dialect uses a different SQL construct, add that dialect's real construct as its own typed API rather than reinterpreting an existing SQL-named API.

## DESIGN-003 — API taxonomy

Every new public surface should fit one of these categories.

### A. Generic exact-SQL API

Use when the same SQL concept and grammar are intentionally shared across supported dialects.

Examples:

- SELECT
- WHERE
- EXISTS
- UNION
- common exact function names where name and argument grammar genuinely match.

The API should use the SQL vocabulary directly.

### B. Dialect-specific exact-SQL API

Use when a construct belongs to one dialect or has a materially dialect-specific grammar.

Dialect-specific support does **not** automatically justify a database-prefixed public Swift API. The ordinary user-facing DSL should name the SQL concept cleanly and let the selected dialect own rendering differences whenever that can be done truthfully.

Examples of preferred direction:

- `SwifQL.pivot(...)`, not a database-prefixed PIVOT entry point;
- `SwifQL.merge(...)`, not a database-prefixed MERGE entry point;
- `Path.Catalog(...)` when the concept being modeled is a catalog rather than the database product itself;
- clean `Fn.*` / `Type.*` symbols whose exact support is documented/tested per dialect.

A database prefix is appropriate only when the API intentionally exposes database identity, when incompatible same-named concepts cannot share a truthful Swift surface, or for implementation symbols where the distinction materially improves ownership/clarity.

Historical released forms such as `PostgresArray` / `PgArray` remain compatibility surface and are not a naming requirement for new dialect work.

For DuckDB-specific Swift implementation symbols that genuinely require a database prefix, use `Duck...` for types and `duck...` for helpers/functions. Do not introduce new `DuckDB...` / `duckDB...` Swift symbol prefixes. The canonical Swift dialect factory is `SQLDialect.duck`, so ordinary preparation is `prepare(.duck)`. Keep the real database spelling only where the value is actual database identity rather than Swift API naming, such as the internal dialect id `"duckdb"` and human-facing prose.

Dialect-specific functions may still live under clean `Fn` names when the public name is the exact SQL function name; source filenames may use focused `Duck` grouping where useful.

### C. Explicit semantic/convenience API

Use sparingly when the API intentionally abstracts a user intent rather than naming one concrete SQL construct.

Its name must make that semantic/convenience role obvious.

Existing examples include:

- `Type.auto(...)`
- `OrderByItem.random` / `SwifQLHybridOperator.random`.

A semantic convenience may render dialect-specific syntax only when it names a genuinely semantic intent rather than collapsing distinct exact SQL constructs. Each dialect branch must be explicit and tested. Legacy conveniences do not authorize creating new hidden translations in SQL-named APIs.

A convenience must not become a portability facade that silently swaps one named SQL construct for another. For example, PostgreSQL `decode(..., 'base64')` and Duck/MySQL `from_base64(...)` are distinct SQL functions and therefore require distinct exact SQL APIs. Selecting a dialect may change harmless spelling/casing or syntax required by the same exact construct, but it must not translate `decode` into `from_base64` or vice versa.

### D. Explicit expert escape hatch

Use `.raw`, custom types, or similarly explicit APIs when the user intentionally supplies SQL outside the typed surface.

Raw/custom APIs are escape hatches, not the implementation strategy for ordinary first-class SQL features.

## DESIGN-004 — Transparency over magical portability

SwifQL does not promise that every API is portable to every database.

Prefer a truthful SQL API with an explicit dialect support boundary over a generic-looking API that approximates another database's feature. A dialect-specific support boundary does not by itself require a database-prefixed Swift name; DESIGN-014 governs the user-facing shape.

Rules:

- do not rename functions/types/statements behind the user's back;
- do not translate one exact named SQL function/construct into a differently named construct merely because another dialect offers similar semantics;
- dialect-specific casing of the same SQL function name may vary where the databases spell that same construct differently, e.g. `FROM_BASE64` versus `from_base64`, while the Swift API remains the exact camelCase `fromBase64`;
- do not degrade semantics silently;
- do not claim support merely because another dialect parser might accept similar text;
- do not introduce automatic lifecycle behavior, such as hidden sequence creation, unless the public API explicitly models that lifecycle;
- unsupported or unverified SQL remains unclaimed rather than guessed.

Mechanical rendering by the historical non-validating preparation pipeline is not itself a support claim.

## DESIGN-005 — Composability before new abstraction

Before adding a new builder or fluent API, verify whether existing `SwifQLable` composition already expresses the exact SQL naturally.

Prefer reusing the existing DSL when the resulting Swift remains clear and faithful to SQL.

Examples discovered during DuckDB design:

- FROM-first SQL is already naturally representable as `SwifQL.from(...).select(...)`; a separate FROM-first builder would duplicate the DSL.
- `GROUP BY ALL` is naturally representable through existing composition when `ALL` is already an exact SQL part.

Create a new API only when it adds one of these real benefits:

- missing SQL vocabulary;
- typed grammar constraints;
- correct clause placement/state ownership;
- safe identifier/value handling;
- materially better readability without hiding SQL.

Do not create abstractions merely for symmetry between dialects.

## DESIGN-006 — Swift call shape should resemble SQL grammar

Method names, argument order, labels, and builder phases should make the corresponding SQL easy to recognize.

Guidelines:

- preserve SQL clause order where practical;
- use SQL terms as labels (`on`, `using`, `returning`, `groupBy`, `qualify`, etc.);
- use distinct APIs for distinct SQL grammar forms rather than runtime guessing;
- model mutually exclusive grammar states with types/enums/initializers where that prevents invalid SQL;
- do not infer one SQL mode from the runtime type or value of an unrelated argument;
- when one SQL function has multiple dialect-specific grammar forms but the same exact function name, prefer additive overloads whose Swift signatures mirror those forms.

The DSL should remain readable left-to-right as SQL.

## DESIGN-007 — Local implementation style reference

The current PostgreSQL implementation is the primary local best-practice reference for how new dialect code should be shaped and organized.

Useful patterns:

- focused `SQLDialect` subclass overrides for true dialect hooks;
- exact SQL function names through `Fn.Name` and direct typed-part composition;
- historical specialized APIs such as `PostgresArray` are compatibility evidence only, not naming precedent for new dialect surfaces;
- semantic source organization under `Dialect/`, `Functions/`, `Builders/`, `Parts/`, `Path/`, and `SwifQLable+Parts/` rather than a separate mini-framework per database;
- focused exact-SQL tests plus realistic composed queries.

Copy the architecture/style, not PostgreSQL semantics or historical quirks. Current official documentation for the target database is authoritative for target-dialect SQL.

## DESIGN-008 — Type safety protects structure, not SQL knowledge

Type safety should help users construct valid SQL structure while keeping the SQL visible.

Good uses of types include:

- enums for finite SQL modes;
- typed join modes;
- typed ordering/nulls options;
- typed nested database types;
- builders that make invalid clause combinations difficult or impossible;
- safe separation between identifiers, inline structural SQL, and bound values.

Avoid type systems that replace familiar SQL vocabulary with a second conceptual language.

A user who knows SQL should not need to learn an unrelated SwifQL ontology before being productive.

## DESIGN-009 — Values and identifiers remain explicit

SwifQL distinguishes SQL structure from dynamic data.

- Dynamic values should use the normal value/binding pipeline when SQL grammar permits.
- Identifiers use identifier-aware typed parts and dialect quoting.
- Trusted structural SQL may use explicit operator/custom/raw mechanisms only where appropriate.
- Do not interpolate untrusted runtime values or identifiers into raw SQL strings to simplify a builder implementation.

Swift-native values such as `Date` may have dialect-specific literal/value rendering when the public API genuinely names that Swift value rather than a concrete SQL function. This does not authorize a new semantic wrapper to choose among differently named SQL functions. Historical direct `Data.parts` remains a protected compatibility shape; new Duck binary/base64 support must use exact SQL APIs and normal value/binding primitives rather than a cross-dialect `binary(...)` facade.

## DESIGN-010 — Backwards compatibility is part of UX

For this established library, predictable upgrades are a developer-experience requirement.

The major-version number is not permission to gratuitously redesign the established query DSL. Users may have hundreds or thousands of SwifQL queries, so ordinary existing query source should continue to compile without mechanical rewrites across upgrades whenever the existing API can be preserved safely.

Rules:

- existing public query DSL names, argument labels/order, fluent call shapes, and reference/value usage remain source compatible unless a separately approved unavoidable correctness/safety conflict proves otherwise;
- a major release may strengthen internal invariants, concurrency guarantees, diagnostics, or add new APIs, but those changes should be implemented behind the existing DSL surface when technically possible;
- existing PostgreSQL/MySQL output remains byte-for-byte stable;
- existing tests are regression contracts;
- new dialect support is additive;
- do not repair a new-dialect implementation by rewriting legacy SQL expectations;
- when a public signature change appears necessary, first prove that a source-compatible wrapper/view/overload cannot preserve the existing call site, then return the material decision to the maintainer before mutation.

A deliberate major redesign is a separate product/API decision. Merely preparing a major release does not authorize opportunistic DSL breakage.

## DESIGN-011 — Testing proves both SQL fidelity and real use

A new public SQL surface is not complete with only one snapshot-like assertion.

Testing should cover:

1. the exact SQL construct/name/grammar the API promises;
2. focused edge cases and overloads;
3. realistic composed queries that resemble application code;
4. all dialects for which support is deliberately claimed;
5. bind placeholder and value ordering where dynamic values are involved;
6. backwards compatibility for shared infrastructure changes.

Dialect-specific APIs are tested only for the dialects deliberately supported. Historical mechanical rendering in another dialect does not create a new support contract.

See `TESTING_RULES.md` for the detailed testing policy.

## DESIGN-012 — Swift naming is idiomatic Swift, SQL spelling stays exact

New public Swift API uses standard Swift naming conventions even when the corresponding SQL token/function uses underscores or uppercase spelling.

Rules:

- public methods, properties, variables, enum cases, and function helpers use `lowerCamelCase`;
- public types/protocols use `UpperCamelCase`;
- SQL `snake_case` is represented in the emitted SQL string/`Fn.Name`/operator part, not copied into the Swift symbol name;
- acronym/capitalization choices follow normal readable Swift style rather than reproducing database casing mechanically;
- labels also use idiomatic Swift naming while preserving the SQL concept they represent.

Examples:

- Swift `Fn.jsonBuildArray(...)` -> SQL `json_build_array(...)`;
- Swift `Fn.jsonGroupArray(...)` -> SQL `json_group_array(...)`;
- Swift `Fn.generateSeries(...)` -> SQL `generate_series(...)`;
- Swift `Fn.rowNumber()` -> SQL `row_number()`;
- Swift `Fn.fromUnixtime(...)` may emit SQL `FROM_UNIXTIME(...)` when that exact function is being represented.

The repository contains historical public `snake_case` `Fn` symbols. They are legacy compatibility surface, not a naming precedent. The existing supported surface has completed this additive migration: every such public function/name symbol receives a canonical camelCase counterpart with identical SQL behavior, while the old snake_case symbol remains source-compatible and is marked `@available(*, deprecated, renamed: "...")`. The same policy applies to any historical symbol encountered in future maintenance; do not remove the old symbol in a non-major release.

The camelCase conversion is deterministic: remove underscore separators and capitalize the first letter of each following underscore-delimited token without inventing new word boundaries inside an existing SQL token. Examples: `json_build_array` -> `jsonBuildArray`, `array_agg` -> `arrayAgg`, `row_number` -> `rowNumber`, `generate_series` -> `generateSeries`, `jsonb_agg` -> `jsonbAgg`, `make_timestamptz` -> `makeTimestamptz`, `to_tsvector` -> `toTsvector`, `from_unixtime` -> `fromUnixtime`.

Canonical implementations and ordinary tests/docs use the camelCase stable API. Deprecated snake_case declarations delegate to the canonical camelCase implementation and must generate byte-for-byte identical SQL. New work normally must not introduce additional public snake_case Swift identifiers. A maintainer-approved compatibility alias may be added only as an immediately deprecated `renamed:` bridge to the canonical camelCase API; it must never become the documented/canonical surface. For the planned exact SQL `from_base64` helper, the canonical Swift spelling is `Fn.fromBase64(...)`, while `Fn.from_base64(...)` is only a deprecated renamed bridge if included by the approved migration plan.

## DESIGN-013 — Decision checklist for a new API

Before implementing a new public API, answer these questions in order:

1. What exact SQL should the user recognize?
2. Is this the same SQL construct/grammar across dialects, or a dialect-specific construct?
3. Does the current composable DSL already express it clearly and safely?
4. If not, is the missing piece a token/fluent part, a typed expression, a builder/state model, a type, a function helper, or a true dialect-rendering hook?
5. Does the proposed Swift name correspond to the emitted SQL, or is it an explicitly named semantic convenience?
6. Is any hidden substitution, semantic degradation, or runtime guessing occurring?
7. Can dynamic values and identifiers remain in the normal safe/bound pipelines?
8. Does the source location match existing repository organization and PostgreSQL-style precedent?
9. What focused exact-SQL tests prove the API contract?
10. What realistic query proves the API composes naturally?
11. Could the implementation change existing PostgreSQL/MySQL output or source compatibility?
12. Is the target-dialect behavior established by current official documentation rather than similarity or memory?

If these questions do not have clear answers, research/plan the API further before implementation.

## DESIGN-014 — Dialect-transparent user-facing DSL

Dialect support should normally be visible at preparation/execution time, not through database implementation wrappers scattered through ordinary query source.

Rules:

- when the user is expressing an SQL concept, prefer the clean SQL-shaped SwifQL API regardless of which supported dialect will render it;
- use the selected `SQLDialect`, structured parts, dialect hooks, or other reviewed contextual rendering mechanisms to adapt syntax/qualification where the SQL concept is the same but the dialect grammar differs;
- do not make users replace normal table/column/function/order expressions with database-prefixed wrappers merely to satisfy a renderer limitation;
- database-specific implementation types may exist when needed, but ordinary call sites should not have to name them when type inference or a clean generic entry point can hide them;
- dialect-transparent rendering may adapt syntax/qualification/casing required by the same exact modeled SQL construct, but it must not silently substitute a differently named SQL function/statement/type/operator or degrade semantics in violation of DESIGN-002/004;
- if the existing parts pipeline lacks enough semantic context to render a dialect correctly, improve the shared rendering architecture rather than accumulating neighboring-token heuristics or one-off database wrappers.

The review target is simple: normal Swift query source should read like the SQL idea the user intends, not like an object model for a particular database driver.

## DESIGN-015 - Query semantics survive incremental composition

Public query APIs must remain correct when users compose queries incrementally rather than as one fluent expression.

Equivalent query structure must preserve equivalent semantics when assembled through any reasonable combination of:

- a single fluent chain;
- `var query: SwifQLable` reassignment;
- `if` / `guard` controlled clause inclusion;
- helper methods returning `SwifQLable` fragments or expressions;
- fragments created in different methods/files and combined later;
- nested expressions, functions, subqueries, and builders.

Do not implement meaning as ambient builder mode, source-order side state, or an assumption that related method calls occurred consecutively in Swift. Semantic metadata needed by rendering must travel with the composed part/expression that owns it.

Do not introduce generic hidden statement-routing into established methods such as `groupBy`, `orderBy`, `limit`, or `returning` merely to make a new unreleased builder retain private state through type erasure. That changes the meaning and structural behavior of old DSL entry points for the benefit of a new implementation layer. First seek a design where the new construct composes honestly through ordinary parts and scoped metadata.

For the current Duck PIVOT/UNPIVOT/MERGE design wave, semantic render scopes are the approved mechanism and focused semantic-statement/structural-clause routing is explicitly rejected unless a later maintainer decision reopens that architecture after new evidence. A scope-only compile/downstream diagnostic must prove the composition model before production planning is executable.

Focused semantic statement representation remains only a future architecture escalation boundary for genuinely different evidence, not a fallback that an implementation task may choose automatically.

This does not make invalid SQL valid. If a caller conditionally omits a required parent construct but still appends a clause that only makes sense inside that construct, the resulting query may correctly be invalid. The invariant is that equivalent valid composition shapes render identically, not that SwifQL guesses missing grammar.

## DESIGN-016 - Preserve established public extension contracts deliberately

Public helper protocols and extension-oriented surfaces are compatibility contracts even when they look like implementation utilities.

`KeyPathLastPath` is established public API and is used by public query surfaces such as RETURNING, conflict targets, constraints, key paths, and path types. It may also be useful as a precise grammar constraint for new clauses such as Duck simplified PIVOT `GROUP BY`.

Do not remove or replace such a protocol merely to modernize internal architecture. If a future major version has a materially better replacement, first provide the clearest practical bridge/deprecation path and include a concise migration note with extension examples for downstream users who may conform their own local types.

New internal architecture should expose a small public extension point when that falls naturally from the design and remains type-safe/maintainable. Do not contort the core model or leak mutable internals solely to make every mechanism externally customizable.

## DESIGN-017 - Existing users do not pay for internal evolution

SwifQL is an established library whose users may own hundreds or thousands of queries and private extension code. Repository-visible call sites are only a fraction of the real compatibility surface.

Therefore:

- existing PostgreSQL/MySQL query source must continue compiling unchanged unless a separately approved bug fix proves a specific old behavior wrong;
- established generated PostgreSQL/MySQL SQL and binding order remain byte-for-byte regression contracts unless that same explicitly approved bug fix changes them;
- downstream `extension SwifQLable`, custom operators, helper methods, public-protocol conformances, path abstractions, and `SQLDialect` subclasses are first-class compatibility concerns even when their source cannot be inspected here;
- internal data-shape changes must not silently alter overload resolution, `parts` composition, public protocol meaning, or dialect-hook dispatch relied on by downstream code;
- a new feature must adapt to established contracts whenever that can be done cleanly; established users must not be forced to rewrite their DSL merely because a new internal model would be easier for the implementation;
- a major release is not a waiver for avoidable breakage. Use a breaking change only when the old public contract itself must change for a demonstrated correctness/design reason and no clean source-compatible path exists;
- when a breaking change is genuinely unavoidable, document the exact reason, migration path, and downstream-extension impact before implementation.

The standard is not merely "our test suite still passes." The standard is that a normal user updating SwifQL should not inherit a debugging project because the library changed its internals.
