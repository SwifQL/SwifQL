# Skill Index

Skills are reusable operational procedures, not architecture authority. Architecture rules remain in `.agent/architecture/**` and are routed by `ARCH_INDEX.md`.

Source-owned skill packages live under `.agent/skills/<name>/SKILL.md`. Load at most one skill by default, and only when the task matches its procedure.

## Public / downstream skills

- `swifql-query-building` — build, translate, review, or prepare SQL in downstream code that consumes SwifQL. Do not use it for changing SwifQL's own builders, functions, dialects, renderer, or core source.
- `swifql-custom-extensions` — create downstream custom functions, fluent helpers, structural continuations, custom clause ownership, or reusable SwifQL extension libraries. Do not use it for built-in SwifQL source work.

## Repository contributor skills

- `adding-swifql-builder` — add or extend a built-in SwifQL builder and its established `QueryParts` boundaries.
- `adding-swifql-sql-function` — add or change a built-in compositional SQL function helper in SwifQL source.
- `extending-swifql-dialect` — research, add, or change a built-in SQL dialect using the repository's dialect-compatibility workflow.

The two public skills are intended for downstream distribution through the external `swiftstream/skills` collection. Their placement under `.agent/skills/` is source ownership, not a requirement that downstream harnesses discover or install them from this repository-local path. The three contributor skills are repository-local procedures unless a later audited decision changes that classification.

When a durable contract taught by a managed skill changes, review the affected skill before task closure. Change `SKILL.md` only when its guidance actually changes; do not create a parallel hand-maintained procedure copy elsewhere in the repository.

Create another skill only after repeated work demonstrates a stable, reusable procedure that does not belong in an architecture owner.
