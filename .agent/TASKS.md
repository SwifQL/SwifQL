# Active Tasks

This file contains only approved current work. Ideas, unresolved choices, verified debt, and completed history belong in their separate owners.

## Current state

Duck SQL-surface research/classification, Gate A/B architecture evidence, and the complete independent implementation-plan audit lineage are PASS. All original plan-audit blockers 001-006 are CLOSED.

The authorized implementation package now exists under:

`.artifacts/implementation/duck-sql-surface-redesign/`

It contains shared execution rules, `TASK_INDEX.md`, numbered surgical Tasks 01-28, append-only `EXECUTION_REPORT.md`, compact `COORDINATOR_PROMPT.md`, and a separate independent `FINAL_AUDIT_TASK.md`.

Implementation execution has started. Main Task 01 PASSed. Main Task 02 attempt 01 failed at focused test compilation; Correction Task 01 fixed the two test initializer ambiguities and exposed the neutral leading-space regression; Correction Task 02 restored the evidence-proven root-frame spacing normalization. Task 02 attempt 02 then PASSed 7 focused tests / 1 suite and the full 192-test / 18-suite run.

Independent coordinator review of the actual live Task 02 source/test/diff is complete and **ACCEPTED**. The review artifact is:

`.artifacts/reviews/duck-sql-surface-redesign-task02-review.md`

Tasks 03-28 have not run.

Current approved sequence:

1. resume the implementation executor through `.artifacts/implementation/duck-sql-surface-redesign/RESUME_TASK03_PROMPT.md`;
2. start strictly at Task 03, preserving accepted Tasks 01-02 source/test changes and append-only evidence; do not rerun/rewrite Tasks 01-02 unless a later explicitly scoped correction requires it;
3. continue automatically through Tasks 04-28 after each PASS and stop the whole run on BLOCKED/FAIL without widening scope;
4. after Tasks 03-28 eventually PASS, executor stops and the independent coordinator/reviewer executes `FINAL_AUDIT_TASK.md` against actual source/diff/Git;
5. only after independent final audit CLEAN may the maintainer open the separate commit gate; no push is implied.

The approved first Duck closure includes ordinary application/analytics/schema SQL including views, while administrative/runtime families and the generic SQL `name := expression` abstraction are deferred. Exact SQL identity is mandatory: do not introduce semantic portability facades such as a cross-dialect `binary(...)` API that substitutes differently named SQL functions.

Do not mix Swift 6/Sendable implementation, unrelated modernization, dependency/deployment changes, SwiftDuckDB mutation, staging/commit/push, or history changes into this implementation run.
