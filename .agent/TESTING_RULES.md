# Testing and Validation Rules

This file defines SwifQL testing policy. Architecture-specific assertions remain governed by the owning architecture document routed through `.agent/ARCH_INDEX.md`; this file does not define architecture IDs or duplicate detailed preparation or dialect contracts.

## Swift Testing framework

- Swift Testing is the normal and required test framework for the SwifQL test target.
- New tests import `Testing` and use a human-readable behavior name with `@Test("...")`.
- Use `#expect(...)` for normal assertions.
- Use `Issue.record(...)` for an explicit unexpected or impossible branch when a direct expectation or throwing-test flow is not cleaner.
- Throwing operations whose failure should fail the test normally use a throwing test function with direct `try`.
- Do not reintroduce XCTest imports or assertions without a separately justified compatibility reason.

## Coverage layers

Meaningful SQL behavior is covered through the applicable combination of three layers:

1. **Focused SQL fragment/API coverage** for each meaningful SQL part, operator, builder method, helper or function overload, edge case, and value shape.
2. **Real-life composed query coverage** showing the feature inside realistic full or multi-part query construction when composition is part of its intended use.
3. **Dialect coverage** for every implemented dialect affected by the behavior.

A large real-life query does not replace focused fragment or overload cases. A fragment microtest does not replace real-life composition when composition is a meaningful risk. Realistic coverage should combine tables, schemas, aliases, predicates, values, functions, clauses or builders, subqueries or CTEs, DML or DDL, and bindings when relevant.

## Dialect classification

Classify every SQL-rendering test before writing expectations:

- Identical rendering across all implemented dialects uses `check(..., all:)`.
- The same capability across multiple dialects with different rendering uses explicit expectations for every affected implemented dialect.
- An intentionally dialect-specific capability uses explicit expectations only for dialects where that capability is intentionally supported or rendered.

Omission of an implemented dialect must be deliberate, not accidental. Adding a new dialect requires auditing both every `check(..., all:)` case and every explicit-dialect case. Rendered SQL is regression evidence for SwifQL rendering; it does not prove server-side semantic support of a feature.

## Bindings and deterministic output

When binding behavior changes, validate the bind placeholder query, values order and content when relevant, realistic multi-value cases where ordering could regress, and consistency between `.plain` and `.splitted` preparation. Deterministic input should produce deterministic output and stable bind order.

## Current test helpers

- `QueryWithDialect` currently provides `.psql(...)` and `.mysql(...)` helpers only.
- `check(_:all:)` currently iterates `SQLDialect.all` and compares plain output for each dialect.
- The focused `check` helper can also compare a supplied binded query, but the current helper does not by itself assert the returned values array; binding-sensitive tests should inspect value order when that is relevant.

The implemented dialect set is currently PostgreSQL and MySQL. Adding a third dialect changes the semantic reach of every `all` assertion, so audit and classify those tests before updating expectations; do not mechanically repair failing strings.

## Regression discipline

- Existing PostgreSQL and MySQL output remains byte-for-byte unchanged unless a separately approved bug fix intentionally changes it.
- A test-framework migration must not rewrite SQL expectations or production behavior.
- Governance does not impose TDD or a blanket coverage percentage.
