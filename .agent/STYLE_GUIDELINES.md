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

## Comments and authority

- Comments explain non-obvious intent, invariants, or compatibility constraints; they do not narrate obvious code or attribute work to a coding agent.
- Generated or otherwise unreviewed code is not automatically maintainer-style authority.
