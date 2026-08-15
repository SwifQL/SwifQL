# Verified Technical Debt

Only evidence-backed debt belongs here. Do not treat an entry as permission to change code outside an approved implementation scope.

1. **Unknown part dispatch omission** - `prepare(_:)` currently falls through to empty-string rendering for an unknown or unhandled `SwifQLPart`. A new part can therefore be silently omitted if dispatch support is forgotten. This remains verified debt and is not fixed by governance or render scopes.

2. **External `SQLDialect` subclass construction gap** - CLOSED for the audited extension path. An external consumer fixture proved that a downstream module can construct a custom `SQLDialect` subclass and use the additive context-aware rendering hook; `SQLDialect.init()` is public and the established hook remains the default forwarding boundary. Future extension surfaces still require focused external compile coverage.

3. **Generic SQL `name := expression` API is intentionally deferred** - Duck STRUCT/UNION construction/update and macro default/named-call grammar can require `:=`, while table-function options use the distinct `name = value` grammar. The maintainer explicitly deferred a generic public named-argument abstraction from the current Duck closure. Do not improvise a raw-string, product-prefixed, or cross-grammar placeholder. Revisit as a dedicated future API research task with SQL-first call-site examples, Swift naming/operator constraints, and downstream compatibility analysis.
