# Active Tasks

This file contains only approved current work. Ideas, unresolved choices, verified debt, and completed history belong in their separate owners.

## Current state

There is currently **no active approved implementation task** from the completed Duck SQL Surface Redesign / Swift 6 / 2.0 release wave.

The first Duck SQL-surface redesign closure is implemented, native-/compatibility-validated, independently audited, committed, and published in the `2.0.0-beta.5.0.0` pre-release. Tasks 01-27 are complete, including the final `.duck` expansion into `SQLDialect.all` and the native/compatibility closure required for that expansion.

The Swift 6.3 strict-concurrency migration is implemented, independently audited, committed, and included in `2.0.0-beta.5.0.0`. `Package.swift` uses SwiftPM tools 6.0 and Swift 6 language mode; final validation used Apple Swift 6.3.3 with complete strict-concurrency checking. The migration intentionally preserves non-Sendable query/bind graphs where their semantics are not truthfully Sendable.

Task 29 stable documentation, migration guidance, release notes, final audit, release-doc polish, and the follow-up GitHub repository-URL correction are complete. The final URL correction is commit `b0976b2c86f089b66e342ab9ec8851deb6aba24c` (`📖 Fix repository URLs`).

The approved first Duck closure covers ordinary application/analytics/schema SQL including views and the validated catalog/file-function surface. Administration/runtime families such as INSTALL/LOAD, secrets, broad PRAGMA/configuration, checkpoint/vacuum/analyze administration, variables, export/import, SHOW/DESCRIBE/SUMMARIZE convenience, extension-specific SQL universes, and the generic SQL `name := expression` abstraction remain deferred.

New work should begin only from a new explicit maintainer objective. Do not revive historical `.artifacts` task/correction lineages as active work; reconstruct fresh artifacts from current Git/source/stable authority when needed.
