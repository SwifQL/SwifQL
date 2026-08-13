# Open Decisions

This file records genuinely unresolved choices, not settled architecture rules or task logs.

## Record format

- Decision ID:
- Architecture owner:
- Question:
- Why it matters:
- Status: blocking or non-blocking
- Resolution timing:

## Active decisions

### DIALECT-CONTEXT-001

- Architecture owner: `architecture/DIALECT_RENDERING.md` with `architecture/dialects/DUCK.md` supporting the concrete case.
- Question: What exact structured contextual-rendering primitive should be added to the existing `SwifQLable -> [SwifQLPart] -> prepare(dialect)` pipeline so the same user expression can render differently in a dialect-specific grammar position without token-neighbor heuristics or database-prefixed wrappers?
- Why it matters: Duck simplified PIVOT proves the current flat part stream lacks semantic grammar context. The recommended research direction is scoped parts plus a value-semantic render-context stack and additive context-aware `SQLDialect` hooks that forward to established hooks for custom-dialect compatibility. A larger full semantic statement part remains an alternative if future grammar differences require it.
- Status: blocking Duck PIVOT/API correction.
- Resolution timing: maintainer discussion before any replacement P03 implementation plan.
- Research: `.artifacts/planning/DIALECT_TRANSPARENT_DSL_RESEARCH.md`.

### DUCK-API-001

- Architecture owner: `architecture/DSL_DESIGN_AND_UX.md` with `architecture/dialects/DUCK.md` supporting.
- Question: What are the final clean SQL-shaped APIs for the current unreleased Duck public surface that still exposes `DuckDB...` wrappers, especially PIVOT/UNPIVOT, MERGE, COLUMNS/star modifiers, nested value constructors, sequences, macros, catalog paths, and option/helper types?
- Why it matters: the current implementation repeatedly exposes database implementation names in ordinary query source, which violates DESIGN-014. Existing pre-Duck SwifQL query APIs must not be changed. The unreleased Duck surface may be corrected directly without compatibility aliases.
- Status: blocking continuation of Duck implementation/native validation.
- Resolution timing: classify the complete new Duck public API before replacement P03 and before resuming TASK-C02.
- Research: `.artifacts/planning/DIALECT_TRANSPARENT_DSL_RESEARCH.md`.

