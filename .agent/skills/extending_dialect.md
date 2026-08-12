# Skill: Extending a SQL Dialect

Use this research-first procedure when adding or changing a SQL dialect. The primary architecture owner is [`DIALECT_RENDERING.md`](../architecture/DIALECT_RENDERING.md); preparation support is [`QUERY_PREPARATION.md`](../architecture/QUERY_PREPARATION.md).

1. Load [`DIALECT_RENDERING.md`](../architecture/DIALECT_RENDERING.md) as primary, [`QUERY_PREPARATION.md`](../architecture/QUERY_PREPARATION.md) as supporting context, plus [`TESTING_RULES.md`](../TESTING_RULES.md) and [`SOURCE_MAP.md`](../SOURCE_MAP.md).
2. Inspect live Git, source, and test state before proposing implementation.
3. Before implementation, research current official database behavior and save a compatibility matrix in `.artifacts/**`.
4. The matrix explicitly covers identifiers, primitive values and string escaping, dates/timestamps/time zones, bind parameters, arrays/lists, JSON/key paths, casts/types, generic DML, generic DDL, operators, functions, hybrid operators, and tests/`SQLDialect.all` impact.
5. Do not infer compatibility from PostgreSQL syntactic similarity.
6. Preserve existing supported-dialect output byte-for-byte unless a separately approved bug fix changes it.
7. Write a detailed implementation-ready `.artifacts` plan and independently audit it before code.
8. Decompose a large implementation into sequential surgical tasks.
9. Synchronize stable support statements only after source and tests exist and pass independent audit.

Do not embed final DuckDB answers before the DuckDB research phase establishes them.
