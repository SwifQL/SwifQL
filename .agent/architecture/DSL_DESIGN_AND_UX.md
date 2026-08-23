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

### Atomic keyword composition versus semantic clause APIs

When SQL grammar is only a sequence of independently meaningful keywords or modifiers, the public DSL should preserve those atoms as independently composable steps instead of inventing a camelCase convenience for every fixed phrase.

Preferred direction for pure keyword composition:

```swift
SwifQL.create.or.replace.table
SwifQL.insert.or.ignore.into
```

Do not add phrase-collapsing APIs such as `orReplace` or `insertOrIgnoreInto` merely to concatenate a fixed sequence of SQL keywords. Otherwise the DSL becomes a fluent wrapper whose API surface grows as the Cartesian product of keyword combinations instead of remaining direct SQL composition.

This rule does **not** mean that every multi-word SQL phrase must be split into one Swift property per keyword. A combined API is correct when it performs one concrete SQL/DSL operation with its own operands, arguments, structural ownership, or typed semantic role.

Examples:

```swift
query.groupBy(a, b)
query.orderBy(OrderByItem(a, .desc))
query.where(predicate)
query.returning(a, b)
```

`groupBy(...)` and `orderBy(...)` are clause constructors: they accept clause content, own clause structure, and perform a concrete operation. Writing `.group.by(...)` or `.order.by(...)` would make the DSL less clear without exposing any additional useful composition.

A combined public symbol is therefore justified when it represents something more than fixed keyword concatenation, for example:

- a clause/statement constructor with arguments or owned child structure, such as `groupBy(...)`, `orderBy(...)`, or `returning(...)`;
- one concrete SQL identifier/function/type name whose spelling maps to one SQL identity, such as Swift camelCase for a snake_case SQL function or identifier;
- a real multi-keyword SQL operator or grammar construct with its own operand/argument semantics, where the phrase acts as one semantic operation rather than arbitrary modifier chaining;
- a typed value or builder mode that intentionally represents one semantic choice, such as a join-mode value;
- a released historical compatibility surface that cannot be removed without an independently approved breaking change.

The review question is: **if the combined Swift symbol disappeared, would anything be lost besides spelling several independent SQL keywords separately?** If the answer is no, prefer atomic composition. If the symbol owns arguments, structure, validation, typing, or a real semantic operation, a combined API may be the cleaner SQL DSL.

Also check whether an existing semantic constructor already owns the real operation. If it does, do not create a Cartesian family of sibling methods by baking modifiers into the method name when those modifiers can remain atomic or typed inputs. For example, if `join(mode, target)` already owns JOIN construction, prefer adding an exact typed join mode over adding `naturalJoin`, `naturalLeftJoin`, `naturalFullOuterJoin`, and similar siblings. Likewise, if direct INSERT composition already has `.insert`, `.into`, target, and field-list primitives, do not add `insertOrIgnoreInto` / `insertOrReplaceInto` merely to pre-compose fixed modifiers.

Even for justified combined APIs, do not collapse additional optional modifiers into the name when they can compose independently. New unreleased APIs that merely collapse keyword sequences should be corrected directly before release rather than preserved with compatibility aliases.

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

## DESIGN-012 — Swift naming is SQL-shaped camelCase, SQL spelling stays exact

SwifQL is an SQL DSL. Its public Swift names should remain visually and lexically close to the SQL a database engineer already knows while still following Swift camelCase syntax.

Canonical Swift naming therefore **preserves SQL vocabulary while exposing the useful internal components of that vocabulary**. CamelCase may split a glued database token into recognizable SQL-derived pieces. True abbreviations use one consistent position-aware casing rule, while ordinary shortened fragments remain ordinary camelCase components. The API must not translate an SQL fragment into a different English word.

Rules:

- public methods, properties, variables, enum cases, function helpers, and public argument labels use `lowerCamelCase`; public types/protocols use `UpperCamelCase`;
- SQL underscore separators become camelCase boundaries, then each SQL-derived component uses the repository's casing rules: `json_build_array` -> `jsonBuildArray`, `grouping_id` -> `groupingId`, `concat_ws` -> `concatWS`, `from_json` -> `fromJSON`, `read_csv` -> `readCSV`, `read_json` -> `readJSON`, `ts_rank_cd` -> `tsRankCD`;
- when one SQL token visibly concatenates recognizable pieces, Swift exposes those boundaries while retaining the SQL-derived pieces: `setseed` -> `setSeed`, `nextval` -> `nextVal`, `currval` -> `currVal`, `initcap` -> `initCap`, `isfinite` -> `isFinite`, `localtime` -> `localTime`, `localtimestamp` -> `localTimestamp`, `timeofday` -> `timeOfDay`, `lpad` -> `lPad`, `btrim` -> `bTrim`, `strpos` -> `strPos`, `substr` -> `subStr`, `ntile` -> `nTile`;
- selected compact SQL tokens are themselves decomposed where the useful database vocabulary is clearer as multiple Swift components: `tsvector` -> `ts + vector`, `tsquery` -> `ts + query`, `timestamptz` -> `timestamp + tz`, `recordset` -> `record + set`, `regexp` -> `reg + exp`;
- do **not** expand or translate SQL abbreviations into different words merely to make the Swift name more descriptive: `val` stays `Val`, `curr` stays `curr`, `l`/`r` stay `l`/`r`, `elems` stays `Elems`, `mins` stays `mins`, and `secs` stays `secs`;
- true abbreviations are cased uniformly by position: when an abbreviation begins a `lowerCamelCase` identifier, the whole abbreviation is lowercase; when it is a later component, the whole abbreviation is uppercase. Therefore SQL `json` -> leading `json` / medial `JSON`, `jsonb` -> `jsonb` / `JSONB`, `csv` -> `csv` / `CSV`, `ts` -> `ts` / `TS`, `tz` -> `tz` / `TZ`, `ws` -> `ws` / `WS`, and `cd` -> `cd` / `CD`;
- `Id` is the explicit repository exception to the general abbreviation rule: identifier-like SQL `id` is `id` when leading and `Id` when medial, never `ID`;
- ordinary shortened fragments are not abbreviations and never become all-caps: `str` -> leading `str` / medial `Str`, `pos` -> `pos` / `Pos`, `val` -> `val` / `Val`, `curr` remains an ordinary word fragment;
- compound lexical pieces are position-aware camelCase, not abbreviations: `recordset` decomposes to leading `recordSet` / medial `RecordSet`; `regexp` decomposes to leading `regExp` / medial `RegExp`; `base64` remains leading `base64` / medial `Base64`;
- existing concise public labels such as `pathElems:`, `mins:`, and `secs:` remain valid when they already mirror the project's SQL-shaped vocabulary; do not expand them mechanically;
- `Fn.Name` is public Swift API too: its canonical member should use the same SQL-shaped camelCase base name as the corresponding `Fn` helper while storing/emitting the exact SQL identifier;
- preserve established database/type/function terms as indivisible fragments only where splitting them would reduce SQL recognizability or blur a different SQL construct. This is not a blanket exemption for glued words: `recordset`, `tsvector`, `tsquery`, `timestamptz`, `substr`, `btrim`, and `strpos` are explicitly split by the policy above;
- SQL spelling remains exact in emitted SQL/internal SQL identity. A Swift rename never authorizes changing `setseed` to `set_seed`, `FROM_UNIXTIME` to another function, or any other database token;
- naming is not semantic substitution: `Fn.setSeed(...)` still represents the concrete SQL function `setseed(...)`, and `Fn.nextVal(...)` still represents concrete SQL `nextval(...)`; DESIGN-002/004 continue to forbid remapping one named SQL construct to another.

Examples of canonical SQL-shaped naming:

- Swift `Fn.setSeed(...)` -> SQL `setseed(...)`;
- Swift `Fn.nextVal(...)` -> SQL `nextval(...)`;
- Swift `Fn.currVal(...)` -> SQL `currval(...)`;
- Swift `Fn.subStr(...)` -> SQL `substr(...)`;
- Swift `Fn.bTrim(...)` -> SQL `btrim(...)`;
- Swift `Fn.strPos(...)` -> SQL `strpos(...)`;
- Swift `Fn.concatWS(...)` -> SQL `concat_ws(...)`;
- Swift `Fn.localTimestamp` -> SQL `localtimestamp`;
- Swift `Fn.timeOfDay()` -> SQL `timeofday()`;
- Swift `Fn.fromUnixTime(...)` -> SQL `FROM_UNIXTIME(...)`;
- Swift `Fn.fromJSON(...)` -> SQL `from_json(...)`;
- Swift `Fn.readCSV(...)` -> SQL `read_csv(...)`;
- Swift `Fn.readJSON(...)` -> SQL `read_json(...)`;
- Swift `Fn.toJSON(...)` -> SQL `to_json(...)`;
- Swift `Fn.jsonTypeOf(...)` -> SQL `json_typeof(...)`;
- Swift `Fn.jsonbTypeOf(...)` -> SQL `jsonb_typeof(...)`;
- Swift `Fn.toJSONB(...)` -> SQL `to_jsonb(...)`;
- Swift `Fn.lPad(...)` -> SQL `lpad(...)`;
- Swift `Fn.toTSVector(...)` -> SQL `to_tsvector(...)`;
- Swift `Fn.toTSQuery(...)` -> SQL `to_tsquery(...)`;
- Swift `Fn.plainToTSQuery(...)` -> SQL `plainto_tsquery(...)`;
- Swift `Fn.tsRankCD(...)` -> SQL `ts_rank_cd(...)`;
- Swift `Fn.makeTimestampTZ(...)` -> SQL `make_timestamptz(...)`;
- Swift `Fn.jsonPopulateRecordSet(...)` -> SQL `json_populate_recordset(...)`;
- Swift `Fn.jsonBuildArray(...)` -> SQL `json_build_array(...)`;
- Swift `Fn.generateSeries(...)` -> SQL `generate_series(...)`;
- Swift `Fn.groupingId(...)` -> SQL `grouping_id(...)`.

Examples of intentionally preserved database terms:

- `Fn.substring(...)` remains `substring` because that full SQL function name is already a complete recognizable term and is separately modeled from `substr`/`subStr`;
- `nvl`, leading `jsonb...`, and standard mathematical/SQL notation remain intact where no clearer project-approved component split exists;
- `cumeDist` remains the direct camelCase of SQL `cume_dist`;
- `fromBase64` remains the established `Base64` spelling.

When a new or existing public name is reviewed, use this decision order:

1. identify the exact SQL identifier/construct and its database spelling;
2. split underscores into camelCase boundaries;
3. identify clear internal boundaries inside glued SQL tokens, including approved compound splits such as `recordSet`, `TSVector`, `TimestampTZ`, `subStr`, and `strPos`;
4. classify each component as a true abbreviation, an ordinary shortened fragment, or a compound lexical piece; apply position-aware abbreviation casing, the explicit `Id` exception, and ordinary camelCase to non-abbreviations;
5. never replace an SQL-derived fragment with a different English synonym;
6. compare neighboring SwifQL APIs for project consistency;
7. confirm that a database engineer can still recognize the exact SQL construct from the Swift name;
8. only then decide compatibility handling from release history.

Do not create a permanent compatibility alias merely because an intermediate unreleased branch used a bad canonical spelling. Correct unreleased mistakes directly. Conversely, an established historical public spelling that may already be used by downstream clients remains source-compatible: add the final SQL-shaped canonical spelling, keep the old spelling only as `@available(*, deprecated, renamed: "...")`, and delegate to the canonical implementation with byte-for-byte identical SQL.

This compatibility policy applies to **all historical noncanonical public names**, not only `snake_case`. Existing historical snake_case declarations remain compatibility bridges, while any other historical spelling that violates the SQL-shaped camelCase policy receives the same additive treatment when release history requires it.

Canonical implementations and ordinary tests/docs use the SQL-shaped camelCase API. Compatibility tests prove every retained legacy spelling renders byte-for-byte identical SQL. New work must not expand SQL abbreviations or normalize their initialism casing merely to make the API read like general-purpose English Swift.

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
13. Could a downstream user reasonably need to add their own value, helper, dialect behavior, or protocol conformance here without changing SwifQL itself, and does the proposed public shape preserve that extension path?

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

For the current Duck PIVOT/UNPIVOT/MERGE design wave, bounded semantic render scopes remain the approved contextual-rendering mechanism. The root clause-ownership audit plus focused disposable evidence diagnostic have now validated a generic major-version composition architecture under `DSL-008`: the current root SQL-region/set-result frame selects an open clause owner by clause kind through one generic frame-aware continuation primitive; a dedicated owner-sensitive clause part persists that selection; bounded render scopes adapt only the affected children. This is not permission for hidden receiver-history routing: continuation methods must not search for PIVOT or inspect semantic history.

Focused semantic statement representation remains only a future architecture escalation boundary for genuinely different evidence, not a fallback that an implementation task may choose automatically.

This does not make invalid SQL valid. If a caller conditionally omits a required parent construct but still appends a clause that only makes sense inside that construct, the resulting query may correctly be invalid. Likewise, SwifQL is not required to distort an established global SQL API merely to make every dialect-specific invalid form unrepresentable at Swift compile time after semantic ownership has been erased. If a stricter dialect grammar cannot be expressed truthfully without changing ordinary overload behavior, adding hidden routing, or exposing renderer accommodation in user source, preserve the direct SQL DSL and let target-dialect validation reject invalid SQL. The invariant is that equivalent valid composition shapes render identically, not that SwifQL guesses or proves all grammar.

## DESIGN-016 - Preserve established public extension contracts deliberately

Public helper protocols and extension-oriented surfaces are compatibility contracts even when they look like implementation utilities.

`KeyPathLastPath` is established public API and is used by public query surfaces such as RETURNING, conflict targets, constraints, key paths, and path types. It remains useful as a precise grammar constraint for new APIs whose own static signature truthfully owns column-name-only grammar. Do not force it into an established erased global method merely to simulate a dialect-specific compile-time restriction that overload resolution cannot actually enforce.

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

An explicitly approved major-version structural composition migration may change the observable `parts` tree when that is required to preserve SQL-region ownership through existential/copy/nested composition. In that case ordinary SQL-shaped query call sites should remain source-compatible, while downstream code that assumes flattened statement/clause parts or manually appends continuation parts receives a documented migration to the public structural composition API.

## DESIGN-018 - Downstream extensibility is a first-class API requirement

SwifQL is intentionally extendable from application code and downstream packages. A user should not need to fork SwifQL or submit a pull request merely to add a legitimate private SQL/dialect/semantic value that the core library does not need to know exhaustively.

When a public semantic category is open in principle, do not model it as a closed Swift `enum` merely because SwifQL currently knows only a few values. Prefer an extensible public value-semantic type with a public initializer and stable public identity representation, with library-known values exposed as static conveniences. A namespaced string-backed identity is an appropriate pattern when arbitrary downstream names are meaningful and the core can carry unknown values opaquely.

Illustrative shape:

```swift
public struct SemanticRole: Hashable, Sendable {
    public let namespace: String
    public let name: String

    public init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }

    public static let builtIn: Self = .init(
        namespace: "swifql",
        name: "builtIn"
    )
}

extension SemanticRole {
    public static let applicationSpecific: Self = .init(
        namespace: "com.example.application",
        name: "applicationSpecific"
    )
}
```

Use a closed `enum` only when the modeled SQL grammar/domain is genuinely exhaustive and an unknown downstream value would be invalid or unsafe rather than merely unknown to SwifQL.

For optional semantic ownership, prefer absence (`nil`) for the ordinary/no-owner case instead of reserving a magic open-domain identity such as `"none"`, unless evidence shows that an explicit ordinary owner is materially required.

The same extensibility rule applies to visibility. When a type, initializer, protocol hook, value wrapper, or structural helper is a plausible safe downstream extension point, prefer making that boundary public from the start instead of keeping it internal solely to minimize API surface. Public extensibility must remain value-semantic and must not expose mutable renderer/preparation internals or weaken safety invariants.

Review downstream extensibility proactively. Existing users may maintain private `SwifQLable` helpers, custom parts/operators, path abstractions, protocol conformances, and `SQLDialect` subclasses that will never appear in this repository. Preserving their ability to extend SwifQL is part of the product design, not an accidental implementation detail.

## DESIGN-019 - Cross-dialect architecture before dialect-triggered internals

A new dialect may be the first place that exposes a missing internal capability, but that dialect must not silently become the ontology of the shared architecture.

Before adding or changing a shared rendering, preparation, binding, semantic-scope, ownership, value/identifier, operator, clause, or structural-composition primitive, research the **semantic class of the problem across dialects**, not only the dialect that triggered the work.

The minimum design check is:

1. inspect every currently supported dialect whose existing behavior could pass through the primitive;
2. inspect known adjacent/unimplemented constructs in those dialects that are likely to need the same semantic category later;
3. sample several major external SQL dialect families when that can reveal materially different grammar requirements, such as PostgreSQL-family, MySQL-family, SQLite, SQL Server/T-SQL, Oracle, BigQuery/GoogleSQL, and Snowflake;
4. classify which dimension actually varies: identifier vs value, bindable value vs parser constant, literal token vs expression, qualification, casing, placeholder form, clause ownership, statement ownership, or another grammar role;
5. design the shared primitive around that semantic dimension with open/value-semantic extension points where the domain is open, while keeping each dialect's concrete policy in the dialect layer;
6. prove that a future dialect can consume the primitive without changing established public query source, existing `parts` meaning, or previously released dialect hooks.

This is architecture foresight, not permission to implement speculative SQL features. Do not add public APIs, dialect branches, enums, scopes, or hooks merely because another database might use them someday. Research enough cross-dialect evidence to avoid naming or shaping a shared primitive around one product-specific accident, then implement only the capability required by the current approved task.

Examples of the required distinction:

- if one dialect requires a value to be a parser constant in a particular grammar position, model the grammar role/context generically rather than creating a `Duck...` value wrapper;
- if different dialects may choose bind, safe literal, or another exact representation for the same contextual value, do not freeze the shared hook to the first dialect's binary decision unless cross-dialect evidence proves that Boolean policy is the durable semantic boundary;
- if a semantic owner is needed, name/model the owner by the SQL grammar role it owns, not by the database product that first required it.

A proposal fails this gate if supporting a foreseeable equivalent PostgreSQL/MySQL/other-dialect grammar later would require a breaking public-source rewrite, changing the meaning of an established generic hook, replacing a closed product-shaped enum/type, or introducing a parallel renderer because the original primitive encoded one dialect too narrowly.
