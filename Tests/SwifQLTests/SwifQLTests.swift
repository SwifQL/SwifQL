import XCTest
@testable import SwifQL

final class SwifQLTests: SwifQLTestCase {
    // MARK: String enum array
    
    func testStringEnumArray() {
        enum UserRole: String, SwifQLEnum {
            case admin
            case staff
            case vendor
        }
        check(
            SwifQL.in([UserRole.admin, .staff, .vendor]),
            .psql(#"IN ('admin', 'staff', 'vendor')"#),
            .mysql(#"IN ('admin', 'staff', 'vendor')"#)
        )
    }
    
    // MARK: Int enum array
    
    func testIntEnumArray() {
        enum UserRole: Int, SwifQLEnum {
            case admin = 0
            case staff = 1
            case vendor = 2
        }
        check(
            SwifQL.in([UserRole.admin, .staff, .vendor]),
            .psql(#"IN (0, 1, 2)"#),
            .mysql(#"IN (0, 1, 2)"#)
        )
    }
    
    // MARK: Int enum value alone
    
    func testIntEnumValueAlone() {
        enum UserRole: Int, SwifQLEnum {
            case admin = 0
            case staff = 1
            case vendor = 2
        }
        check(
            0 == UserRole.admin,
            .psql(#"0 = 0"#),
            .mysql(#"0 = 0"#)
        )
    }
    
    // MARK: String enum value alone
    
    func testStringEnumValueAlone() {
        enum UserRole: String, SwifQLEnum {
            case admin
            case staff
            case vendor
        }
        check(
            "admin" == UserRole.admin,
            .psql(#"'admin' = 'admin'"#),
            .mysql(#"'admin' = 'admin'"#)
        )
    }

    // MARK: Null Condition
    
    func testNullCondition() {
        check(
            "hello" == SwifQLNull,
            .psql(#"'hello' = NULL"#),
            .mysql(#"'hello' = NULL"#)
        )
        check(
            "hello" == nil,
            .psql(#"'hello' IS NULL"#),
            .mysql(#"'hello' IS NULL"#)
        )
    }
    
    // MARK: Enum array
    
    func testEnumArray() {
        check(
            [GearboxType.manual],
            .psql(#"'{manual}'"#),
            .mysql(#"'{manual}'"#)
        )
        check(
            [GearboxType.manual, .auto],
            .psql(#"'{manual,auto}'"#),
            .mysql(#"'{manual,auto}'"#)
        )
    }
    
    // MARK: Enum array type autodetect
    
    func testEnumArrayTypeAutodetect() {
        XCTAssertEqual(Type.auto(from: [GearboxType].self).name, "gearboxtype[]")
    }
    
    // MARK: ANY operator
    
    func testAnyOperator() {
        check(
            SwifQL.any("hello"),
            .psql(#"ANY('hello')"#),
            .mysql(#"ANY('hello')"#)
        )
    }
    
    // MARK: Update
    
    func testUpdateWithSchema() {
        let alias = CarBrands.inSchema("hello")
        check(
            SwifQL.update(alias.table).set[items: alias.$id == 1, alias.$createdAt == 2],
            .psql(#"UPDATE "hello"."CarBrands" SET "id" = 1, "createdAt" = 2"#),
            .mysql(#"UPDATE hello.CarBrands SET id = 1, createdAt = 2"#)
        )
    }
    
    func testUpdateAlreadySchemableWithSchemaDifferentSchema() {
        let alias = SchemableCarBrands.inSchema("hello")
        check(
            SwifQL.update(alias.table).set[items: alias.$id == 1, alias.$createdAt == 2],
            .psql(#"UPDATE "hello"."CarBrands" SET "id" = 1, "createdAt" = 2"#),
            .mysql(#"UPDATE hello.CarBrands SET id = 1, createdAt = 2"#)
        )
    }
    
    // MARK: Alias
    
    func testAlias() {
        check(
            CarBrands.as("c"),
            .psql(#""c""#),
            .mysql(#"c"#)
        )
        check(
            CarBrands.as("c").$id,
            .psql(#""c"."id""#),
            .mysql(#"c.id"#)
        )
        check(
            CarBrands.as("c").table,
            .psql(#""CarBrands" AS "c""#),
            .mysql(#"CarBrands AS c"#)
        )
        check(
            SchemableCarBrands.as("c").table,
            .psql(#""public"."CarBrands" AS "c""#),
            .mysql(#"public.CarBrands AS c"#)
        )
    }
    
    // MARK: Create Type
    
    func testCreateType() {
        check(
            SwifQL.type("mood"),
            .psql(#"TYPE "mood""#),
            .mysql(#"TYPE mood"#)
        )
        check(
            SwifQL.type("trololo", "mood"),
            .psql(#"TYPE "trololo"."mood""#),
            .mysql(#"TYPE trololo.mood"#)
        )
    }
    
    // MARK: Select enum
    
    private enum Mood: String, SwifQLEnum {
        case sad, happy
    }
    
    func testSelectEnum() {
        check(
            SwifQL.select(Mood.happy),
            .psql(#"SELECT 'happy'"#),
            .mysql(#"SELECT 'happy'"#)
        )
    }
    
    // MARK: Rename Table
    
    func testRenameTable() {
        check(UpdateTableBuilder<CarBrands>().renameTable(to: "aaa"),
              .psql(#"ALTER TABLE "CarBrands" RENAME TO "aaa";"#))
    }
    
    // MARK: Add Column
    
    func testAddColumn() {
        check(UpdateTableBuilder<CarBrands>().addColumn("aaa", .bigint, .default(0), .notNull),
              .psql(#"ALTER TABLE "CarBrands" ADD COLUMN "aaa" bigint DEFAULT 0 NOT NULL;"#))
    }

    func testAddColumnIfNotExits() {
        check(UpdateTableBuilder<CarBrands>().addColumn("aaa", .bigint, .default(0), checkIfNotExists: true, .notNull),
              .psql(#"ALTER TABLE "CarBrands" ADD COLUMN IF NOT EXISTS "aaa" bigint DEFAULT 0 NOT NULL;"#))
    }

    // MARK: Drop Column
    
    func testDropColumn() {
        check(UpdateTableBuilder<CarBrands>().dropColumn("aaa"),
              .psql(#"ALTER TABLE "CarBrands" DROP COLUMN "aaa";"#))
    }

    func testDropColumnIfExists() {
        check(UpdateTableBuilder<CarBrands>().dropColumn("aaa", checkIfExists: true),
              .psql(#"ALTER TABLE "CarBrands" DROP COLUMN IF EXISTS "aaa";"#))
    }

    func testDropColumnCascade() {
        check(UpdateTableBuilder<CarBrands>().dropColumn("aaa", cascade: true),
              .psql(#"ALTER TABLE "CarBrands" DROP COLUMN "aaa" CASCADE;"#))
    }

    func testDropColumnIfExistsCascade() {
        check(UpdateTableBuilder<CarBrands>().dropColumn("aaa", checkIfExists: true, cascade: true),
              .psql(#"ALTER TABLE "CarBrands" DROP COLUMN IF EXISTS "aaa" CASCADE;"#))
    }

    // MARK: Set Default
    
    func testSetDefault() {
        check(UpdateTableBuilder<CarBrands>().setDefault("aaa", constant: 0),
              .psql(#"ALTER TABLE "CarBrands" ALTER COLUMN "aaa" SET DEFAULT 0;"#))
    }
    
    // MARK: Drop Default
    
    func testDropDefault() {
        check(UpdateTableBuilder<CarBrands>().dropDefault("aaa"),
              .psql(#"ALTER TABLE "CarBrands" ALTER COLUMN "aaa" DROP DEFAULT;"#))
    }
    
    // MARK: Set Not Null
    
    func testSetNotNull() {
        check(UpdateTableBuilder<CarBrands>().setNotNull("aaa"),
              .psql(#"ALTER TABLE "CarBrands" ALTER COLUMN "aaa" SET NOT NULL;"#))
    }
    
    // MARK: Drop Not Null
    
    func testDropNotNull() {
        check(UpdateTableBuilder<CarBrands>().dropNotNull("aaa"),
              .psql(#"ALTER TABLE "CarBrands" ALTER COLUMN "aaa" DROP NOT NULL;"#))
    }
    
    // MARK: Rename Column
    
    func testRenameColumn() {
        check(UpdateTableBuilder<CarBrands>().renameColumn("aaa", to: "bbb"),
              .psql(#"ALTER TABLE "CarBrands" RENAME COLUMN "aaa" TO "bbb";"#))
    }
    
    // MARK: Add Unique
    
    func testAddUnique() {
        check(UpdateTableBuilder<CarBrands>().addUnique(to: "aaa", "bbb"),
              .psql(#"ALTER TABLE "CarBrands" ADD UNIQUE ("aaa", "bbb");"#))
    }
    
    // MARK: Add Primary Key
    
    func testAddPrimaryKey() {
        check(UpdateTableBuilder<CarBrands>().addPrimaryKey(to: "aaa", "bbb"),
              .psql(#"ALTER TABLE "CarBrands" ADD PRIMARY KEY ("aaa", "bbb");"#))
    }
    
    // MARK: Drop Constraint
    
    func testDropConstraint() {
        check(UpdateTableBuilder<CarBrands>().dropConstraint("aaa"),
              .psql(#"DROP CONSTRAINT "aaa";"#))
    }
    
    // MARK: Drop Index
    
    func testDropIndex() {
        check(UpdateTableBuilder<CarBrands>().dropIndex(name: "aaa"),
              .psql(#"DROP INDEX "aaa";"#))
    }
    
    // MARK: Create Index
    
    func testCreateIndex() {
        check(UpdateTableBuilder<CarBrands>().createIndex(unique: true,
                                                                                      name: "aaa",
                                                                                      items: .column("column3", order: .desc), .expression(SwifQLBool(true) == SwifQLBool(true)),
                                                                                      type: .hash,
                                                                                      where: SwifQLBool(true) == SwifQLBool(true)),
              .psql(#"CREATE UNIQUE INDEX "aaa" ON "CarBrands" USING HASH ("column3" DESC, (TRUE = TRUE)) WHERE TRUE = TRUE;"#))
    }
    
    // MARK: Add Check
    
    func testAddCheck() {
        check(UpdateTableBuilder<CarBrands>().addCheck(constraintName: "some_check", SwifQLBool(true) == SwifQLBool(false)),
              .psql(#"ALTER TABLE "CarBrands" ADD CONSTRAINT "some_check" CHECK (TRUE = FALSE);"#))
    }
    
    // MARK: Add Foreign Key
    
    func testAddForeignKey() {
        check(UpdateTableBuilder<CarBrands>().addForeignKey(column: "aaa", constraintName: "fk_aaa", schema: "deleted", table: "User", columns: "id", onDelete: .cascade, onUpdate: .noAction),
              .psql(#"ALTER TABLE "CarBrands" ADD CONSTRAINT "fk_aaa" FOREIGN KEY ("aaa") REFERENCES "deleted"."User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;"#))
    }
    
    //MARK: - Operators
    
    func testOperatorToSwifQLable() {
        check(SwifQL.select(Operator.null), .mysql("SELECT NULL"), .psql("SELECT NULL"))
    }
        
    //MARK: - ARRAY
    
    func testArray() {
        let emptyIntArray: [Int] = []
        check(
            emptyIntArray,
//            .mysql(""),
            .psql("")
        )
        check(
            SwifQLableParts(parts: emptyIntArray),
//            .mysql("''"),
            .psql("'{}'")
        )

        let nonEmptyIntArray: [Int] = [1,3,7]
        check(
            nonEmptyIntArray,
//            .mysql("1, 3, 7"),
            .psql("1, 3, 7")
        )
        check(
            SwifQLableParts(parts: nonEmptyIntArray),
//            .mysql("'1,3,7'"),
            .psql("ARRAY[1,3,7]", "ARRAY[$1,$2,$3]")
        )
        
        let emptyStringArray: [Int] = []
        check(
            emptyStringArray,
//            .mysql(""),
            .psql("")
        )
        check(
            SwifQLableParts(parts: emptyStringArray),
//            .mysql("''"),
            .psql("'{}'")
        )

        let nonEmptyStringArray: [String] = ["a", "b", "c"]
        check(
            nonEmptyStringArray,
//            .mysql("'a', 'b', 'c'"),
            .psql("'a', 'b', 'c'")
        )
        check(
            SwifQLableParts(parts: nonEmptyStringArray),
//            .mysql("'a','b','c'"),
            .psql("ARRAY['a','b','c']", "ARRAY[$1,$2,$3]")
        )
    }
    
    //MARK: - WHERE
    
    func testWhere() {
        check(SwifQL.where("" == 1), all: "WHERE '' = 1")
        check(SwifQL.where, all: "WHERE")
    }
    
    //MARK: - UNION
    func testUnion() {
        let table1 = Path.Table("Table1")
        let table2 = Path.Table("Table2")
        let table3 = Path.Table("Table3")
        check(
            Union(
                SwifQL.select(table1.*).from(table1),
                SwifQL.select(table2.*).from(table2),
                SwifQL.select(table3.*).from(table3)
            ),
            .psql(#"(SELECT "Table1".* FROM "Table1") UNION (SELECT "Table2".* FROM "Table2") UNION (SELECT "Table3".* FROM "Table3")"#),
            .mysql(#"(SELECT Table1.* FROM Table1) UNION (SELECT Table2.* FROM Table2) UNION (SELECT Table3.* FROM Table3)"#)
        )
        
        check(
            SwifQL
                .select(Distinct(Path.Column("uniqueName")) => .text => "name")
                .from(
                    Union(
                        SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table1),
                        SwifQL.select(Distinct(Path.Column("name")) => .text => "uniqueName").from(table2)
                    )
            ),
            .psql(#"SELECT DISTINCT "uniqueName"::text as "name" FROM (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table1") UNION (SELECT DISTINCT "name"::text as "uniqueName" FROM "Table2")"#),
            .mysql(#"SELECT DISTINCT uniqueName::text as name FROM (SELECT DISTINCT name::text as uniqueName FROM Table1) UNION (SELECT DISTINCT name::text as uniqueName FROM Table2)"#)
        )
    }

    //MARK: - VALUES
    
    func testValues() {
        check(
            SwifQL.values(1, 1.2, 1.234, "hello"),
            .psql("(1, 1.2, 1.234, 'hello')"),
            .mysql("(1, 1.2, 1.234, 'hello')")
        )
        check(
            SwifQL.values(array: [1, 1.2, 1.234, "hello"], [2, 2.3, 2.345, "bye"]),
            .psql("(1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')"),
            .mysql("(1, 1.2, 1.234, 'hello'), (2, 2.3, 2.345, 'bye')")
        )
    }
    
    // MARK: - BINDINGS
    
    func testBindingForPostgreSQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.psql).splitted.query
        XCTAssertEqual(query, """
        WHERE "CarBrands"."name" = $1 OR "CarBrands"."name" = $2
        """)
    }
    
    func testBindingForMySQL() {
        let query = SwifQL.where(CarBrands.column("name") == "hello" || CarBrands.column("name") == "world").prepare(.mysql).splitted.query
        XCTAssertEqual(query, """
        WHERE CarBrands.name = ? OR CarBrands.name = ?
        """)
    }
    
    // MARK: - FormattedKeyPath
    
    func testFormattedKeyPath() {
        check(
            SwifQL.select(FormattedKeyPath(CarBrands.self, "id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
        check(
            SwifQL.select(CarBrands.mkp("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    static var allTests = [
        ("testStringEnumArray", testStringEnumArray),
        ("testIntEnumArray", testIntEnumArray),
        ("testIntEnumValueAlone", testIntEnumValueAlone),
        ("testStringEnumValueAlone", testStringEnumValueAlone),
        ("testNullCondition", testNullCondition),
        ("testEnumArray", testEnumArray),
        ("testEnumArrayTypeAutodetect", testEnumArrayTypeAutodetect),
        ("testAnyOperator", testAnyOperator),
        ("testUpdateWithSchema", testUpdateWithSchema),
        ("testUpdateAlreadySchemableWithSchemaDifferentSchema", testUpdateAlreadySchemableWithSchemaDifferentSchema),
        ("testCreateType", testCreateType),
        ("testSelectEnum", testSelectEnum),
        ("testRenameTable", testRenameTable),
        ("testAddColumn", testAddColumn),
        ("testDropColumn", testDropColumn),
        ("testDropColumnIfExists", testDropColumnIfExists),
        ("testDropColumnCascade", testDropColumnCascade),
        ("testDropColumnIfExistsCascade", testDropColumnIfExistsCascade),
        ("testSetDefault", testSetDefault),
        ("testDropDefault", testDropDefault),
        ("testSetNotNull", testSetNotNull),
        ("testDropNotNull", testDropNotNull),
        ("testRenameColumn", testRenameColumn),
        ("testAddUnique", testAddUnique),
        ("testAddPrimaryKey", testAddPrimaryKey),
        ("testDropConstraint", testDropConstraint),
        ("testDropIndex", testDropIndex),
        ("testCreateIndex", testCreateIndex),
        ("testAddCheck", testAddCheck),
        ("testAddForeignKey", testAddForeignKey),
        ("testOperatorToSwifQLable", testOperatorToSwifQLable),
        ("testArray", testArray),
        ("testBindingForPostgreSQL", testBindingForPostgreSQL),
        ("testBindingForMySQL", testBindingForMySQL),
        ("testUnion", testUnion),
        ("testFormattedKeyPath", testFormattedKeyPath)
    ]
}
