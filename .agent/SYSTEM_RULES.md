# System Rules

These are the repository-wide invariants. Detailed architecture contracts belong to their single owners in `.agent/architecture/` and are routed by `ARCH_INDEX.md`.

## Evidence and planning

- Non-trivial work is gated by verified research, a detailed plan saved in `.artifacts/`, an independent plan audit, implementation, and independent repository audit.
- Stable documentation distinguishes verified current implementation from planned architecture.
- If a reviewed material assumption becomes false, stop the affected work and re-plan rather than improvising.

## Ownership and compatibility

- Every architecture ID has exactly one authoritative owner.
- Public-library changes are additive and backwards-compatible by default.
- Preserve existing PostgreSQL and MySQL behavior unless a separately approved bug-fix scope changes it.
- Public DSL/API design must follow `architecture/DSL_DESIGN_AND_UX.md`: SQL-first vocabulary, transparent exact-SQL identities, explicit dialect-specific surfaces, and clearly named semantic conveniences.
- Prefer the existing architecture, narrow APIs, and direct concrete implementation over speculative abstractions or framework expansion.
- Reuse existing composable SQL when it already expresses the target syntax clearly; do not create redundant builders or a parallel dialect mini-framework for symmetry.
- Do not perform opportunistic modernization, broad renaming, or unrelated cleanup outside approved scope.

## Documentation discipline

- Synchronize documentation selectively when an owned durable fact changes; do not duplicate another owner's contract.
- Stable repository authority lives in `.agent/`. Research, plans, evidence, task decomposition, and implementation history remain transient in `.artifacts/`.
- Reports and agent claims are evidence inputs, not proof; the actual repository state must be audited.
