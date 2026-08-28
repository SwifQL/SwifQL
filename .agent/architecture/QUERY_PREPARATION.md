# Query Preparation Architecture

This file is the sole owner of `PREP-*` rules and the detailed preparation/output contract.

## Verified preparation path

`SwifQLable.prepare(_:)` uses one recursive `render([SwifQLPart], context:)` traversal. It runtime-dispatches known concrete `SwifQLPart` types, recursively renders the internal scoped-part wrapper with a value-semantic `SwifQLRenderContext`, shares one ordered values/formatted-values collector across the traversal, assembles an internal query string, and returns `SwifQLPrepared`.

Nested `SwifQLPartArray` values and scoped expressions are traversed in order through that same renderer and dialect. Nested values and formatted values preserve the same depth-first order, with dialect array delimiters around assembled array fragments. No semantic-statement layer is part of the current approved preparation foundation; that remains the separately gated escalation boundary defined by `DIALECT-013`.

An unsafe value appends its value to `_values`, appends the dialect-formatted representation to `_formattedValues`, and emits the dialect's internal bind symbol into the query. The exact external bind-key syntax is owned by `DIALECT_RENDERING.md`.

Established `Data` composition remains unchanged. Hybrid operator preparation preserves the historical PostgreSQL/MySQL behavior while supported dialects may select an explicit representation key. Duck selects the `.duck` representation; a legacy two-branch hybrid without an explicit Duck representation fails deterministically rather than silently borrowing another dialect branch.

An unknown or unhandled part falls through the current `default: return ""` branch. Adding a concrete part that needs special rendering without dispatch support can therefore silently omit SQL and is a correctness hazard.

`SwifQLPrepared.plain` replaces internal bind markers with `_formattedValues`. `SwifQLPrepared.splitted` replaces those markers with dialect bind keys and returns the resulting query with the original `_values` order. `SwifQLFormatter` only traverses an assembled query, recognizes the dialect's internal marker, and replaces each marker in traversal order; it does not inspect `SwifQLPart`, build SQL structure, or understand DSL semantics.

## Rules

### PREP-001 — Single assembly path

`prepare(_:)` is the single final part-to-SQL assembly path.

### PREP-002 — Dispatch completeness

Every newly used concrete part requiring special rendering must have defined dispatch behavior. The current unknown-part empty-string fallback is a correctness hazard, not a completeness guarantee.

### PREP-003 — Aligned order

Query-marker order, values order, and formatted-values order stay aligned through preparation, formatting, and prepared output.

### PREP-004 — Formatter boundary

`SwifQLFormatter` is post-processing only and does not build SQL structure or inspect DSL semantics.

### PREP-005 — Shared prepared outputs

Plain and splitted output derive from the same prepared query and value ordering.

### PREP-006 — No parallel pipeline

No dialect may introduce a parallel SQL-generation or binding pipeline.

### PREP-007 — Structural SQL-region frames recurse through the same renderer

The evidence-proven major-version structural composition model may place opaque statement/subquery/set-result frame parts inside `parts`. Preparation recursively renders a frame's child parts through the same `prepare(_:)` traversal and the same ordered `values` / `formattedValues` collectors. A frame must not create a second renderer, formatter, or binding pass.

Entering a nested SQL-region frame establishes a fresh statement-local `SwifQLRenderContext`, so semantic render scopes owned by the parent statement do not leak into the nested statement/set-result region. This context reset does not reset or fork the binding collectors: value collection remains one deterministic depth-first traversal across the full structural tree.

Dedicated owner-sensitive clause parts persist already-selected ownership and may derive bounded child render scopes from that stored owner. Preparation must never rediscover clause ownership by scanning earlier parts, tokens, paths, or statement history.
