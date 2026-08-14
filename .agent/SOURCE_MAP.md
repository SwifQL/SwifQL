# SwifQL Source Map

This is a navigation aid, not an architecture contract. Use it to locate the smallest relevant source and test subset before broad discovery.

## Package

- `Package.swift` — Swift package manifest, products, targets, and dependency declaration.

## Core preparation and output

- `Sources/SwifQL/SwifQLable.swift`
- `Sources/SwifQL/Prepared.swift`
- `Sources/SwifQL/Formatter.swift`

## Dialects

Architecture owners:

- `.agent/architecture/DIALECT_RENDERING.md` - cross-dialect rendering architecture.
- `.agent/architecture/dialects/DUCK.md` - Duck-specific contract, native evidence, naming/UX, and pre-release blockers.
- `.agent/architecture/dialects/POSTGRES.md` - PostgreSQL-specific compatibility owner.
- `.agent/architecture/dialects/MYSQL.md` - MySQL-specific compatibility owner.

Core source:

- `Sources/SwifQL/Dialect/Dialect.swift`
- `Sources/SwifQL/Dialect/Dialect+Postgres.swift`
- `Sources/SwifQL/Dialect/Dialect+MySQL.swift`
- `Sources/SwifQL/Dialect/Dialect+Duck.swift`
- `Sources/SwifQL/Dialect/SwifQLRenderContext.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+Scoped.swift`

Current Duck production source is intentionally narrow: `.duck`, `DuckDialect`, render scopes/context, and scoped preparation. Broader Duck SQL features, Data rendering, catalog paths, and statement APIs are not yet part of the active source surface.

## Hybrid syntax

- `Sources/SwifQL/Parts/HybridOperatorPart.swift`
- `Sources/SwifQL/HybridOperator.swift`

## Parts and fluent composition

- `Sources/SwifQL/Parts/**` — concrete SQL parts.
- `Sources/SwifQL/SwifQLable+Parts/**` — fluent/compositional extensions.

## Builders and common clause state

- `Sources/SwifQL/Builders/**` — builder implementations.
- `Sources/SwifQL/QueryParts.swift` — shared query clause state.
- `Sources/SwifQL/QueryBuilderable.swift` — builder-related protocol surface.

## Functions

- `Sources/SwifQL/Functions/**` — function helpers and function-related extensions.

## Types, casts, predicates, and adjacent values

- `Sources/SwifQL/Type.swift`
- `Sources/SwifQL/Type+SwifQLable.swift`
- `Sources/SwifQL/Predicates.swift`
- `Sources/SwifQL/ExtractFieldValue.swift`
- `Sources/SwifQL/Enum.swift`

## PostgreSQL-named or PostgreSQL-specific surface

- `Sources/SwifQL/Builders/PostgresArray.swift`
- `Sources/SwifQL/Builders/PostgresJsonObject.swift`
- `Sources/SwifQL/Functions/Functions+Postgres*.swift`
- `Sources/SwifQL/Functions/Functions+TextSearch.swift`

## Tests

- `Tests/SwifQLTests/SwifQLTestCase.swift` - shared test helpers.
- `Tests/SwifQLTests/DuckDBDialectTests.swift` - focused Duck foundation coverage.
- `Tests/SwifQLTests/EstablishedOperatorCompatibilityTests.swift` - PostgreSQL/MySQL compatibility guard for an established operator shape.
- `Tests/SwifQLTests/**` - established focused feature and query tests.

Editor settings, generated output, local user state, backup branches, and transient `.artifacts/**` are not product architecture authority.
