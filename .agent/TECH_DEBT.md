# Verified Technical Debt

Only evidence-backed debt belongs here. Do not treat an entry as permission to change code outside an approved implementation scope.

1. **Unknown part dispatch omission** - `prepare(_:)` currently falls through to empty-string rendering for an unknown or unhandled `SwifQLPart`. A new part can therefore be silently omitted if dispatch support is forgotten. This remains verified debt and is not fixed by governance or render scopes.

2. **External `SQLDialect` subclass construction gap** - CLOSED for the audited extension path. An external consumer fixture proved that a downstream module can construct a custom `SQLDialect` subclass and use the additive context-aware rendering hook; `SQLDialect.init()` is public and the established hook remains the default forwarding boundary. Future extension surfaces still require focused external compile coverage.
