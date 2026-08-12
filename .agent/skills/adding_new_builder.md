# Skill: Adding or Extending a Builder

Use this procedure when adding or extending a SwifQL builder. Architecture authority remains [`BUILDERS_AND_QUERY_PARTS.md`](../architecture/BUILDERS_AND_QUERY_PARTS.md).

1. Load [`BUILDERS_AND_QUERY_PARTS.md`](../architecture/BUILDERS_AND_QUERY_PARTS.md) as the primary owner and [`SOURCE_MAP.md`](../SOURCE_MAP.md) for navigation.
2. Inspect the nearest relevant production builder and `QueryParts` only as needed to establish current patterns.
3. Decide the exact state owner in the plan before mutation.
4. Reuse `QueryParts` only for shared clause state it already owns; keep builder-specific state with the builder when that is the established boundary.
5. Build normal `SwifQLable` output. Do not create a second renderer or bypass normal preparation.
6. Add focused validation/tests for the changed builder behavior, including dialect or binding expectations when affected.
7. Audit backwards compatibility, raw dynamic interpolation, and unrelated cleanup before handoff.
