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
- current unreleased Duck file: `Sources/SwifQL/Dialect/Dialect+DuckDB.swift`

The current unreleased Duck source still contains `DuckDB...` / `duckDB...` filenames and symbols. Do not treat that spelling as naming authority. The approved Swift convention is `.duck`, `Duck...`, and `duck...`; the source tree is queued for pre-release cleanup after the dialect-transparent API design is finalized.

Current Duck-specific values, types, and paths:

- `Sources/SwifQL/Type+DuckDB.swift`
- `Sources/SwifQL/Parts/DataPart.swift`
- `Sources/SwifQL/Parts/CatalogPart.swift`
- `Sources/SwifQL/Path/Path+DuckDB*.swift`

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

DuckDB functions:

- `Sources/SwifQL/Functions/Functions+DuckDB*.swift`

DuckDB builders and compositional parts:

- `Sources/SwifQL/Builders/DuckDB*.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+DuckDB*.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+OrderByAll.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+Qualify.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+Sample.swift`
- `Sources/SwifQL/SwifQLable+Parts/SwifQLable+UnionByName.swift`

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
- `Tests/SwifQLTests/DuckDB*.swift` — DuckDB dialect and feature coverage.
- `Tests/SwifQLTests/**` — focused feature and query tests.

Editor settings, generated output, local user state, and transient `.artifacts/**` are not product architecture authority.
