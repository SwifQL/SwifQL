# Context Loading Rules

This is the single owner of progressive context loading and the default context budget.

## Normal loading sequence

1. Read the root `AGENTS.md`.
2. For non-trivial iterative development/orchestration, load `DEVELOPMENT_ORCHESTRATION.md` and `ARTIFACTS_WORKFLOW.md` as operational authorities when their mechanics are needed. They do not consume architecture-owner slots and should not be loaded for routine architecture questions that do not involve execution workflow.
3. Use `.agent/ARCH_INDEX.md` to select one primary architecture owner.
4. For dialect work, load `architecture/DIALECT_RENDERING.md` plus exactly the relevant dialect owner under `architecture/dialects/` (`DUCK.md`, `POSTGRES.md`, or `MYSQL.md`). Treat this pair as one dialect architecture bundle for context-budget purposes. Do not load the other dialect owners unless the task is explicitly cross-dialect.
5. For any task that creates or changes public SQL/DSL API, naming, dialect-specific-vs-generic boundaries, convenience semantics, or developer experience, load `architecture/DSL_DESIGN_AND_UX.md` as the primary or a supporting architecture owner before designing source changes.
6. Outside the dialect bundle, load at most two supporting architecture owners when the task genuinely crosses their boundaries. In a normal focused dialect task, prefer only one additional architecture owner beyond the dialect bundle unless preparation mechanics force another.
7. Load `STYLE_GUIDELINES.md`, `SAFETY_RULES.md`, and/or `TESTING_RULES.md` only when the edit type needs those policies; policy documents do not consume architecture-owner slots.
8. Use `SKILL_INDEX.md` when a reusable operational procedure applies; load at most one skill by default.
9. Use `SOURCE_MAP.md` before broad source discovery, then inspect the smallest source/test subset needed. Use the PostgreSQL implementation as a local style reference only when `DSL_DESIGN_AND_UX.md` or the selected skill routes the task there; do not rediscover the whole repository by default.
10. Treat external reference repositories as zero by default; route deliberate external evidence through `REFERENCE_PROJECTS.md`.
11. Stop loading when ownership, design contract, scope, and evidence are sufficient.

Cross-cutting governance or architecture audits may deliberately exceed this default budget. Resume focused loading afterward.
