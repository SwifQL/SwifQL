# Open Decisions

This file records genuinely unresolved choices, not settled architecture rules or task logs.

## Record format

- Decision ID:
- Architecture owner:
- Question:
- Why it matters:
- Status: blocking or non-blocking
- Resolution timing:

## Active decisions

### DUCK-HYBRID-001

- Architecture owner: `architecture/DIALECT_RENDERING.md` with `architecture/dialects/DUCK.md` supporting.
- Question: What should `.duck` preparation do for a downstream `SwifQLHybridOperator` created with the established public two-argument PostgreSQL/MySQL initializer and therefore no explicit Duck branch?
- Why it matters: source compatibility requires preserving the old initializer, while final Duck support must not silently claim another dialect's syntax is correct.
- Status: blocking final Duck closure.
- Resolution timing: during fresh Duck hybrid/API research before adding `.duck` to `SQLDialect.all`.

### DUCK-OPERATOR-PRECEDENCE-001

- Architecture owner: `architecture/DIALECT_RENDERING.md` with `architecture/dialects/DUCK.md` and `architecture/DSL_COMPOSITION.md` supporting.
- Question: What is the narrow clean mechanism for Duck JSON/key-path operator precedence after rejecting global operator-operand scoping?
- Why it matters: the replacement must preserve PostgreSQL/MySQL/downstream extension part shape and attach context only where semantically owned.
- Status: blocking final Duck operator/key-path support.
- Resolution timing: fresh official/native Duck precedence research before any broad operator change.

