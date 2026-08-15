# Master Plan

This file owns the durable SwifQL development roadmap. Detailed research/plans/tasks/evidence belong in disposable `.artifacts/**`, but they must never contradict this roadmap or the stable owners routed by `ARCH_INDEX.md`.

## North star

SwifQL is SQL DSL first: users should think in SQL and write that SQL idea naturally, safely, and compositionally in Swift.

The first two design gates for every relevant change are:

1. `DESIGN-001` - SQL-first mental model.
2. `DESIGN-015` - equivalent valid queries preserve semantics across fluent, incremental, conditional, helper-based, nested, and cross-file composition.

If a proposal violates either gate, redesign it before implementation.

## Mandatory development order

```text
architecture + SQL semantics + DSL/UX
-> clean implementation
-> tests/native evidence proving the accepted implementation
-> independent source/diff/Git audit
-> commit checkpoint
```

Green tests do not legitimize a workaround, compatibility unwrap, hidden routing layer, duplicated state, token-neighbor heuristic, speculative framework/AST, renderer-driven public wrapper, or source-breaking DSL redesign.

If a new abstraction creates special cases in unrelated established code, treat that as evidence against the abstraction and revisit the design.

## Compatibility constitution

PostgreSQL/MySQL are established compatibility contracts. Assume users own thousands of queries plus private `extension SwifQLable`, custom operators/helpers, public-protocol conformances, path abstractions, and `SQLDialect` subclasses.

Unless a separately approved bug fix proves one old contract wrong, preserve existing source, composition, overload behavior, public protocol meaning, `parts` expectations, generated PostgreSQL/MySQL SQL, bind order, dialect-hook dispatch, and representative downstream extension compilation.

A major release is not permission for avoidable breakage. See DESIGN-010, DESIGN-015, DESIGN-016, and DESIGN-017.

## Approved rendering direction

The existing parts/preparation pipeline remains primary.

Approved additive primitives are value-semantic render scopes/context, a library-owned scoped nested part, recursive context-aware preparation, additive forwarding dialect hooks, and `SwifQLable.scoped(_:)`.

Attach scopes only at the semantic construct that truly owns the grammar context. Do not globally rewrite ordinary predicate/arithmetic/operator part shape for one dialect.

Focused semantic statement representation remains only a future escalation boundary after a separate maintainer decision proves ordinary/scoped parts genuinely insufficient. For the current Duck PIVOT/UNPIVOT/MERGE wave, the maintainer explicitly rejected semantic-statement/structural-clause routing as a fallback and requires a scope-only compile/downstream proof. Do not pre-install hidden routing into established `groupBy`, `orderBy`, `limit`, `returning`, or similar DSL methods.

## Duck direction

Canonical public spelling is `.duck`. Ordinary Duck query source remains SQL-shaped and dialect-transparent; Duck-only support does not automatically justify a `Duck...` public wrapper. Dialect-transparent rendering may adapt syntax/qualification/casing for the same exact SQL construct, but it must not become a portability facade that swaps differently named SQL constructs such as `decode` and `from_base64`. Keep `.duck` out of `SQLDialect.all` until the final Duck closure gate proves the dialect ready to expand every existing `all` assertion.

A target PIVOT call should remain conceptually clean, e.g. `SwifQL.pivot(cities).on(cities.column("year"), in: 2000, 2010)...`, with dialect-specific qualification handled behind the DSL rather than exposed as wrapper objects.

For simplified PIVOT, native DuckDB v1.5.5 evidence already proves qualified ON/USING/GROUP BY/ORDER BY forms fail, explicit bound IN values work, bound LIMIT works with explicit IN, and no-IN dynamic PIVOT cannot be prepared as one C statement. PIVOT GROUP BY should reuse established `KeyPathLastPath`.

The approved first `.duck` closure covers ordinary application/analytics/schema SQL, including views, and leaves administration/runtime families such as INSTALL/LOAD, secrets, broad PRAGMA/configuration, checkpoint/vacuum/analyze administration, variables, export/import, SHOW/DESCRIBE/SUMMARIZE convenience, and extension-specific universes for later typed waves. The generic SQL `name := expression` abstraction is also deferred; current closure work must not invent it indirectly.

## Current Duck design gate

Before any new Duck feature implementation executor runs:

1. inventory/classify the intended Duck SQL surface from current live source and current DuckDB semantics;
2. design concrete SQL-shaped user-facing Swift examples before implementation mechanics and preserve exact SQL identity rather than semantic portability facades;
3. prove the approved semantic-render-scope architecture for PIVOT-style incremental composition with the dedicated evidence-only compile/downstream diagnostic; if it cannot satisfy DESIGN-015/017 cleanly, stop at an architecture blocker;
4. lock the detailed implementation/migration plan from the current clean mainline, respecting the approved first closure and the deferred generic `name := expression` work;
5. independently audit that plan against DESIGN-001/015/017, dialect rules, PostgreSQL/MySQL/downstream-extension compatibility, and official/native DuckDB semantics;
6. only then create numbered surgical tasks and run an implementation executor.

Current live source and stable architecture owners define the implementation baseline. Disposable artifacts may record the current research/plan/evidence, but they do not override those authorities.

## Future validation gates

Substantial waves require design/UX review before implementation, source/diff review afterward, PostgreSQL/MySQL exact regression checks, bind-order checks where relevant, DESIGN-015 composition checks, downstream consumer fixtures when extension compatibility is at risk, native DuckDB validation where renderer tests are insufficient, `git diff --check`, and exact changed-path review.

## Documentation roadmap

Keep detailed principles in their single owners rather than duplicating them here. Maintain Duck docs now; later run dedicated PostgreSQL and MySQL documentation/research mega-audits. Public-content ideas remain lazy-loaded candidate material, never implementation authority.