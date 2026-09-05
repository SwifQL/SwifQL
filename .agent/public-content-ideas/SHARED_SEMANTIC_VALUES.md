# Shared Semantic Values

Status: validated
Good for: README | website docs | release notes | article | short post

### Why one civil model helps

Applications often need the same civil date, time-of-day, civil timestamp, or structural interval while targeting different SQL dialects. Shared `PureDate`, `PureTime`, `DateTime`, and `Interval` values keep that meaning in one value model instead of multiplying product-prefixed duplicates.

### Candidate example / visual

```swift
let date = PureDate(year: 2026, month: 9, day: 4)!
let time = PureTime(hour: 12, minute: 34, second: 56, nanosecond: 123_456_789)!
let dateTime = DateTime(
    year: 2026,
    month: 9,
    day: 4,
    hour: 12,
    minute: 34,
    second: 56,
    nanosecond: 123_456_789
)!
let interval = Interval(months: 2, days: -3, microseconds: 4)
```

`PureDate` is not `Foundation.Date`; `PureTime` is not a duration; `DateTime` is not an instant; and `Interval` is not `TimeInterval`. `Foundation.Date` interop for `PureDate` and `DateTime` is explicit through a Gregorian `Calendar` and `TimeZone` and can fail.

### Exact dialect boundaries

The same values keep their semantic identity while dialects choose exact parser spelling and supported physical representations. Nanosecond lexical precision can be preserved even when a database has a narrower physical range or precision. For example, a positive extended `PureDate` keeps `+10000-01-01` as its canonical Swift spelling while Duck accepts the parser spelling `10000-01-01`.

MySQL is a useful portability example: finite supported years and exact microsecond precision render as typed `DATE`, `TIME`, or `DATETIME`, while unsupported years, special states, and non-microsecond nanoseconds fail closed rather than being rounded or silently coerced. Duck `TIMESTAMP_NS` has a finite physical epoch range, and shared interval infinity states are not native Duck interval infinity.

### Structural intervals

`Interval(months: 2, days: -3, microseconds: 4)` preserves three independent signed components. The model does not flatten months or days into a guessed duration. Exact Swift `Duration` conversion is limited to finite intervals with zero months and days.

### Binding and schema guidance

All four values use the ordinary SwifQL value path, so preparation keeps one ordered collector and preserves the dynamic Swift values in `.splitted.values`. `PureDate` and `PureTime` have honest automatic `.date` and `.time` inference; `Foundation.Date` remains `.timestamptz`; `DateTime` and `Interval` retain `.text` fallback and should use explicit schema types when `.timestamp` or `.interval` is intended.

### Evidence / provenance

Validated source owners are `PureDate.swift`, `PureTime.swift`, `DateTime.swift`, and `Interval.swift`, with focused binding, rendering, inference, and per-type tests. The current source branch includes the shared value layer and its cross-dialect evidence.

### Publication caveat

The shared value layer is not in the published `2.0.0-beta.5.1.0` tag. Future public material must remain **Unreleased / Next SwifQL 2 prerelease** until a maintainer explicitly chooses and publishes a later version.
