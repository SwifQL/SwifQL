# Active Tasks

This file contains only approved current work. Ideas, unresolved choices, verified debt, and completed history belong in their separate owners.

## Current state

Fresh Duck API/SQL-surface research and design is the only approved substantial work.

Goals:

- inventory the full intended Duck SQL surface from current live source and current DuckDB semantics;
- design clean SQL-shaped user-facing Swift APIs before implementation mechanics;
- reuse existing SwifQL composition wherever it already expresses the SQL cleanly;
- identify only the semantic render-scope integration points that verified grammar actually requires;
- preserve PostgreSQL/MySQL and downstream-extension compatibility under DESIGN-017;
- produce a detailed independently audited plan before any new Duck feature implementation.

No Duck implementation wave, Swift 6/Sendable implementation, or unrelated modernization is executable until that research/design/plan audit is complete.
