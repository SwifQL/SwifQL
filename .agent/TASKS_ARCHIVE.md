# Task Archive

This file keeps compact history only. A completed entry records identity, durable outcome, and a current owner or reference when useful.

Do not add file inventories, Git logs, execution-report dumps, hashes, or detailed implementation diaries here.

## Completed

- Agent-governance migration: established repository-owned authority, routing, context-loading, architecture ownership, Git safety, model-independent development orchestration, and state separation; removed the external workflow dependency. Independent final repository audit passed.
- Additive `Fn` camelCase migration and DuckDB SQL dialect support: canonical camelCase `Fn` declarations now own the existing supported implementations, deprecated snake_case aliases preserve source compatibility and identical SQL, and DuckDB is an explicit feature-specific SQL-rendering dialect included in `SQLDialect.all`; unsupported or unverified PostgreSQL-specific surfaces remain unclaimed.
