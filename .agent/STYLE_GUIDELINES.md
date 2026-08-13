# Style Guidelines

These are common SwifQL Swift/source conventions, within the architecture owners routed by `ARCH_INDEX.md`.

## Compatibility and scope

- Preserve the existing public API and established PostgreSQL/MySQL behavior by default.
- Prefer additive changes for this established library.
- Keep new public surfaces narrow and use the least access level needed.
- Do not perform unrelated modernization, broad renaming, package-platform or language changes, or cosmetic repository-wide rewrites inside a feature task.

## Implementation shape

- Prefer the existing architecture, focused extensions/files where natural, and direct readable control flow.
- Keep one semantic owner for each behavior or state.
- Choose a concrete implementation before introducing speculative protocols, factories, managers, or framework layers.
- Describe the implementation as parts-based composition and runtime dispatch. Parser, AST, and tokenization are not the primary SwifQL implementation model.
- Use the project's real terminology consistently: `SwifQLable`, `SwifQLPart`, `QueryParts`, `SQLDialect`, `SwifQLPrepared`, and `SwifQLFormatter`.
- New public Swift symbols use idiomatic Swift naming: lowerCamelCase for functions/properties/variables/enum cases and UpperCamelCase for types/protocols. SQL spelling remains exact in generated SQL and internal function/operator names even when SQL uses `snake_case` or uppercase.
- Historical public snake_case `Fn` symbols are compatibility surface only. The stable migration policy is to provide a canonical camelCase counterpart with identical SQL behavior and keep the old snake_case declaration as `@available(*, deprecated, renamed: "...")` delegating to that counterpart. Do not remove the legacy declaration in an additive release.
- Public API naming, SQL transparency, convenience boundaries, dialect-specific-vs-generic choices, and developer-experience rules are owned by `architecture/DSL_DESIGN_AND_UX.md`; do not redefine them here.

## Dialect implementation reference

- For source organization and implementation shape, follow the PostgreSQL local precedent routed through `architecture/DSL_DESIGN_AND_UX.md`: focused dialect hooks, semantic-area source folders, direct typed-part composition, and clean SQL-shaped user-facing APIs.
- A construct being supported by only one current dialect does not by itself justify a database-prefixed public Swift name. Prefer dialect-transparent call sites and keep database identity in rendering/support ownership where possible.
- If a DuckDB-specific Swift implementation symbol genuinely needs a database prefix, use `Duck...` for types and `duck...` for functions/helpers, never new `DuckDB...` / `duckDB...` prefixes. The canonical public dialect spelling is `.duck`, e.g. `prepare(.duck)`. Reserve the exact `"duckdb"` spelling for actual database identity/internal ids and human-facing prose, not Swift API prefixes.
- Current official documentation for the target database remains the semantic source of truth; local PostgreSQL code is a style reference, not a semantic compatibility oracle.

## Comments and authority

- Comments explain non-obvious intent, invariants, or compatibility constraints; they do not narrate obvious code or attribute work to a coding agent.
- Generated or otherwise unreviewed code is not automatically maintainer-style authority.
