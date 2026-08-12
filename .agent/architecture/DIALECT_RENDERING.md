# Dialect Rendering Architecture

This file is the sole owner of `DIALECT-*` rules.

## Verified current model

`SQLDialect` is an open class. Its equality implementation compares only `id`. The current public factories are `.psql` for PostgreSQL and `.mysql` for MySQL. `.all` is exactly `[.psql, .mysql]` today. `.any` returns a base `SQLDialect` and is intended only for short universal SQL; it is not a substitute for a real dialect for database-specific parts. Base `keyPath` and `date` rendering return placeholder error-like strings, and the base bind key is `?`.

PostgreSQL and MySQL differ in identifier/key-path, date, bind, and array rendering. PostgreSQL uses double-quoted identifiers, JSON-path operators, PostgreSQL date/timestamptz formatting, `$1`-style bind keys, and PostgreSQL array forms. MySQL uses its own key-path/date behavior, `?` bind keys, and quoted array output. These are current implementation facts, not a promise that one dialect's APIs are portable to the other.

`SwifQLHybridOperator` currently stores exactly `_psql` and `_mysql` operator forms. `SwifQLHybridOperator.random` is the current concrete example (`random()` versus `rand()`). In `prepare(_:)`, `.psql` selects `_psql`, `.mysql` selects `_mysql`, and every other dialect currently defaults to the MySQL representation. DuckDB is not implemented.

Dialect-specific bind-key syntax belongs here; internal marker traversal, value order, and formatter mechanics belong to `QUERY_PREPARATION.md`.

## Rules

### DIALECT-001 — Dialect hooks

Dialect-sensitive rendering stays behind `SQLDialect` hooks used by preparation.

### DIALECT-002 — Support claims

Supported-dialect claims must match current source and tests. The implemented set is PostgreSQL and MySQL only.

### DIALECT-003 — Universal dialect limits

`.any` is only for short universal SQL and is not a substitute for a real dialect for database-specific parts.

### DIALECT-004 — Compatibility research

A new dialect requires explicit compatibility research covering identifiers, values, dates/timestamps, bind syntax, arrays/lists, JSON/key paths, casts/types, DML/DDL, operators/functions, hybrid operators, and test impact. PostgreSQL similarity is not enough.

### DIALECT-005 — Bind ownership split

Dialect-specific bind-key syntax is owned here. Prepared marker traversal and order belong to `QUERY_PREPARATION.md`.

### DIALECT-006 — Hybrid behavior

Every supported dialect requires explicit hybrid-operator behavior. Silently defaulting a new dialect to the MySQL representation is not a valid support contract.
