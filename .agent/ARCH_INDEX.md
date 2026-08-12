# Architecture Index

This is the authoritative architecture router and ID-family map. Every architecture ID has exactly one owner; supporting documents link to that owner instead of duplicating its full rules.

## Architecture owners

| ID family | Sole owner | Concept |
| --- | --- | --- |
| `DSL-*` | `architecture/DSL_COMPOSITION.md` | composable DSL and part-level composition |
| `PREP-*` | `architecture/QUERY_PREPARATION.md` | preparation dispatch, value collection, prepared output, and formatter boundary |
| `DIALECT-*` | `architecture/DIALECT_RENDERING.md` | dialect identity, rendering, bind syntax, and hybrid dialect selection |
| `BUILD-*` | `architecture/BUILDERS_AND_QUERY_PARTS.md` | builders and `QueryParts` materialization |

Do not create placeholder architecture chunks for symmetry. Split or create a chunk only for a genuinely independent concept, and move an ID rather than defining it twice.

## Task routing

- New `SwifQLable`, `SwifQLPart`, or composition primitive: `DSL_COMPOSITION.md` primary; `QUERY_PREPARATION.md` supporting only when dispatch changes.
- New concrete part requiring preparation dispatch: `QUERY_PREPARATION.md` primary; `DSL_COMPOSITION.md` supporting.
- Dialect or new-database rendering: `DIALECT_RENDERING.md` primary; `QUERY_PREPARATION.md` supporting, with `TESTING_RULES.md` as policy.
- Formatter, bind-marker traversal, or value-order behavior: `QUERY_PREPARATION.md` primary; `DIALECT_RENDERING.md` supporting when placeholder syntax changes.
- Builder or `QueryParts` behavior: `BUILDERS_AND_QUERY_PARTS.md` primary; `DSL_COMPOSITION.md` supporting.
- A function that only composes existing parts: `DSL_COMPOSITION.md` or the applicable operational function skill; it does not receive a new architecture owner.
- Tests only: route to the owner of the behavior under test, with `TESTING_RULES.md` as policy.

## Supporting governance and context budget

- Workflow: `WORKFLOW.md`.
- Git safety: `COMMIT_RULES.md`.
- Progressive loading: `CONTEXT_LOADING_RULES.md`.
- Source navigation: `SOURCE_MAP.md`.
- Source/value/testing policy: `STYLE_GUIDELINES.md`, `SAFETY_RULES.md`, and `TESTING_RULES.md`; these do not own architecture IDs.

Normal work loads one primary owner and at most two supporting architecture owners. Cross-cutting audits may be explicit exceptions.
