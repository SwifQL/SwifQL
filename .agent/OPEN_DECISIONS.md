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

### DUCK-API-001

- Architecture owner: `architecture/DSL_DESIGN_AND_UX.md` with `architecture/dialects/DUCK.md` supporting.
- Question: What are the final clean SQL-shaped APIs for the current unreleased Duck public surface that still exposes `DuckDB...` wrappers, especially PIVOT/UNPIVOT, MERGE, COLUMNS/star modifiers, nested value constructors, sequences, macros, catalog paths, and option/helper types?
- Why it matters: the current implementation repeatedly exposes database implementation names in ordinary query source, which violates DESIGN-014. Existing pre-Duck SwifQL query APIs must not be changed. The unreleased Duck surface may be corrected directly without compatibility aliases.
- Status: blocking continuation of Duck implementation/native validation.
- Resolution timing: classify the complete new Duck public API before replacement P03 and before resuming TASK-C02.
- Research: `.artifacts/planning/DIALECT_TRANSPARENT_DSL_RESEARCH.md`.

