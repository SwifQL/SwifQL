---
name: swifql-query-building
description: Build, translate, review, or prepare SQL in downstream Swift code that imports SwifQL. Use for application or package query construction and preparation, not for changing SwifQL's own builders, functions, dialect implementation, renderer, or core source.
---

# Build Queries with SwifQL

Use this workflow for downstream code that consumes SwifQL.

1. Determine the SwifQL version the consumer actually uses. Check `Package.swift`, `Package.resolved`, the resolved checkout, or installed source as appropriate. Do not assume the latest API exists.
2. Start from the SQL you intend to express. Keep the SwifQL call site SQL-shaped rather than inventing a separate abstraction first.
3. For uncommon or version-sensitive syntax, inspect the installed SwifQL source and tests before choosing an API. Do not invent symbols from memory.
4. Classify every input as SQL structure or dynamic data. Identifiers, clauses, operators, and deliberately modeled syntax are structure; ordinary runtime values are data.
5. Keep ordinary dynamic or untrusted values on SwifQL's normal value path. Do not interpolate them into raw/custom SQL structure.
6. Prepare using the actual target dialect supported by the installed version: `.psql`, `.mysql`, or `.duck` when available there.
7. Use `.plain` to inspect rendered SQL with values formatted inline. Use `.splitted` for driver-facing SQL plus the ordered bind values.
8. Stop after construction and preparation. SwifQL builds SQL; database execution belongs to a driver or an integration layer such as Bridges.

A representative downstream query follows the same shape as its SQL:

```swift
let email = inputEmail
let query = SwifQL
    .select(User.table.*)
    .from(User.table)
    .where(\User.email == email)

let prepared = query.prepare(.psql)
let inspectionSQL = prepared.plain
let driverSQL = prepared.splitted.query
let bindValues = prepared.splitted.values
```

The runtime `email` must remain a value/bind input. Do not rewrite it into raw SQL merely to reproduce a desired string.

When translating SQL to SwifQL, preserve statement structure first, then verify the prepared output and bind order for the target dialect. If the installed version does not expose a clean API for an uncommon construct, inspect that version's source/tests and use only APIs that actually exist rather than guessing a newer or dialect-specific helper.
