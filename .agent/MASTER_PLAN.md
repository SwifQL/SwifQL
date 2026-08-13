# Master Plan

This file owns the durable SwifQL library roadmap. Detailed implementation plans belong in transient `.artifacts/**` documents.

## Current direction

- PostgreSQL and MySQL remain the established dialects. The current working tree also contains an unreleased Duck SQL-rendering implementation that is still under native-validation and public-UX correction before it can be considered final.
- Governance modernization is the repository-owned control plane for this workflow.
- Dialect documentation is split into a compact cross-dialect base plus progressively loaded per-dialect owners. Duck is documented in detail now; PostgreSQL/MySQL have compact verified seeds that should later receive dedicated documentation/research mega-audits.
- The additive `Fn` naming migration is complete for the existing supported surface: camelCase declarations own the implementation and historical snake_case declarations remain deprecated source-compatible aliases with identical SQL output.
- Duck support is additive and feature-specific; it does not imply that all PostgreSQL-specific SwifQL APIs are Duck-compatible.
- The Duck public API must be dialect-transparent and SQL-shaped. The current unreleased `.duckdb` / `DuckDB...` / `duckDB...` surface is not naming authority and must be classified/corrected before feature work resumes. Canonical public dialect spelling is `.duck`.
- SwifQL remains a query-building library. DuckDB C API or native execution-wrapper integration belongs outside this repository.

## Documentation roadmap

- Keep `architecture/DIALECT_RENDERING.md` limited to common dialect architecture.
- Keep `architecture/dialects/DUCK.md` current as Duck source/native validation evolves.
- Run a dedicated PostgreSQL mega-audit later to expand `architecture/dialects/POSTGRES.md` from current source/tests/current official behavior while preserving compatibility deliberately.
- Run a dedicated MySQL mega-audit later to expand `architecture/dialects/MYSQL.md` the same way.
- Do not bulk-load or bulk-duplicate all dialect details into one stable file; progressive loading is part of the architecture.

Later feature ideas are roadmap context, not implementation permission. They require their own research, plan, audit, and approval gates.
