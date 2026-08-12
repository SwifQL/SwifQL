# SwifQL Governance Entrypoint

SwifQL is a strongly typed, declarative, composable Swift SQL-building library. It builds SQL; database execution belongs to database drivers or wrappers outside this repository.

PostgreSQL and MySQL are the implemented dialects. DuckDB is planned/active future work and is not implemented yet.

## Repository layout

- `AGENTS.md` is the concise repository router.
- `.agent/` contains durable governance and technical authority.
- `.artifacts/` contains transient research, plans, evidence, task decomposition, and reports.
- `Sources/SwifQL/` contains production source.
- `Tests/SwifQLTests/` contains the test suite.
- `Package.swift` defines the Swift package.

## Authority hierarchy

When stable documents conflict, follow this order:

1. `.agent/SYSTEM_RULES.md` — global invariants and stable/transient evidence rules.
2. `.agent/WORKFLOW.md` and `.agent/COMMIT_RULES.md` — development workflow and Git safety.
3. `.agent/ARCH_INDEX.md` plus exactly one owning `.agent/architecture/*.md` chunk — technical architecture authority.
4. `.agent/STYLE_GUIDELINES.md`, `.agent/SAFETY_RULES.md`, and `.agent/TESTING_RULES.md` — source, value, and testing policy within architecture boundaries.
5. `.agent/MASTER_PLAN.md` — durable library roadmap and current-versus-planned support boundary.
6. `.agent/OPEN_DECISIONS.md` — unresolved choices only.
7. `.agent/PROJECT_MEMORY.md` and `.agent/SOURCE_MAP.md` — durable current-state and navigation facts.
8. `.agent/TASKS.md`, `.agent/TODO.md`, `.agent/TECH_DEBT.md`, and `.agent/TASKS_ARCHIVE.md` — active work, future ideas, debt, and compact history.
9. `.agent/REFERENCE_PROJECTS.md`, `.agent/CONTEXT_LOADING_RULES.md`, `.agent/SKILL_INDEX.md`, and `.agent/skills/*` — evidence routing and operational procedures.
10. `.agent/CHATGPT.md` — ChatGPT-specific orchestration specialization; it cannot override higher authorities.

`.artifacts/**` is transient and never outranks stable repository authority.

## Required workflow

For non-trivial work, use detailed research -> detailed plan in `.artifacts` -> independent plan audit -> precise implementation -> independent diff/source audit -> corrections -> final audit. Follow `.agent/WORKFLOW.md` for the gates and `.agent/COMMIT_RULES.md` for Git safety.

Normal context loading is progressive: route through `.agent/ARCH_INDEX.md`, load one primary architecture owner and at most two supporting owners by default, use `.agent/SOURCE_MAP.md` before broad source discovery, and load at most one operational skill by default. Cross-cutting governance audits may be explicit exceptions.

Synchronize stable documentation only when an owned durable fact changes. Keep durable `.agent/` authority separate from transient `.artifacts/` evidence and implementation history. Route active tasks, unresolved decisions, current facts, future ideas, and verified debt to `TASKS.md`, `OPEN_DECISIONS.md`, `PROJECT_MEMORY.md`, `TODO.md`, and `TECH_DEBT.md` respectively. External evidence must be portable: stable documentation cannot depend on a machine-local checkout.
