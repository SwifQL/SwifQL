# Builders and QueryParts Architecture

This file is the sole owner of `BUILD-*` rules.

## Verified current model

Builders are ergonomic state and composition helpers that return normal `SwifQLable` output. `QueryParts` currently stores `joins`, `wheres`, `groupBy`, `havings`, `orderBy`, `offset`, and `limit`. Its `buildQuery()` materializes those shared clauses in the current order: joins, where clauses, grouping, having clauses, ordering, limit, then offset. `appended(to:)` adds the materialized parts to an existing `SwifQLable`.

`SwifQLSelectBuilder` stores select and from state itself, keeps shared clause state in `queryParts`, and uses `queryParts.appended(to:)` when building. The result re-enters the normal `SwifQLable` preparation path. Not every future builder field is automatically a `QueryParts` concern.

## Rules

### BUILD-001 — Composition layer

Builders are composition and state helpers, not SQL renderers.

### BUILD-002 — Shared clause ownership

`QueryParts` owns only its implemented shared clause state and canonical materialization order.

### BUILD-003 — Normal preparation

Builder output re-enters normal `SwifQLable` preparation.

### BUILD-004 — Reuse without duplication

New builder state reuses `QueryParts` when it is one of the shared clause concerns already owned there, rather than duplicating that state. Other builder-specific state may remain with its builder when appropriate.
