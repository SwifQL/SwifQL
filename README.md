# SwifQL

This lib can work either stand alone, or with Vapor3.

For now it supports PostgreSQL and MySQL.

Please feel free to ask me any questions regarding this lib, either in issues or you could find me in the [Discord app](https://discordapp.com) as `@iMike#3049` to request some support (for free) 🙂

### Don't forget to support the lib by giving a ⭐️

## Installation

```swift
.package(url: "https://github.com/MihaelIsaev/SwifQL.git", from:"0.6.1")
```

### Stand alone
In your target's dependencies add `"SwifQL"` and `"SwifQLPure"`, e.g. like this:
```swift
.target(name: "App", dependencies: ["SwifQL", "SwifQLPure"]),
```

### With vapor 3
In your target's dependencies add `"SwifQL"` and `"SwifQLVapor"`, e.g. like this:
```swift
.target(name: "App", dependencies: ["Vapor", "SwifQL", "SwifQLVapor"]),
```

## Philosophy

This lib provides you with ability to build an SQL query from a little tiny pieces of it.

For example if you'd like to execute
```sql
SELECT * FROM "User" WHERE "email" = 'john.smith@gmail.com'
```

then with SwifQL you can build it like this
```swift
SwifQL.select(User.table.*).from(User.table).where(\User.email == "john.smith@gmail.com")
```

### How it works under the hood

`SwifQL` object needed just to start writing query, but it's just an empty object that conforms to `SwifQLable`.

You can build your query with everything which conforms to `SwifQLable`, because `SwifQLable` is that very piece which will be used for concatenation to build a query.

> If you take a look at the lib's files you may realize that the most of files are just extensions to `SwifQLable`.

All available operators like `select`, `from`, `where`, and `orderBy` realized just as a function in `SwifQLable` extension and these functions always returns `SwifQLable` as a result. That's why you can write a query by calling `SwifQL.select().from().where().orderBy()` one by one. That's awesome cause it feels like writing a raw SQL, but it also gives you an ordering limitation, so if you write `SwifQL.select().where().from()` then you'll get wrong query as a result. But this limitation is resolved by using special builders, like `SwifQLSelectBuilder` (read about it later below).

So let's take a look how lib builds a simple `SELECT "User".* FROM "User" WHERE "User"."email" = 'john.smith@gmail.com'` query

First of all we should split query into the parts. Almost every word and punctuation here is a `SwifQLable` piece.

- `SELECT` is `Fn.Operator.select`
- ` ` is `Fn.Operator.space`
- `"User"` is `User.table`
- `.*` is `postfix operator .*`
- ` ` is `Fn.Operator.space`
- `FROM` is `Fn.Operator.from`
- `"User"` is `User.table`
- ` ` is `Fn.Operator.space`
- `WHERE` is `Fn.Operator.where`
- ` ` is `Fn.Operator.space`
- `"User"."email"` is `\User.email` keypath
- ` ` is `Fn.Operator.space`
- `==` is `infix operator ==`
- ` ` is `Fn.Operator.space`
- `'john.smith@gmail.com'` is `SwifQLPartUnsafeValue` (it means that this value should be passed as $1 to the database)

That's crazy, but awesome, right? 😄 But it's under the hood, so no worries! 😃 I just wanted to explain, that if you need something more than already provided then you'll be able to add needed operators/functions easily just by writing little extensions.

> And also there is no overhead, it works pretty fast, but I'd love to hear if you know how to make it faster.

This way gives you almost absolute flexibility in building queries. More than that as lib support `SQLDialect`'s it will build this query different way for PostgreSQL and MySQL, e.g.:

- PostgreSQL: `SELECT "User".* FROM "User" WHERE "User"."email" = 'john.smith@gmail.com'`
- MySQL: `SELECT User.* FROM User WHERE User.email = 'john.smith@gmail.com'`

## Usage

### Preparation

#### With Vapor
There is nothing to do.

Just don't forget to `import SwifQLVapor` and `import SwifQL`. You have to import them together cause Swift won't export predicates from `SwifQL` through `SwifQLVapor`, unfortunately.

#### With pure Swift or other frameworks
Your database models like `User` should be conformed to `Table` protocol.

Don't forget to `import SwifQLPure` and `import SwifQL`. You have to import them together cause Swift won't export predicates from `SwifQL` through `SwifQLPure`, unfortunately.

### How to build query

> Instead of writing `Model.self` you should write `Model.table`, cause without Vapor you should conform your models to `Table`, and with Vapor its `Model`s are already conforms to `Table`.

```swift
let query = SwifQL.select(\User.email, \User.name, \User.role)
                  .from(User.table)
                  .orderBy(.asc(\User.name))
                  .limit(10)
```

### How to get raw query string (common case for pure Swift usage)

##### You can either get unsafe raw SQL string
```swift
let rawSQLString = query.prepare(.psql).plain
```

##### or get splitted object into formatted raw SQL string with $ symbols and separated array of unsafe values
```swift
let splittedQuery = query.prepare(.psql).splitted
let formattedSQLQuery = splittedQuery.query // formatted raw SQL string with $ symbols instead of values
let values = splittedQuery.values // an array of [Encodable] values
```

Then just put it into your database driver somehow 🙂

### How to execute and decode it with Vapor's PostgreSQL or MySQL drivers

##### In case if you have a `Container` like `req: Request` or `app: Application`
```swift
query.execute(on: req, as: .psql) //for PostgreSQL
query.execute(on: req, as: .mysql) //for MySQL
```

##### In case if you want to execute it directly on `SQLConnection`
```swift
query.execute(on: connection)
```

Anyway it will return you a `Future<SQLRawBuilder>` which can be easily used for results decoding.

##### Decoding
Vapor's `SQLRawBuilder` provides you with ability to decode all queried rows or only a first one

```swift
query.execute(on: connection).all(decoding: User.self) // returns Future<[User]>
query.execute(on: connection).first(decoding: User.self) // returns Future<User?>
query.execute(on: connection).first(decoding: User.self).unwrap(or: Abort(.notFound)) // throws or returns Future<User>
```

So, let's write a full simple example for querying current `User` model, e.g. for PostgreSQL:

```swift
func oneUser(_ req: Request) throws -> Future<User> {
    let user: User = try req.requireAuthenticated()
    return try SwifQL.select(\User.email, \User.name, \User.role)
                     .from(User.table)
                     .where(\User.id == user.requireID())
                     .execute(on: req, as: .psql)
                     .first(decoding: User.self)
                     .unwrap(or: Abort(.notFound, reason: "User not found"))
}
```

I believe that it looks good 😊

## Insert Into

### Single record
SQL example
```sql
INSERT INTO "User" ("email", "name") VALUES ('john@gmail.com', 'John Doe'), ('sam@gmail.com', 'Samuel Jackson')
```
SwifQL representation
```swift
SwifQL.insertInto(User.table, fields: \User.email, \User.name).values("john@gmail.com", "John Doe")
```

### Batch
SQL example
```sql
INSERT INTO "User" ("email", "name") VALUES ('john@gmail.com', 'John Doe'), ('sam@gmail.com', 'Samuel Jackson')
```
SwifQL representation
```swift
SwifQL.insertInto(User.table, fields: \User.email, \User.name).values(array: ["john@gmail.com", "John Doe"], ["sam@gmail.com", "Samuel Jackson"])
```

## Builders

For now I implemented only one builder

### Select builder

`SwifQLSelectBuilder` - by using it you could easily build a select query but in multiple lines without carying about ordering.

```swift
let builder = SwifQLSelectBuilder()
builder.where(\User.id == 1)
builder.from(User.table)
builder.limit(1)
builder.select(User.table.*)
let query = builder.build()
return query.execute(on: req, as: .psql)
            .first(decoding: User.self)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
```

So it will build query like: `SELECT "User".* FROM "User" WHERE "User"."id" = 1 LIMIT 1`.

As you can see you shouldn't worry about parts ordering, it will sort them the right way before building.

## More query examples

*Let's use `SwifQLSelectBuilder` for some next examples below, cause it's really convenient especially for complex queries.*

1. Let's imagine that you want to query count of users.

```swift
/// Just query
let query = SwifQL.select(Fn.count(\User.id) => "count").from(User.table)

/// Execution and decoding for Vapor
struct CountResult: Codable {
  let count: Int64
}
query.execute(on: req, as: .psql)
     .first(decoding: CountResult.self)
     .unwrap(or: Abort(.notFound)) // returns Future<CountResult>
```

Here you can see two interesting things: `Fn.count()` and `=> "count"`

`Fn` is a collection of function builders, so just call `Fn.` and take a look at the functions list on autocompletion.

`=>` uses for two things: 1) to write alias through `as` 2) to cast values to some other types

`// TBD: Expand list of examples`

## Aliasing
Use `=>` operator for that, e.g.:

If you want to write `SELECT "User"."email" as eml` then do it like this `SwifQL.select(\User.email => "eml")`

Or if to speak about table name aliasing:

If you want to reach `"User" as u` then do it like this `User.as("u")`

And then keypaths will work like

```swift
let u = User.as("u")
let emailKeypath = u~\.email
```

## Type casting
Use `=>` operator for that, e.g.:

If you want to write `SELECT "User"."email"::text` then do it like this `SwifQL.select(\User.email => .text)`

## Predicates
| Infix operator  | SQL equivalent |
| ------- | -------------- |
| > | > |
| >= | >= |
| < | < |
| <= | <= |
| == | = |
| == nil | IS NULL |
| != | != |
| != nil | IS NOT NULL |
| && | AND |

And also

`||` is for `OR`

`||>` is for `@>`

`<||` is for `<@`

> Please feel free to more predicates in `Predicates.swift` 😉

## Operators
Please feel free to take a look at `Fn.Operator` enum in `Functions.swift`

## Functions
Please feel free to take a look at the list of function in `Functions.swift`

## Postgres JSON Object
You could build JSON objects by using `PostgresJsonObject`

SQL example
```sql
jsonb_build_object('id', "User"."id", 'email', "User"."email")
```
SwifQL representation
```swift
PgJsonObject().field(key: "id", value: \User.id).field(key: "email", value: \User.email)
```

## Postgres Array
You could build PostgreSQL arrays by using `PostgresArray`

SQL example
```sql
$$[]$$
ARRAY[]
ARRAY[1,2,3]
$$[]$$::uuid[]
ARRAY[]::text[]
```
SwifQL representation
```swift
PgArray(emptyMode: .dollar)
PgArray()
PgArray(1, 2, 3)
PgArray(emptyMode: .dollar) => .uuidArray
PgArray() => .textArray
```

## CASE ... WHEN ... THEN ... END
SQL example
```sql
CASE
  WHEN "User"."email" IS NULL
  THEN NULL
  ELSE "User"."email"
END
```
SwifQL representation
```swift
Case(when: \User.email == nil, then: nil, else: \User.email)
```

## Brackets

Yes, we really often use round brackets in our queries, e.g. in where clauses or in subqueries.

SwifQL provides you with `|` prefix and postfix operators which is representates `(` and `)`.

So it's easy to wrap some part of query into brackets, e.g.:
SQL example
```sql
"User.role" = 'admin' OR ("User.role" = 'user' AND "User"."age" >= 21)
```
SwifQL representation
```swift
let where = \User.role == .admin || |\User.role == .user && \User.age >= 21|
```

## Keypaths
| SQL  | Swift |
| ------- | -------------- |
| `"User"` | `User.table` |
| `"User" as u` | `User.as("u")` you could declare it as `let u = User.as("u")` |
| `"User".*` | `User.table.*` |
| `u.*` | `u.*` |
| `"User"."email"` | `\User.email` |
| `u."email"` | `u~\.email` |
| `"User"."jsonObject"->"jsonField"` | `\User.jsonObject.jsonField` |
| `"User"."jsonObject"->"jsonField"` | `SwifQLPartKeyPath(table: "User", paths: "jsonObject", "jsonField")` |

## Tests

For now tests coverage is maybe around 25%. If you have timе and interest please feel free to send pull requests with more tests.

You could find tests in `Tests/SwifQLTests/SwifQLTests.swift`

## Contributing

Please feel free to contribute!

## TODO

I have a few todos in my list for PostgreSQL:

- [Conditional Expressions](https://www.postgresql.org/docs/current/functions-conditional.html)
- [Geometric Functions and Operators](https://www.postgresql.org/docs/current/functions-geometry.html)
- [Range Functions and Operators](https://www.postgresql.org/docs/current/functions-range.html)
- [Array Functions and Operators](https://www.postgresql.org/docs/current/functions-array.html)
