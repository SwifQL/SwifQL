# Project Memory

This file keeps durable, non-obvious current facts that are useful beyond immediate source inspection. Architecture rules remain in their owners.

- `Package.swift` defines a dependency-free Swift package with one `SwifQL` library target and one `SwifQLTests` test target.
- Production source is under `Sources/SwifQL`; tests are under `Tests/SwifQLTests`.
- The implemented dialects are PostgreSQL and MySQL only. DuckDB is planned work and is not implemented.
- The compact current pipeline is composable parts -> `prepare(_:)` -> `SwifQLPrepared` and formatter output. See [`DSL_COMPOSITION.md`](architecture/DSL_COMPOSITION.md) and [`QUERY_PREPARATION.md`](architecture/QUERY_PREPARATION.md) for the owning contracts.
- The public library has a substantial historical PostgreSQL-specific surface; another dialect does not automatically make those helpers portable.
- Public-library backwards compatibility is important; preserve existing behavior by default.
