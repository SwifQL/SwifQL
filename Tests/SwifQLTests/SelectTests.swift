import XCTest
@testable import SwifQL

final class SelectTests: SwifQLTestCase {
    func testSelect() {
        check(SwifQL.select, all: "SELECT")
        check(SwifQL.select(), all: "SELECT ")
    }
    
    func testSelectString() {
        check(
            SwifQL.select("hello"),
            .psql("SELECT 'hello'"),
            .mysql("SELECT 'hello'")
        )
    }
    
    func testSelectInt() {
        check(
            SwifQL.select(1),
            .psql("SELECT 1"),
            .mysql("SELECT 1")
        )
    }
    
    func testSelectDouble() {
        check(
            SwifQL.select(1.234),
            .psql("SELECT 1.234"),
            .mysql("SELECT 1.234")
        )
    }

    func testSelectData() {
        let base64 = "Aa+/0w=="
        let data = Data(base64Encoded: base64)!
        check(
            SwifQL.select(data),
            .psql("SELECT decode('\(base64)', 'base64')")
        )
    }
    
    func testSelectSeveralSimpleValues() {
        check(
            SwifQL.select("hello", 1, 1.234),
            .psql("SELECT 'hello', 1, 1.234"),
            .mysql("SELECT 'hello', 1, 1.234")
        )
    }
    
    func testSelectColumn_path() {
        check(
            SwifQL.select(Path.Column("id")),
            .psql(#"SELECT "id""#),
            .mysql("SELECT id")
        )
    }
    
    func testSelectColumn_keyPath() {
        check(
            SwifQL.select(\CarBrands.$id),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    func testSelectColumn_keyPath_alias_simple() {
        check(
            SwifQL.select(\CarBrands.$id => "ident"),
            .psql(#"SELECT "CarBrands"."id" as "ident""#),
            .mysql("SELECT CarBrands.id as ident")
        )
    }
    
    func testSelectColumn_keyPath_alias_keyPath() {
        struct Result: Aliasable {
            @Alias("ident") var abc: UUID
            init () {}
        }
        check(
            SwifQL.select(\CarBrands.$id => \Result.$abc),
            .psql(#"SELECT "CarBrands"."id" as "ident""#),
            .mysql("SELECT CarBrands.id as ident")
        )
    }
    
    func testSelectColumnWithTable() {
        check(
            SwifQL.select(Path.Table("CarBrands").column("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    func testSelectColumnWithTableAndSchema() {
        check(
            SwifQL.select(Path.Schema("test").table("CarBrands").column("id")),
            .psql(#"SELECT "test"."CarBrands"."id""#),
            .mysql("SELECT test.CarBrands.id")
        )
    }
    
    func testSelectColumnWithoutTable() {
        check(
            SwifQL.select(Path.Column("id")),
            .psql(#"SELECT "id""#),
            .mysql("SELECT id")
        )
    }
    
    func testGenericSelector_all() {
        check(
            CarBrands.select,
            .psql(#"SELECT "CarBrands".* FROM "CarBrands""#),
            .mysql("SELECT CarBrands.* FROM CarBrands")
        )
    }
    
    func testSelectCarBrands() {
        check(
            SwifQL.select(CarBrands.column("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    func testSelectSchemableCarBrands() {
        check(
            SwifQL.select(SchemableCarBrands.column("id")),
            .psql(#"SELECT "public"."CarBrands"."id""#),
            .mysql("SELECT public.CarBrands.id")
        )
    }
    
    func testSelectCarBrandsInCustomSchema() {
        let cb = Schema<CarBrands>("hello")
        check(
            SwifQL.select(cb.column("id")),
            .psql(#"SELECT "hello"."CarBrands"."id""#),
            .mysql("SELECT hello.CarBrands.id")
        )
    }
    
    func testSelectCarBrandsSeveralFields() {
        check(
            SwifQL.select(CarBrands.column("id"), CarBrands.column("name")),
            .psql(#"SELECT "CarBrands"."id", "CarBrands"."name""#),
            .mysql("SELECT CarBrands.id, CarBrands.name")
        )
    }
    
    func testSelectCarBrandsWithAlias() {
        check(
            SwifQL.select(cb.column("id")),
            .psql(#"SELECT "cb"."id""#),
            .mysql("SELECT cb.id")
        )
    }
    
    func testSelectCarBrandsWithAliasSeveralFields() {
        check(
            SwifQL.select(cb.column("id"), cb.column("name")),
            .psql(#"SELECT "cb"."id", "cb"."name""#),
            .mysql("SELECT cb.id, cb.name")
        )
    }
    
    func testSelectCarBrandsSeveralFieldsMixed() {
        check(
            SwifQL.select(CarBrands.column("id"), cb.column("name"), CarBrands.column("createdAt")),
            .psql(#"SELECT "CarBrands"."id", "cb"."name", "CarBrands"."createdAt""#),
            .mysql("SELECT CarBrands.id, cb.name, CarBrands.createdAt")
        )
    }
    
    //MARK: PostgreSQL Functions
    
    func testSelectFnAbs() {
        check(
            SwifQL.select(Fn.abs(1)),
            .psql("SELECT abs(1)"),
            .mysql("SELECT abs(1)")
        )
    }
    
    func testSelectFnAvg() {
        check(
            SwifQL.select(Fn.avg(1)),
            .psql("SELECT avg(1)"),
            .mysql("SELECT avg(1)")
        )
    }
    
    func testSelectFnBitLength() {
        check(
            SwifQL.select(Fn.bit_length("hello")),
            .psql("SELECT bit_length('hello')"),
            .mysql("SELECT bit_length('hello')")
        )
    }
    
    func testSelectFnBtrim() {
        check(
            SwifQL.select(Fn.btrim("hello", "ll")),
            .psql("SELECT btrim('hello', 'll')"),
            .mysql("SELECT btrim('hello', 'll')")
        )
    }
    
    func testSelectFnCeil() {
        check(
            SwifQL.select(Fn.ceil(1.5)),
            .psql("SELECT ceil(1.5)"),
            .mysql("SELECT ceil(1.5)")
        )
    }
    
    func testSelectFnCeiling() {
        check(
            SwifQL.select(Fn.ceiling(1.5)),
            .psql("SELECT ceiling(1.5)"),
            .mysql("SELECT ceiling(1.5)")
        )
    }
    
    func testSelectFnCharLength() {
        check(
            SwifQL.select(Fn.char_length("hello")),
            .psql("SELECT char_length('hello')"),
            .mysql("SELECT char_length('hello')")
        )
    }
    
    func testSelectFnCharacter_length() {
        check(
            SwifQL.select(Fn.character_length("hello")),
            .psql("SELECT character_length('hello')"),
            .mysql("SELECT character_length('hello')")
        )
    }
    
    func testSelectFnInitcap() {
        check(
            SwifQL.select(Fn.initcap("hello")),
            .psql("SELECT initcap('hello')"),
            .mysql("SELECT initcap('hello')")
        )
    }
    
    func testSelectFnLength() {
        check(
            SwifQL.select(Fn.length("hello")),
            .psql("SELECT length('hello')"),
            .mysql("SELECT length('hello')")
        )
    }
    
    func testSelectFnLower() {
        check(
            SwifQL.select(Fn.lower("hello")),
            .psql("SELECT lower('hello')"),
            .mysql("SELECT lower('hello')")
        )
    }
    
    func testSelectFnLpad() {
        check(
            SwifQL.select(Fn.lpad("hello", 3, "lo")),
            .psql("SELECT lpad('hello', 3, 'lo')"),
            .mysql("SELECT lpad('hello', 3, 'lo')")
        )
    }
    
    func testSelectFnLtrim() {
        check(
            SwifQL.select(Fn.ltrim("hello", "he")),
            .psql("SELECT ltrim('hello', 'he')"),
            .mysql("SELECT ltrim('hello', 'he')")
        )
    }
    
    func testSelectFnPosition() {
        check(
            SwifQL.select(Fn.position("el", in: "hello")),
            .psql("SELECT position('el' IN 'hello')"),
            .mysql("SELECT position('el' IN 'hello')")
        )
    }
    
    func testSelectFnRepeat() {
        check(
            SwifQL.select(Fn.repeat("hello", 2)),
            .psql("SELECT repeat('hello', 2)"),
            .mysql("SELECT repeat('hello', 2)")
        )
    }
    
    func testSelectFnReplace() {
        check(
            SwifQL.select(Fn.replace("hello", "el", "ol")),
            .psql("SELECT replace('hello', 'el', 'ol')"),
            .mysql("SELECT replace('hello', 'el', 'ol')")
        )
    }
    
    func testSelectFnRpad() {
        check(
            SwifQL.select(Fn.rpad("hello", 2, "ho")),
            .psql("SELECT rpad('hello', 2, 'ho')"),
            .mysql("SELECT rpad('hello', 2, 'ho')")
        )
    }
    
    func testSelectFnRtrim() {
        check(
            SwifQL.select(Fn.rtrim(" hello ", " ")),
            .psql("SELECT rtrim(' hello ', ' ')"),
            .mysql("SELECT rtrim(' hello ', ' ')")
        )
    }
    
    func testSelectFnStrpos() {
        check(
            SwifQL.select(Fn.strpos("hello", "ll")),
            .psql("SELECT strpos('hello', 'll')"),
            .mysql("SELECT strpos('hello', 'll')")
        )
    }
    
    func testSelectFnSubstring() {
        check(
            SwifQL.select(Fn.substring("hello", from: 1)),
            .psql("SELECT substring('hello' FROM 1)"),
            .mysql("SELECT substring('hello' FROM 1)")
        )
        check(
            SwifQL.select(Fn.substring("hello", for: 4)),
            .psql("SELECT substring('hello' FOR 4)"),
            .mysql("SELECT substring('hello' FOR 4)")
        )
        check(
            SwifQL.select(Fn.substring("hello", from: 1, for: 4)),
            .psql("SELECT substring('hello' FROM 1 FOR 4)"),
            .mysql("SELECT substring('hello' FROM 1 FOR 4)")
        )
    }
    
    func testSelectFnTranslate() {
        check(
            SwifQL.select(Fn.translate("hola", "hola", "hello")),
            .psql("SELECT translate('hola', 'hola', 'hello')"),
            .mysql("SELECT translate('hola', 'hola', 'hello')")
        )
    }
    
    func testSelectFnLTrim() {
        check(
            SwifQL.select(Fn.ltrim("hello", "he")),
            .psql("SELECT ltrim('hello', 'he')"),
            .mysql("SELECT ltrim('hello', 'he')")
        )
    }
    
    func testSelectFnUpper() {
        check(
            SwifQL.select(Fn.upper("hello")),
            .psql("SELECT upper('hello')"),
            .mysql("SELECT upper('hello')")
        )
    }
    
    func testSelectFnCount() {
        check(
            SwifQL.select(Fn.count(CarBrands.column("id"))),
            .psql(#"SELECT count("CarBrands"."id")"#),
            .mysql("SELECT count(CarBrands.id)")
        )
        check(
            SwifQL.select(Fn.count(cb.column("id"))),
            .psql(#"SELECT count("cb"."id")"#),
            .mysql("SELECT count(cb.id)")
        )
    }
    
    func testSelectFnDiv() {
        check(
            SwifQL.select(Fn.div(12, 4)),
            .psql("SELECT div(12, 4)"),
            .mysql("SELECT div(12, 4)")
        )
    }
    
    func testSelectFnExp() {
        check(
            SwifQL.select(Fn.exp(12, 4)),
            .psql("SELECT exp(12, 4)"),
            .mysql("SELECT exp(12, 4)")
        )
    }
    
    func testSelectFnFloor() {
        check(
            SwifQL.select(Fn.floor(12)),
            .psql("SELECT floor(12)"),
            .mysql("SELECT floor(12)")
        )
    }
    
    func testSelectFnMax() {
        check(
            SwifQL.select(Fn.max(CarBrands.column("id"))),
            .psql(#"SELECT max("CarBrands"."id")"#),
            .mysql("SELECT max(CarBrands.id)")
        )
        check(
            SwifQL.select(Fn.max(cb.column("id"))),
            .psql(#"SELECT max("cb"."id")"#),
            .mysql("SELECT max(cb.id)")
        )
    }
    
    func testSelectFnMin() {
        check(
            SwifQL.select(Fn.min(CarBrands.column("id"))),
            .psql(#"SELECT min("CarBrands"."id")"#),
            .mysql("SELECT min(CarBrands.id)")
        )
        check(
            SwifQL.select(Fn.min(cb.column("id"))),
            .psql(#"SELECT min("cb"."id")"#),
            .mysql("SELECT min(cb.id)")
        )
    }
    
    func testSelectFnMod() {
        check(
            SwifQL.select(Fn.mod(12, 4)),
            .psql("SELECT mod(12, 4)"),
            .mysql("SELECT mod(12, 4)")
        )
    }
    
    func testSelectFnPower() {
        check(
            SwifQL.select(Fn.power(12, 4)),
            .psql("SELECT power(12, 4)"),
            .mysql("SELECT power(12, 4)")
        )
    }
    
    func testSelectFnRandom() {
        check(
            SwifQL.select(Fn.random()),
            .psql("SELECT random()"),
            .mysql("SELECT random()")
        )
    }
    
    func testSelectFnRound() {
        check(
            SwifQL.select(Fn.round(12.43)),
            .psql("SELECT round(12.43)"),
            .mysql("SELECT round(12.43)")
        )
        check(
            SwifQL.select(Fn.round(12.43, 1)),
            .psql("SELECT round(12.43, 1)"),
            .mysql("SELECT round(12.43, 1)")
        )
    }
    
    func testSelectFnSetSeed() {
        check(
            SwifQL.select(Fn.setseed(12)),
            .psql("SELECT setseed(12)"),
            .mysql("SELECT setseed(12)")
        )
    }
    
    func testSelectFnSign() {
        check(
            SwifQL.select(Fn.sign(12)),
            .psql("SELECT sign(12)"),
            .mysql("SELECT sign(12)")
        )
    }
    
    func testSelectFnSqrt() {
        check(
            SwifQL.select(Fn.sqrt(16)),
            .psql("SELECT sqrt(16)"),
            .mysql("SELECT sqrt(16)")
        )
    }
    
    func testSelectFnSum() {
        check(
            SwifQL.select(Fn.sum(CarBrands.column("id"))),
            .psql(#"SELECT sum("CarBrands"."id")"#),
            .mysql("SELECT sum(CarBrands.id)")
        )
        check(
            SwifQL.select(Fn.sum(cb.column("id"))),
            .psql(#"SELECT sum("cb"."id")"#),
            .mysql("SELECT sum(cb.id)")
        )
    }

    func testSelectFnStringAgg() {
        check(
            SwifQL.select(Fn.string_agg(CarBrands.column("name"), ", ")),
            .psql(#"SELECT string_agg("CarBrands"."name", ', ')"#),
            .mysql("SELECT string_agg(CarBrands.name, ', ')")
        )
    }

    func testSelectFnRegexpReplace() {
        check(
            SwifQL.select(Fn.regexp_replace("/full/path/to/filename", "^.+/", "")),
            .psql(#"SELECT regexp_replace('/full/path/to/filename', '^.+/', '')"#),
            .mysql("SELECT regexp_replace('/full/path/to/filename', '^.+/', '')")
        )
    }
    
    // MARK: - SELECT with alias in select params
    
    func testSelectWithAliasInSelectParams() {
        check(
            SwifQL.select("hello", =>"aaa").from(|SwifQL.select(CarBrands.column("name")).from(CarBrands.table))| => "aaa",
            .psql(#"SELECT 'hello', "aaa" FROM (SELECT "CarBrands"."name" FROM "CarBrands") as "aaa""#),
            .mysql("SELECT 'hello', aaa FROM (SELECT CarBrands.name FROM CarBrands) as aaa")
        )
    }
    
    static var allTests = [
        ("testPureSelect", testSelect),
        ("testSimpleString", testSelectString),
        ("testSelectInt", testSelectInt),
        ("testSelectDouble", testSelectDouble),
        ("testSelectSeveralSimpleValues", testSelectSeveralSimpleValues),
        ("testSelectColumn_path", testSelectColumn_path),
        ("testSelectColumn_keyPath", testSelectColumn_keyPath),
        ("testSelectColumn_keyPath_alias_simple", testSelectColumn_keyPath_alias_simple),
        ("testSelectColumn_keyPath_alias_keyPath", testSelectColumn_keyPath_alias_keyPath),
        ("testSelectColumnWithTable", testSelectColumnWithTable),
        ("testSelectCarBrands", testSelectCarBrands),
        ("testSelectCarBrandsSeveralFields", testSelectCarBrandsSeveralFields),
        ("testSelectCarBrandsWithAlias", testSelectCarBrandsWithAlias),
        ("testSelectCarBrandsWithAliasSeveralFields", testSelectCarBrandsWithAliasSeveralFields),
        ("testSelectCarBrandsSeveralFieldsMixed", testSelectCarBrandsSeveralFieldsMixed),
        ("testSelectFnAvg", testSelectFnAvg),
        ("testSelectFnBitLength", testSelectFnBitLength),
        ("testSelectFnBtrim", testSelectFnBtrim),
        ("testSelectFnCeil", testSelectFnCeil),
        ("testSelectFnCeiling", testSelectFnCeiling),
        ("testSelectFnCharLength", testSelectFnCharLength),
        ("testSelectFnCharacter_length", testSelectFnCharacter_length),
        ("testSelectFnInitcap", testSelectFnInitcap),
        ("testSelectFnLength", testSelectFnLength),
        ("testSelectFnLower", testSelectFnLower),
        ("testSelectFnLpad", testSelectFnLpad),
        ("testSelectFnLtrim", testSelectFnLtrim),
        ("testSelectFnPosition", testSelectFnPosition),
        ("testSelectFnRepeat", testSelectFnRepeat),
        ("testSelectFnReplace", testSelectFnReplace),
        ("testSelectFnRpad", testSelectFnRpad),
        ("testSelectFnRtrim", testSelectFnRtrim),
        ("testSelectFnStrpos", testSelectFnStrpos),
        ("testSelectFnSubstring", testSelectFnSubstring),
        ("testSelectFnTranslate", testSelectFnTranslate),
        ("testSelectFnLTrim", testSelectFnLTrim),
        ("testSelectFnUpper", testSelectFnUpper),
        ("testSelectFnCount", testSelectFnCount),
        ("testSelectFnDiv", testSelectFnDiv),
        ("testSelectFnExp", testSelectFnExp),
        ("testSelectFnFloor", testSelectFnFloor),
        ("testSelectFnMax", testSelectFnMax),
        ("testSelectFnMin", testSelectFnMin),
        ("testSelectFnMod", testSelectFnMod),
        ("testSelectFnPower", testSelectFnPower),
        ("testSelectFnRandom", testSelectFnRandom),
        ("testSelectFnRound", testSelectFnRound),
        ("testSelectFnSetSeed", testSelectFnSetSeed),
        ("testSelectFnSign", testSelectFnSign),
        ("testSelectFnSqrt", testSelectFnSqrt),
        ("testSelectFnSum", testSelectFnSum),
        ("testSelectFnStringAgg", testSelectFnStringAgg),
        ("testSelectFnRegexpReplace", testSelectFnRegexpReplace),
        ("testSelectWithAliasInSelectParams", testSelectWithAliasInSelectParams)
    ]
}
