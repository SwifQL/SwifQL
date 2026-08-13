# Verified Technical Debt

Only evidence-backed debt belongs here. Do not treat an entry as permission to change code outside an approved implementation scope.

1. **Unknown part dispatch omission** — `prepare(_:)` currently falls through to empty-string rendering for an unknown or unhandled `SwifQLPart`. A new part can therefore be silently omitted if dispatch support is forgotten. This remains verified debt and is not fixed by the governance migration.
