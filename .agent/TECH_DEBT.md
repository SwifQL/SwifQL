# Verified Technical Debt

Only evidence-backed debt belongs here. Do not treat an entry as permission to change code outside an approved implementation scope.

1. **Unknown part dispatch omission** - `prepare(_:)` currently falls through to empty-string rendering for an unknown or unhandled `SwifQLPart`. A new part can therefore be silently omitted if dispatch support is forgotten. This remains verified debt and is not fixed by the governance migration.

2. **External `SQLDialect` subclass construction gap** - `SQLDialect` is declared `open` and exposes open rendering hooks, but its base initializer is currently internal. Before stable documentation or new render-scope APIs claim third-party custom-dialect subclassing as a supported extension path, validate an external consumer fixture and make the intended construction surface usable if required. Do not work around this with unchecked/internal access tricks.
