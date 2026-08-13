# Query Preparation Architecture

This file is the sole owner of `PREP-*` rules and the detailed preparation/output contract.

## Verified preparation path

`SwifQLable.prepare(_:)` iterates the ordered `parts` array and runtime-dispatches known concrete `SwifQLPart` types. It assembles an internal query string, collects `_values` and `_formattedValues`, and returns `SwifQLPrepared`.

Nested `SwifQLPartArray` values are prepared recursively in the same dialect. Elements are traversed in order; nested values and formatted values are appended in that same traversal order, with dialect array delimiters around the assembled fragments.

An unsafe value appends its value to `_values`, appends the dialect-formatted representation to `_formattedValues`, and emits the dialect's internal bind symbol into the query. The exact external bind-key syntax is owned by `DIALECT_RENDERING.md`.

Special `Data` values use their dedicated part and the dialect data hook. Hybrid operators select an explicit representation for each implemented dialect during this same preparation path; they do not create a second renderer.

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
