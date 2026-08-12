# Development Workflow

Non-trivial SwifQL work follows this ordered flow:

```text
DETAILED RESEARCH
-> DETAILED PLAN
-> SAVE PLAN INTO .artifacts
-> INDEPENDENT PLAN AUDIT
-> PRECISE IMPLEMENTATION
-> INDEPENDENT DIFF / SOURCE AUDIT
-> CORRECTIONS IF NEEDED
-> FINAL AUDIT
```

## Gates

- Trivial typo or format-only work may skip a formal artifact plan, but it still requires scope and result verification.
- Non-trivial implementation cannot start directly from an unreviewed idea. Research must establish current behavior, scope, risks, and acceptance evidence before planning.
- Material unresolved API or architecture choices are surfaced to the maintainer after research; they are not delegated to the implementation model.
- The plan declares exact mutation scope, forbidden paths, compatibility constraints, validation, and stop conditions. Surgical tasks are used when work is broad.
- Validation starts with the smallest relevant check and expands with the change's risk and scope.
- Implementation-model reports are evidence inputs, never proof of repository state. Independent review inspects the actual files, status, diff, links, and relevant source/tests.
- Stable documentation is synchronized only when the durable fact owned by that document changes. Transient execution history remains in `.artifacts/`.
- Git behavior, preservation, and authorization are owned by `.agent/COMMIT_RULES.md`.
