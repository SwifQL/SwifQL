# SwifQL Governance Entrypoint

SwifQL is a strongly typed, declarative, composable Swift SQL-building library. It builds SQL; database execution belongs to database drivers or wrappers outside this repository.

PostgreSQL and MySQL are established SQL-building dialects. Duck is unreleased; current source provides a minimal `.duck` rendering/context foundation while the broader Duck SQL surface is under fresh API/semantics research and design. Database execution belongs to database drivers or wrappers outside this repository.

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
2. `.agent/WORKFLOW.md`, `.agent/DEVELOPMENT_ORCHESTRATION.md`, `.agent/ARTIFACTS_WORKFLOW.md`, and `.agent/COMMIT_RULES.md` — development phases, model-independent orchestration, transient working-memory mechanics, and Git safety.
3. `.agent/ARCH_INDEX.md` plus the routed owning `.agent/architecture/**` chunk(s) - technical architecture authority. Normal work uses one primary owner; dialect work is the explicit bundled exception and loads `architecture/DIALECT_RENDERING.md` plus exactly one relevant `architecture/dialects/*.md` owner.
4. `.agent/STYLE_GUIDELINES.md`, `.agent/SAFETY_RULES.md`, and `.agent/TESTING_RULES.md` — source, value, and testing policy within architecture boundaries.
5. `.agent/MASTER_PLAN.md` — durable library roadmap and current-versus-planned support boundary.
6. `.agent/OPEN_DECISIONS.md` — unresolved choices only.
7. `.agent/PROJECT_MEMORY.md` and `.agent/SOURCE_MAP.md` — durable current-state and navigation facts.
8. `.agent/TASKS.md`, `.agent/TODO.md`, `.agent/TECH_DEBT.md`, and `.agent/TASKS_ARCHIVE.md` — active work, future ideas, debt, and compact history.
9. `.agent/REFERENCE_PROJECTS.md`, `.agent/CONTEXT_LOADING_RULES.md`, `.agent/PUBLIC_CONTENT_IDEAS.md`, `.agent/SKILL_INDEX.md`, and `.agent/skills/*` — evidence routing, lazy public-content capture, and focused operational procedures.

`.artifacts/**` is disposable, Git-ignored working memory and never outranks stable repository authority.

## Required workflow

For non-trivial work, use detailed research -> detailed plan in `.artifacts` -> independent plan audit -> numbered surgical tasks when needed -> precise implementation -> independent diff/source/Git audit -> correction wave if needed -> final audit. Follow `.agent/WORKFLOW.md` for phase gates, `.agent/DEVELOPMENT_ORCHESTRATION.md` for model-independent coordinator/executor roles, `.agent/ARTIFACTS_WORKFLOW.md` for transient task/report/handoff mechanics, and `.agent/COMMIT_RULES.md` for Git safety.

Normal context loading is progressive: route through `.agent/ARCH_INDEX.md`, load one primary architecture owner and at most two supporting owners by default, with one explicit dialect exception: dialect work loads the cross-dialect base plus exactly one relevant dialect owner as a single context bundle. Use `.agent/SOURCE_MAP.md` before broad source discovery and load at most one operational skill by default. Any work that designs or changes public SQL/DSL API or developer experience must load `.agent/architecture/DSL_DESIGN_AND_UX.md` so agents reuse the repository's established SQL-first and dialect-transparent design contract instead of rediscovering it from source. Cross-cutting governance audits may be explicit exceptions.

Synchronize stable documentation only when an owned durable fact changes. Keep durable `.agent/` authority separate from transient `.artifacts/` evidence and implementation history. After meaningful research/design/implementation/audit, perform the lazy public-content capture check owned by `.agent/PUBLIC_CONTENT_IDEAS.md`; open a shard only when genuinely valuable README/docs/publication material was discovered. Route active tasks, unresolved decisions, current facts, future ideas, and verified debt to `TASKS.md`, `OPEN_DECISIONS.md`, `PROJECT_MEMORY.md`, `TODO.md`, and `TECH_DEBT.md` respectively. External evidence must be portable: stable documentation cannot depend on a machine-local checkout.
