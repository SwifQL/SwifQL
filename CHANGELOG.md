# Changelog

## 2.0.0 (in development)

SwifQL 2.0.0 is the new Swift 6 major line we're preparing now.

### Added

- Swift 6 language mode and strict-concurrency compatibility.
- DuckDB support through `prepare(.duck)`.
- Duck in `SQLDialect.all` together with PostgreSQL and MySQL.
- Structural statement/subquery/set-result composition with public `SwifQLStructuralFramePart` and `structurallyAppending(_:)`.
- Public structural clause ownership types for advanced extensions.
- Detailed [MIGRATION.md](MIGRATION.md) and [RELEASE_NOTES.md](RELEASE_NOTES.md).

### Changed

- Real SQL-region boundaries are preserved structurally inside `SwifQLable.parts`.
- Canonical predefined `Fn.Name` values are immutable.
- `SwifQL` and the no-value Attach/Copy options return fresh values instead of shared stored instances.
- PostgreSQL date formatting is instance-local while keeping the generated SQL compatible.

### Fixed

- Static `raw(_:)` now uses the supplied text correctly while preserving the established route-specific spacing behavior.

### Migration notes

- Existing long-lived Vapor 4 / Swift 5 projects may stay on the 1.5.x line until they are ready to migrate.
- Code that manually appends or pattern-matches `SwifQLable.parts` should review the structural migration in [MIGRATION.md](MIGRATION.md).
- Query/bind graphs intentionally remain non-Sendable where appropriate; actor-based integrations should pass a consumer-owned Sendable snapshot across isolation boundaries.

### DuckDB notes

The first DuckDB release focuses on ordinary application / analytics / schema SQL. Administration/runtime families such as INSTALL / LOAD, secrets, broad PRAGMA/configuration, CHECKPOINT, VACUUM / ANALYZE administration, variables, EXPORT / IMPORT DATABASE, SHOW / DESCRIBE / SUMMARIZE, extension-specific SQL, and the generic `name := expression` API remain for later work.

## 1.5.0

Last stable SwifQL release line for Swift 5 projects.
