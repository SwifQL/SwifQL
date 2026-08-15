# Active Tasks

This file contains only approved current work. Ideas, unresolved choices, verified debt, and completed history belong in their separate owners.

## Current state

Duck SQL-surface research/classification is complete enough to enter the final architecture-proof and planning gates. No production Duck feature implementation is authorized yet.

Current approved sequence:

1. run the evidence-only scope-only compile/downstream diagnostic defined under `.artifacts/planning/duck-sql-surface-redesign/`;
2. if PASS, independently reconcile the diagnostic evidence into the detailed Duck `IMPLEMENTATION_PLAN.md` without changing the approved SQL-first/scope-only design;
3. run an independent plan audit against DESIGN-001/015/017, Duck v1.5.5 semantics, PostgreSQL/MySQL regression contracts, and downstream extension compatibility;
4. only after a clean plan audit create numbered surgical implementation tasks and the short executor coordinator prompt.

The approved first Duck closure includes ordinary application/analytics/schema SQL including views, while administrative/runtime families and the generic SQL `name := expression` abstraction are deferred. Exact SQL identity is mandatory: do not introduce semantic portability facades such as a cross-dialect `binary(...)` API that substitutes differently named SQL functions.

No Duck implementation wave, Swift 6/Sendable implementation, or unrelated modernization is executable until the diagnostic and plan audit are complete.
