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

- `QueryWithDialect` should provide `.psql(...)`, `.mysql(...)`, and canonical `.duck(...)` helpers; the current unreleased `.duckdb(...)` helper is a pre-release naming defect to remove before further Duck work. The helpers can also assert an expected values array when binding order is part of the contract.
- `check(_:all:)` currently iterates `SQLDialect.all` and compares plain output for each dialect.
- The focused `check` helper can compare a supplied binded query and, when supplied, the returned values array.

The implemented dialect set is PostgreSQL, MySQL, and DuckDB. Adding a future dialect changes the semantic reach of every `all` assertion, so audit and classify those tests before updating expectations; do not mechanically repair failing strings.

## SQL fidelity and Swift naming assertions

- When a public API represents a concrete SQL keyword, type, function, operator, clause, or statement, focused tests assert that exact SQL construct rather than only a semantically similar result. For example, `Type.integer` must not be considered correct if it emits `SERIAL`, and Swift `Fn.jsonBuildArray(...)` must emit SQL `json_build_array(...)`, not `json_array(...)`.
- New public Swift API uses idiomatic camelCase even when emitted SQL uses `snake_case` or uppercase. Tests should use the stable camelCase API and assert the exact database spelling in generated SQL.
- Existing public snake_case `Fn` symbols use the stable additive naming migration: add a canonical camelCase counterpart and keep the old symbol as `@available(*, deprecated, renamed: "...")`. Migration tests must prove both spellings generate byte-for-byte identical SQL while ordinary feature tests/docs use the camelCase stable API.
- Convenience APIs may intentionally render different dialect syntax only when the API is explicitly semantic/convenience-oriented rather than named as one concrete SQL construct. Such behavior still requires explicit per-dialect expectations.
- New dialect-specific SQL should receive tests using its real SQL vocabulary and grammar, following the existing PostgreSQL-specific test style where applicable.

## Regression discipline

- Existing PostgreSQL and MySQL output remains byte-for-byte unchanged unless a separately approved bug fix intentionally changes it.
- A test-framework migration must not rewrite SQL expectations or production behavior.
- New dialect work must not repair a compatibility regression by changing an old PostgreSQL/MySQL expected string.
- Governance does not impose TDD or a blanket coverage percentage.

## Contextual rendering and composition equivalence

When semantic render scopes or another contextual-rendering mechanism is introduced or changed, tests must prove that semantics belong to the composed structure rather than one fluent call sequence.

Cover, as applicable:

- the same valid query written as one fluent chain;
- incremental `SwifQLable` variable reassignment with conditional clause inclusion;
- scoped expressions/fragments returned from helper functions and combined later;
- nested functions/subqueries while an outer render scope remains active for the relevant descendants;
- nested scopes with correct parent restoration;
- placeholder/value ordering identical to the equivalent unscoped composition rules;
- unaffected PostgreSQL/MySQL output remaining byte-for-byte stable.

If render scopes expose a public downstream extension surface, add a temporary external consumer compile fixture that imports SwifQL normally and proves the intended extension pattern without `@testable import`. If custom `SQLDialect` subclassing is part of that claimed extension contract, the fixture must prove construction/subclassing from another module rather than relying only on in-module tests.
