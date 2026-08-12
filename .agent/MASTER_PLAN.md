# Master Plan

This file owns the durable SwifQL library roadmap. Detailed implementation plans belong in transient `.artifacts/**` documents.

## Current direction

- The current implementation supports PostgreSQL and MySQL.
- Governance modernization is complete and is the repository-owned control plane for this workflow.
- The next approved direction is detailed DuckDB dialect compatibility research, followed only by separately researched, planned, and audited implementation slices.
- DuckDB is not implemented yet. Any DuckDB work must be additive and must not imply that all PostgreSQL-specific SwifQL APIs are DuckDB-compatible.
- SwifQL remains a query-building library. DuckDB C API or native execution-wrapper integration belongs outside this repository.

Later feature ideas are roadmap context, not implementation permission. They require their own research, plan, audit, and approval gates.
