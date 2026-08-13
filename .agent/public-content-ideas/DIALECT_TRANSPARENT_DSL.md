# Dialect-Transparent DSL Public Content Ideas

Focused idea bank for README/docs/publication material around SwifQL's dialect-transparent DSL architecture.

Do not load this shard during ordinary source work. Read/update it only when a positive public-content capture check points here or when preparing public documentation/content.

## Same clean query, dialect-specific rendering under the hood

Status: architecture-approved
Good for: README | website docs | article | short post

### Why users should care

SwifQL should let users write the SQL idea they mean instead of exposing database-driver-like wrapper types throughout the query. Dialect differences belong in preparation/rendering whenever the SQL concept is truthfully the same.

This is a strong concise story for SwifQL: **the DSL stays clean while the selected dialect handles grammar details under the hood**.

### Candidate example / visual

Conceptual public call site:

```swift
let cities = Path.Table("cities")

let query = SwifQL.pivot(cities)
    .on(cities.column("year"), in: 2000, 2010)
    .using(Fn.sum(cities.column("population")) => "total")
    .groupBy(cities.column("country"))
    .orderBy(.desc(cities.column("country")))
    .limit(2)

let sql = query.prepare(.duck)
```

The user should not need call-site concepts such as:

```swift
DuckDBPivotColumn(...)
DuckDBPivotOn(...)
DuckDBPivotAggregate(...)
```

because those describe implementation/database mechanics rather than the SQL idea the user is expressing.

Simple visual:

```text
clean SwifQL query
       │
       ▼
semantic parts + scopes
       │
       ▼
prepare(selected dialect)
       │
   ┌───┴────┐
   ▼        ▼
 normal   dialect-specific
 SQL idea  grammar rendering
```

### Evidence / provenance

Stable architecture owners:

- `.agent/architecture/DSL_DESIGN_AND_UX.md` DESIGN-014/015
- `.agent/architecture/DIALECT_RENDERING.md` DIALECT-008/012/013
- `.agent/architecture/dialects/DUCK.md` DUCK-010/018

Architecture checkpoint:

`65879f7248af6488222655aa33d1316a516a594f` - `📖 Define semantic render scopes`

### Publication caveat

The clean PIVOT API and semantic render-scope mechanism are architecture-approved but not yet implemented or shipped. Do not present the exact conceptual API above as currently available until implementation/native-validation/release status is promoted.

## Semantic render scopes: context travels with the expression

Status: architecture-approved
Good for: website docs | article | technical deep dive | short post

### Why users should care

A major SwifQL strength is composability. Queries can be assembled through variables, conditions, helpers, and separate methods rather than one monolithic fluent chain.

Dialect-aware rendering must preserve that property. Semantic render scope is therefore structural metadata attached to the relevant nested parts, not an ambient mutable "current builder mode" and not a guess based on neighboring SQL tokens.

This makes dialect-aware behavior compositional and predictable even in large dynamically assembled queries.

### Candidate example / visual

Equivalent valid queries should preserve the same semantics whether written as one chain:

```swift
var query = SwifQL.pivot(cities)
    .on(cities.column("year"), in: 2000, 2010)
    .using(Fn.sum(cities.column("population")))
```

or assembled incrementally:

```swift
var query: SwifQLable = SwifQL.pivot(cities)

if includeYears {
    query = query.on(cities.column("year"), in: 2000, 2010)
}

query = query.using(Fn.sum(cities.column("population")))
```

or from helpers/fragments:

```swift
func populationTotal() -> SwifQLable {
    Fn.sum(cities.column("population"))
}

query = query.using(populationTotal())
```

Conceptual internal structure:

```text
Scoped(.pivotOn)
└─ KeyPath
   ├─ table: cities
   └─ column: year
```

The scope stays with those nested parts when they are copied/appended/returned/stored.

During normal rendering:

```sql
"cities"."year"
```

During Duck simplified-PIVOT ON rendering:

```sql
"year"
```

without asking the user to rewrite the path.

### Important validity nuance

The composability guarantee is not "SwifQL invents missing grammar".

For example:

```swift
var query: SwifQLable = SwifQL

if includePivot {
    query = query.pivot(cities)
}

query = query.on(cities.column("year"), in: 2000, 2010)
```

is only a valid PIVOT query when the parent PIVOT construct is actually present. Semantic scopes guarantee that **equivalent valid composition shapes preserve meaning**, not that a PIVOT-only clause becomes valid after its required parent was conditionally omitted.

### Evidence / provenance

- `.agent/architecture/DSL_DESIGN_AND_UX.md` DESIGN-015
- `.agent/architecture/DIALECT_RENDERING.md` DIALECT-008
- `.agent/TESTING_RULES.md`, contextual rendering/composition equivalence contract
- `.artifacts/reviews/SEMANTIC_RENDER_SCOPE_DECISION_AUDIT.md`
- architecture commit `65879f7248af6488222655aa33d1316a516a594f`

### Publication caveat

Architecture-approved, not yet implemented. Exact public type/method names for the render-scope extension mechanism are intentionally not final.

## Nested expressions keep their grammar context

Status: architecture-approved
Good for: website docs | article | technical diagram

### Why users should care

A useful demonstration of structural scopes is that dialect context should reach relevant descendants even when a column is nested inside functions/operators. Users do not have to flatten or rewrite expressions to satisfy a dialect-specific grammar rule.

### Candidate example / visual

User expression:

```swift
.on(Fn.coalesce(cities.column("year"), 0))
```

Conceptual parts:

```text
Scoped(.pivotOn)
└─ Fn.coalesce
   ├─ KeyPath(cities.year)
   └─ 0
```

The Duck renderer can see `.pivotOn` while rendering the descendant key path and produce the grammar-correct unqualified reference without changing the surrounding function expression.

An even stronger nested-path example:

```text
normal context:
"events"."payload"->'year'

Duck PIVOT expression context:
"payload"->'year'
```

The renderer removes only the source-table qualification required by Duck's PIVOT grammar; it does **not** collapse the nested path to only `"year"`.

### Evidence / provenance

Architecture decision in `DIALECT_RENDERING.md` DIALECT-008 and Duck-specific qualification contract in `architecture/dialects/DUCK.md`.

### Publication caveat

Architecture-approved. Exact nested-path support must be demonstrated by implementation tests/native validation before presenting the SQL examples as shipped behavior.

## Reuse `KeyPathLastPath` instead of inventing PIVOT wrappers

Status: architecture-approved
Good for: article | maintainer/developer docs | migration/extension docs

### Why users should care

SwifQL already has a public abstraction for grammar positions that need a column name rather than a full arbitrary expression: `KeyPathLastPath`.

Duck simplified PIVOT `GROUP BY` is exactly such a grammar position. Reusing the established contract gives stronger typing without making the call site uglier.

### Candidate example / visual

The user still writes:

```swift
.groupBy(cities.column("country"))
```

while the API can constrain the input conceptually to:

```swift
func groupBy(_ columns: KeyPathLastPath...) -> SwifQLable
```

This avoids user-facing inventions such as:

```swift
DuckPivotColumn("country")
```

and demonstrates an important SwifQL design principle: improve internals and type safety while preserving the natural SQL-shaped DSL.

### Evidence / provenance

Live source confirms `KeyPathLastPath` is public and already participates in existing public query/path APIs. Stable contract: DESIGN-016 and DUCK-018.

### Publication caveat

Do not describe `KeyPathLastPath` as internal implementation detail. It is established public compatibility surface. No migration is currently required because it is being preserved, not removed.

## Public extension point for semantic scopes

Status: architecture-approved
Good for: advanced website docs | article | extension-author docs

### Why users should care

A strong future extension story is that the same semantic-scope mechanism used internally by SwifQL may be available to downstream Swift extensions without exposing mutable renderer internals.

This would let advanced users build clean custom DSL helpers that preserve semantic rendering context instead of falling back to raw SQL or private implementation knowledge.

### Candidate example / visual

**Pseudocode only, names intentionally not final:**

```swift
extension SwifQLRenderScope {
    static let myFeature = /* namespaced scope identity */
}

extension SwifQLable {
    func myFeatureExpression() -> SwifQLable {
        scoped(.myFeature)
    }
}
```

The desired architecture is:

```text
external Swift extension
        │
        ▼
library-owned scoped-expression mechanism
        │
        ▼
normal SwifQL parts
        │
        ▼
context-aware dialect rendering
```

not:

```text
external code
  └─ custom unknown SwifQLPart
     └─ hope core prepare() knows how to render it
```

### Evidence / provenance

- DIALECT-012
- DESIGN-016
- `SEMANTIC_RENDER_SCOPE_DECISION_AUDIT.md`

A verified current compatibility gap also exists: `SQLDialect` is declared `open`, but its base initializer is currently internal. A real downstream compile fixture is required before claiming arbitrary external custom-dialect subclassing as supported.

### Publication caveat

This is a design goal, not shipped API. Do not publish the pseudocode names as final. Do not claim external custom-dialect subclassing until a downstream fixture proves/fixes the actual access-control surface.

## Scopes first, semantic statement parts when grammar truly needs more

Status: architecture-approved
Good for: technical article | architecture docs | conference/post material

### Why users should care

This is a useful engineering story: SwifQL avoids both extremes.

It does not accumulate token-neighbor hacks, but it also does not prematurely replace its proven parts pipeline with a giant full-query AST.

Semantic render scopes solve local contextual differences. A focused semantic statement part is reserved for the day a verified dialect difference really needs whole-statement structural transformation.

### Candidate example / visual

```text
                    SwifQLable
                        │
                        ▼
                   [SwifQLPart]
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
     normal part    scoped part   future focused
                                  statement part
          │             │             │
          └─────────────┴──────┬──────┘
                               ▼
                   one recursive preparation
                               │
                   one ordered bind/value state
                               │
                               ▼
                         selected dialect
```

Decision rule:

```text
same SQL meaning, local contextual rendering difference
    -> semantic render scope

verified dialect needs structural reorder / omission / duplication /
whole-statement decision
    -> focused semantic statement part
```

No second general renderer is introduced preemptively.

### Evidence / provenance

`DIALECT_RENDERING.md` DIALECT-013 and architecture decision audit.

### Publication caveat

Semantic statement parts are a documented extension boundary, not an implemented feature and not current technical debt.

## Native PIVOT validation as a trust story

Status: validated
Good for: website docs | article | release notes | short post

### Why users should care

SwifQL's Duck PIVOT design is being driven by actual DuckDB v1.5.5 parser/binder/prepared-statement behavior rather than assumptions from SQL strings alone.

This is useful public evidence for the library's correctness philosophy.

### Candidate facts worth preserving

Native DuckDB v1.5.5 validation established that:

- source-qualified columns fail inside simplified PIVOT ON;
- source-qualified aggregate input fails inside USING;
- GROUP BY succeeds with unqualified column names and rejects qualified forms;
- ORDER BY succeeds with unqualified PIVOT output names and rejects source-qualified forms;
- explicit PIVOT `IN ($1, $2)` values successfully prepare/bind/execute, including numeric, apostrophe-containing text, and Unicode values;
- prepared `LIMIT $3` also works when explicit IN makes the statement prepare-able;
- dynamic no-IN simplified PIVOT executes as plain SQL but DuckDB v1.5.5 cannot prepare it as one statement because its dynamic pivot expansion uses multiple internal statements.

This native matrix directly motivated the clean dialect-transparent rendering design instead of unsafe raw interpolation or database-specific wrapper APIs.

### Evidence / provenance

Transient native evidence is recorded under the current `.artifacts/corrections/duckdb-dialect/` P01/P02 reports and stable Duck facts are owned by `.agent/architecture/dialects/DUCK.md`.

### Publication caveat

The native engine facts are validated, but the final redesigned SwifQL PIVOT API is not yet implemented/shipped. Public content must distinguish validated DuckDB behavior from final SwifQL feature availability.
