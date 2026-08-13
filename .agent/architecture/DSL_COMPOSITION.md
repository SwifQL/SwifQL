# DSL Composition Architecture

This file is the sole owner of `DSL-*` rules.

## Verified model

`SwifQLable` is the composable public abstraction and exposes `parts: [SwifQLPart]`. `SwifQLPart` is the ordered composition unit. DSL helpers, operators, functions, and builders ultimately produce or combine those parts.

The model is parts-based composition, not parser, AST, tokenizer, or parser-driven compilation. Composition and final SQL preparation are separate concerns: final assembly is owned by `QUERY_PREPARATION.md`, with dialect-sensitive rendering owned by `DIALECT_RENDERING.md`.

Current ordinary scalar conformances such as `String`, numeric types, `UUID`, and `Decimal` produce `SwifQLPartUnsafeValue`; `Date` and other special cases use their dedicated part representations. The public API also contains raw/custom structural escape hatches. They exist for deliberate structure and are not the default extension path for dynamic data.

DuckDB-specific functions, types, builders, and parts use the same `SwifQLable`/`SwifQLPart` composition model and re-enter the standard preparation pipeline; they do not form a parallel DuckDB renderer or mini-framework.

## Rules

### DSL-001 — Core composition contract

The core composition contract is `SwifQLable -> [SwifQLPart]`.

### DSL-002 — Ordered parts

Part order is semantic and must be preserved when helpers compose or append query fragments.

### DSL-003 — Typed composition first

Extensions should compose existing typed or structured parts before introducing raw/custom SQL structure.

### DSL-004 — Raw structure and dynamic data

Raw/custom structural escape hatches may exist, but must never interpolate untrusted dynamic data. Data values use the normal bound-value path.

### DSL-005 — Standard preparation path

All composition continues into the standard preparation pipeline rather than a parallel SQL renderer. See `QUERY_PREPARATION.md` for preparation mechanics.

### DSL-006 — Composition preserves the chosen SQL contract

Part composition must preserve the public SQL identity and UX contract selected under `DESIGN-*`; composition is not a place to introduce hidden semantic substitution. See `DSL_DESIGN_AND_UX.md` for the owning SQL-first/API-design rules.
