# Compatibility and Evolution Public Content Ideas

Focused idea bank for README/docs/publication material about evolving SwifQL aggressively without gratuitously breaking established query source.

Do not load this shard during ordinary development. Read/update it only after a positive public-content capture check or when preparing migration/release/publication material.

## Article: Evolving SwifQL Without Making Thousands of Developers Rewrite Thousands of Queries

Status: architecture-approved
Good for: article | website docs | release notes | migration philosophy | maintainer post

### Core story

SwifQL can modernize deeply under the hood without treating a new major version as permission to redesign the DSL for aesthetic reasons.

A SQL-building library accumulates a special compatibility burden: users may have hundreds or thousands of queries spread across production applications, local Swift extensions, shared query fragments, helper packages, tests, and database-specific layers. A superficially "cleaner" API can therefore create disproportionate migration pain even when the generated SQL semantics did not need to change.

The engineering goal is stronger than "avoid breaking changes when convenient":

> Improve internal architecture, correctness, concurrency, dialect support, diagnostics, and type safety while preserving the user's established query-building language whenever a truthful source-compatible path exists.

This is a strong SwifQL product/engineering story because compatibility is treated as developer experience, not merely semantic-version bookkeeping.

### Candidate article titles

- **How SwifQL Evolves Without Breaking Thousands of Existing Queries**
- **Major Version, Minor Pain: Evolving a Swift SQL DSL Without Rewriting User Code**
- **Refactor the Engine, Not Your Users: Source-Compatible Evolution in SwifQL**
- **A Better SQL DSL Without a Migration Tax**
- **How to Modernize a DSL Without Making Its Users Pay for Your Refactor**

### Opening angle

A useful opening contrast:

```text
Library maintainer sees:
"I can make this API cleaner in the next major version."

Long-time user sees:
"I have 4,000 queries, dozens of extensions, and several production apps.
Why am I rewriting all of this because your internals changed?"
```

The article can argue that a major-version boundary is necessary permission for unavoidable incompatibility, but it is not a design license for gratuitous source churn.

### Concrete SwifQL examples

#### 1. Dialect support without database-prefixed query rewrites

Bad migration pressure: forcing users to replace normal SwifQL paths, expressions, and functions with database-prefixed PIVOT wrapper types.

Better direction:

```swift
SwifQL.pivot(cities)
    .on(cities.column("year"), in: 2000, 2010)
    .using(Fn.sum(cities.column("population")) => "total")
    .groupBy(cities.column("country"))
```

The new dialect capability is added underneath the same SQL-shaped mental model instead of creating a second database-specific object model.

#### 2. Semantic render scopes improve internals without changing expression composition

Existing user expressions remain normal:

```swift
cities.column("year")
Fn.sum(cities.column("population"))
```

The library gains structural semantic metadata internally so a dialect can render the same expression correctly in a special grammar position.

The user does not have to rewrite existing path/function composition merely because the renderer became smarter.

#### 3. Incremental query building remains first-class

Users may write:

```swift
var query: SwifQLable = SwifQL

if needsFilter {
    query = query.where(...)
}

query = query.orderBy(...)
```

or compose fragments in separate methods/files. Architectural improvements must preserve this style instead of requiring one monolithic builder chain or hidden mutable builder mode.

#### 4. Reuse public compatibility contracts instead of deleting them casually

`KeyPathLastPath` may look like an internal helper at first glance, but live source shows it is public and participates in established query/path APIs.

Rather than deleting it while introducing new dialect behavior, SwifQL can reuse it where the SQL grammar genuinely wants a column name, for example simplified PIVOT `GROUP BY`.

This illustrates a useful maintainer habit: inspect whether an apparently low-level type is actually downstream extension surface before replacing it.

#### 5. Rename only unreleased API freely

Compatibility discipline does not mean keeping every mistake forever.

Duck support is still unreleased, so incorrect pre-release names or API shapes can be corrected directly before users depend on them.

This creates a clear line:

```text
unreleased experimental surface
    -> fix aggressively before release

established released query DSL
    -> preserve call sites whenever technically possible
```

That distinction lets maintainers move quickly without transferring the cost of experimentation to users.

### Compatibility decision framework

Potential article section:

Before changing an established public query API, ask in order:

1. Is the existing behavior actually incorrect/unsafe, or merely stylistically imperfect?
2. Can the internal representation/rendering be improved while keeping the same call site?
3. Can an additive overload/helper/view preserve source compatibility?
4. Can a deprecated bridge give downstream extensions time to migrate?
5. Is the breaking change genuinely required for correctness/safety, or is it mainly maintainer preference?
6. What is the likely migration cost across real applications containing thousands of queries?

Only after those questions fail should an established call site be removed.

### Major-version philosophy

Important line worth preserving:

> A major release gives SwifQL room to make unavoidable corrections. It does not give the library permission to make users rewrite hundreds or thousands of valid queries just because a new internal architecture looks cleaner.

Another possible formulation:

> The best major-version migration is often the one users barely notice: stronger internals, broader dialect support, better safety, same familiar query source.

### Local Swift extensions as the hidden compatibility surface

This is worth a dedicated section because public API impact is larger than repository search suggests.

A user may have local code like:

```swift
extension SwifQLable {
    func myProjectSpecificFilter(...) -> SwifQLable {
        ...
    }
}
```

or conform their own types to public helper protocols.

Those extensions do not exist in the SwifQL repository, so maintainers cannot estimate compatibility cost only by grepping first-party call sites.

Therefore public protocols/helpers such as `KeyPathLastPath`, expression composition, labels/order, and fluent/reference behavior deserve deliberate compatibility review even when they look implementation-oriented internally.

### Migration documentation rule

When a future breaking replacement truly is unavoidable:

- document why source compatibility could not be preserved;
- provide before/after examples;
- include examples for downstream Swift extensions/conformances where relevant;
- prefer mechanical migration steps;
- distinguish removed API from merely renamed/reorganized implementation types;
- explain which generated SQL semantics remain identical.

Migration docs should be designed as part of the breaking change, not written as an afterthought after release.

### Engineering theme for a longer article

The deeper message can be framed as:

```text
compatibility is architecture
```

not just:

```text
compatibility is deprecation annotations
```

SwifQL's architecture should make source-compatible evolution easier by design:

- structured parts instead of opaque strings;
- dialect-aware rendering;
- semantic render scopes instead of user-facing database wrappers;
- additive context-aware hooks;
- reusable public grammar protocols;
- explicit escalation to semantic statement parts only when local scopes are insufficient;
- native database validation before cementing new API;
- pre-release cleanup before compatibility obligations begin.

This lets the library modernize the engine while keeping the user's language stable.

### Article candidate - Green Tests Can Still Cement the Wrong Architecture

**Status:** architecture-approved article idea; source examples must track the current mainline.

A useful engineering article can show a failure mode that is common in mature libraries:

```text
speculative internal layer
-> tests written around that layer
-> regressions patched with more tests
-> every suite green
-> architecture still wrong
```

SwifQL's architecture policy provides a concrete lesson: tests are evidence for an already accepted design, not a voting system that can make a workaround clean. When a new abstraction changes old structural behavior and requires compatibility handling elsewhere, the correct response may be to reject the abstraction even if its dedicated tests are perfect.

Potential titles:

- **Green Tests, Wrong Architecture**
- **Why Passing Tests Are Not a Design Review**
- **Delete the Workaround, Not the Regression Test Expectation**

The user-facing angle is compatibility: mature-library users should not become unpaid debuggers of an internal redesign simply because the maintainer can make CI green.

### Evidence / provenance

Stable architecture/governance:

- `.agent/architecture/DSL_DESIGN_AND_UX.md` DESIGN-001, DESIGN-010, DESIGN-014, DESIGN-015, DESIGN-016, DESIGN-017
- `.agent/architecture/DIALECT_RENDERING.md` DIALECT-008, DIALECT-009, DIALECT-012, DIALECT-013
- `.agent/architecture/dialects/DUCK.md`
- `.agent/TESTING_RULES.md`

Relevant architecture commits:

- `b106dd6431771802fc851507222b6b1ed5e7c90f` - `📖 Evolve governance and dialect architecture`
- `65879f7248af6488222655aa33d1316a516a594f` - `📖 Define semantic render scopes`

### Publication caveat

The compatibility philosophy is stable architecture. Generic semantic render scopes exist on the current mainline but are not released yet; clean Duck PIVOT remains architecture direction rather than an approved implementation. Future publication must clearly separate established released SwifQL behavior, current unreleased infrastructure, and still-planned Duck APIs.
