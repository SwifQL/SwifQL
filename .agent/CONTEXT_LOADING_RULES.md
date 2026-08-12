# Context Loading Rules

This is the single owner of progressive context loading and the default context budget.

## Normal loading sequence

1. Read the root `AGENTS.md`.
2. Use `.agent/ARCH_INDEX.md` to select one primary architecture owner.
3. Load at most two supporting architecture owners when the task genuinely crosses their boundaries.
4. Load `STYLE_GUIDELINES.md`, `SAFETY_RULES.md`, and/or `TESTING_RULES.md` only when the edit type needs those policies; policy documents do not consume architecture-owner slots.
5. Use `SKILL_INDEX.md` when a reusable operational procedure applies; load at most one skill by default.
6. Use `SOURCE_MAP.md` before broad source discovery, then inspect the smallest source/test subset needed.
7. Treat external reference repositories as zero by default; route deliberate external evidence through `REFERENCE_PROJECTS.md`.
8. Stop loading when ownership, scope, and evidence are sufficient.

Cross-cutting governance or architecture audits may deliberately exceed this default budget. Resume focused loading afterward.
