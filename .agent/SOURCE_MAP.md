# SwifQL Source Map

This is a navigation aid, not an architecture contract. Use it to locate the smallest relevant source and test subset before broad discovery.

## Package

- `Package.swift` — Swift package manifest, products, targets, and dependency declaration.

## Core preparation and output

- `Sources/SwifQL/SwifQLable.swift`
- `Sources/SwifQL/Prepared.swift`
- `Sources/SwifQL/Formatter.swift`

## Dialects

- `Sources/SwifQL/Dialect/Dialect.swift`
- `Sources/SwifQL/Dialect/Dialect+Postgres.swift`
- `Sources/SwifQL/Dialect/Dialect+MySQL.swift`

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

- `Tests/SwifQLTests/SwifQLTestCase.swift` — shared test helpers.
- `Tests/SwifQLTests/**` — focused feature and query tests.

Editor settings, generated output, local user state, and transient `.artifacts/**` are not product architecture authority.
