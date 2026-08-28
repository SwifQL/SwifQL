# Active Tasks

This file contains only approved current work. Ideas, unresolved choices, verified debt, and completed history belong in their separate owners.

## Current state

The first Duck SQL-surface redesign closure is implemented, validated, independently audited, and committed. Tasks 01-27 are complete, including the final `.duck` expansion into `SQLDialect.all` and the native/compatibility closure required for that expansion.

The Swift 6.3 strict-concurrency migration is also implemented, independently audited, and committed. `Package.swift` now uses SwiftPM tools 6.0 and Swift 6 language mode; final validation used Apple Swift 6.3.3 with complete strict-concurrency checking. The migration intentionally preserves non-Sendable query/bind graphs where their semantics are not truthfully Sendable.

Task 29 owns the final stable documentation, migration guide, and release-candidate notes for the structural `parts` migration, first Duck closure, and Swift 6 strict-concurrency truth. Source/tests/Package are closed for Task 29; documentation must describe actual committed behavior without widening implementation claims.

After Task 29 passes its documentation, stale-text, full-test, and exact-diff gates, the next action is the separate independent `FINAL_AUDIT_TASK.md` against actual source/tests/docs/evidence/Git. Task 29 must not execute that audit itself.

The approved first Duck closure covers ordinary application/analytics/schema SQL including views and the validated catalog/file-function surface. Administration/runtime families such as INSTALL/LOAD, secrets, broad PRAGMA/configuration, checkpoint/vacuum/analyze administration, variables, export/import, SHOW/DESCRIBE/SUMMARIZE convenience, extension-specific SQL universes, and the generic SQL `name := expression` abstraction remain deferred.

Do not start new source modernization, new Duck feature waves, release/push work, or unrelated architecture changes as part of Task 29 or the final-audit gate.
