@testable import SwifQL
import Testing
import Foundation

@Suite("Select Tests")
struct SelectTests: SwifQLTests {
    @Test("Test Select")
    func select() {
        check(SwifQL.select, all: "SELECT")
        check(SwifQL.select(), all: "SELECT ")
    }
    
    @Test("Test Select String")
    func selectString() {
        check(
            SwifQL.select("hello"),
            .psql("SELECT 'hello'"),
            .mysql("SELECT 'hello'")
        )
    }
    
//    @Test("Test Select UUID Array")
//    func selectUUIDArray() {
//        check(
//            SwifQL ||> [PostgresArray(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))],
//            .psql("SELECT 'hello'"),
//            .mysql("SELECT 'hello'")
//        )
//    }
    
    @Test("Test Select Int")
    func selectInt() {
        check(
            SwifQL.select(1),
            .psql("SELECT 1"),
            .mysql("SELECT 1")
        )
    }
    
    @Test("Test Select Double")
    func selectDouble() {
        check(
            SwifQL.select(1.234),
            .psql("SELECT 1.234"),
            .mysql("SELECT 1.234")
        )
    }

    @Test("Test Select Date")
    func selectData() {
        let base64 = "Aa+/0w=="
        let data = Data(base64Encoded: base64)!
        check(
            SwifQL.select(data),
            .psql("SELECT decode('\(base64)', 'base64')")
        )
    }
    
    @Test("Test Select Several Simple Values")
    func selectSeveralSimpleValues() {
        check(
            SwifQL.select("hello", 1, 1.234),
            .psql("SELECT 'hello', 1, 1.234"),
            .mysql("SELECT 'hello', 1, 1.234")
        )
    }
    
    @Test("Test Select Column Path")
    func selectColumn_path() {
        check(
            SwifQL.select(Path.Column("id")),
            .psql(#"SELECT "id""#),
            .mysql("SELECT id")
        )
    }
    
    @Test("Test Select Column KeyPath")
    func selectColumn_keyPath() {
        check(
            SwifQL.select(\CarBrands.$id),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    @Test("Test Select Column KeyPath Alias Simple")
    func selectColumn_keyPath_alias_simple() {
        check(
            SwifQL.select(\CarBrands.$id => "ident"),
            .psql(#"SELECT "CarBrands"."id" as "ident""#),
            .mysql("SELECT CarBrands.id as ident")
        )
    }
    
    @Test("Test Select Column KeyPath Alias KeyPath")
    func selectColumn_keyPath_alias_keyPath() {
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
    
    @Test("Test Select Column With Table")
    func selectColumnWithTable() {
        check(
            SwifQL.select(Path.Table("CarBrands").column("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    @Test("Test Select Column With Table And Schema")
    func selectColumnWithTableAndSchema() {
        check(
            SwifQL.select(Path.Schema("test").table("CarBrands").column("id")),
            .psql(#"SELECT "test"."CarBrands"."id""#),
            .mysql("SELECT test.CarBrands.id")
        )
    }
    
    @Test("Test Select Column Without Table")
    func selectColumnWithoutTable() {
        check(
            SwifQL.select(Path.Column("id")),
            .psql(#"SELECT "id""#),
            .mysql("SELECT id")
        )
    }
    
    @Test("Test Generic Selector All")
    func genericSelector_all() {
        check(
            CarBrands.select,
            .psql(#"SELECT "CarBrands".* FROM "CarBrands""#),
            .mysql("SELECT CarBrands.* FROM CarBrands")
        )
    }
    
    @Test("Select CarBrands")
    func selectCarBrands() {
        check(
            SwifQL.select(CarBrands.column("id")),
            .psql(#"SELECT "CarBrands"."id""#),
            .mysql("SELECT CarBrands.id")
        )
    }
    
    @Test("Select Schemable CarBrands")
    func selectSchemableCarBrands() {
        check(
            SwifQL.select(SchemableCarBrands.column("id")),
            .psql(#"SELECT "public"."CarBrands"."id""#),
            .mysql("SELECT public.CarBrands.id")
        )
    }
    
    @Test("Select CarBrands in Customer Schema")
    func selectCarBrandsInCustomSchema() {
        let cb = Schema<CarBrands>("hello")
        check(
            SwifQL.select(cb.column("id")),
            .psql(#"SELECT "hello"."CarBrands"."id""#),
            .mysql("SELECT hello.CarBrands.id")
        )
    }
    
    @Test("Select CarBrands Several Fields")
    func selectCarBrandsSeveralFields() {
        check(
            SwifQL.select(CarBrands.column("id"), CarBrands.column("name")),
            .psql(#"SELECT "CarBrands"."id", "CarBrands"."name""#),
            .mysql("SELECT CarBrands.id, CarBrands.name")
        )
    }
    
    @Test("Select CarBrands With Alias")
    func selectCarBrandsWithAlias() {
        check(
            SwifQL.select(cb.column("id")),
            .psql(#"SELECT "cb"."id""#),
            .mysql("SELECT cb.id")
        )
    }
    
    @Test("Select CarBrands With Alias Several Fields")
    func selectCarBrandsWithAliasSeveralFields() {
        check(
            SwifQL.select(cb.column("id"), cb.column("name")),
            .psql(#"SELECT "cb"."id", "cb"."name""#),
            .mysql("SELECT cb.id, cb.name")
        )
    }
    
    @Test("Select CarBrands Several Fields Mixed")
    func selectCarBrandsSeveralFieldsMixed() {
        check(
            SwifQL.select(CarBrands.column("id"), cb.column("name"), CarBrands.column("createdAt")),
            .psql(#"SELECT "CarBrands"."id", "cb"."name", "CarBrands"."createdAt""#),
            .mysql("SELECT CarBrands.id, cb.name, CarBrands.createdAt")
        )
    }
    
    //MARK: PostgreSQL Functions
    
    @Test("Select abs")
    func selectFnAbs() {
        check(
            SwifQL.select(Fn.abs(1)),
            .psql("SELECT abs(1)"),
            .mysql("SELECT abs(1)")
        )
    }
    
    @Test("Select avg")
    func selectFnAvg() {
        check(
            SwifQL.select(Fn.avg(1)),
            .psql("SELECT avg(1)"),
            .mysql("SELECT avg(1)")
        )
    }
    
    @Test("Select bit_length")
    func selectFnBitLength() {
        check(
            SwifQL.select(Fn.bit_length("hello")),
            .psql("SELECT bit_length('hello')"),
            .mysql("SELECT bit_length('hello')")
        )
    }
    
    @Test("Select btrim")
    func selectFnBtrim() {
        check(
            SwifQL.select(Fn.btrim("hello", "ll")),
            .psql("SELECT btrim('hello', 'll')"),
            .mysql("SELECT btrim('hello', 'll')")
        )
    }
    
    @Test("Select ceil")
    func selectFnCeil() {
        check(
            SwifQL.select(Fn.ceil(1.5)),
            .psql("SELECT ceil(1.5)"),
            .mysql("SELECT ceil(1.5)")
        )
    }
    
    @Test("Select ceiling")
    func selectFnCeiling() {
        check(
            SwifQL.select(Fn.ceiling(1.5)),
            .psql("SELECT ceiling(1.5)"),
            .mysql("SELECT ceiling(1.5)")
        )
    }
    
    @Test("Select char_length")
    func selectFnCharLength() {
        check(
            SwifQL.select(Fn.char_length("hello")),
            .psql("SELECT char_length('hello')"),
            .mysql("SELECT char_length('hello')")
        )
    }
    
    @Test("Select character_length")
    func selectFnCharacter_length() {
        check(
            SwifQL.select(Fn.character_length("hello")),
            .psql("SELECT character_length('hello')"),
            .mysql("SELECT character_length('hello')")
        )
    }
    
    @Test("Select initcap")
    func selectFnInitcap() {
        check(
            SwifQL.select(Fn.initcap("hello")),
            .psql("SELECT initcap('hello')"),
            .mysql("SELECT initcap('hello')")
        )
    }
    
    @Test("Select length")
    func selectFnLength() {
        check(
            SwifQL.select(Fn.length("hello")),
            .psql("SELECT length('hello')"),
            .mysql("SELECT length('hello')")
        )
    }
    
    @Test("Select lower")
    func selectFnLower() {
        check(
            SwifQL.select(Fn.lower("hello")),
            .psql("SELECT lower('hello')"),
            .mysql("SELECT lower('hello')")
        )
    }
    
    @Test("Select lpad")
    func selectFnLpad() {
        check(
            SwifQL.select(Fn.lpad("hello", 3, "lo")),
            .psql("SELECT lpad('hello', 3, 'lo')"),
            .mysql("SELECT lpad('hello', 3, 'lo')")
        )
    }
    
    @Test("Select ltrim")
    func selectFnLtrim() {
        check(
            SwifQL.select(Fn.ltrim("hello", "he")),
            .psql("SELECT ltrim('hello', 'he')"),
            .mysql("SELECT ltrim('hello', 'he')")
        )
    }
    
    @Test("Select position")
    func selectFnPosition() {
        check(
            SwifQL.select(Fn.position("el", in: "hello")),
            .psql("SELECT position('el' IN 'hello')"),
            .mysql("SELECT position('el' IN 'hello')")
        )
    }
    
    @Test("Select repeat")
    func selectFnRepeat() {
        check(
            SwifQL.select(Fn.repeat("hello", 2)),
            .psql("SELECT repeat('hello', 2)"),
            .mysql("SELECT repeat('hello', 2)")
        )
    }
    
    @Test("Select replace")
    func selectFnReplace() {
        check(
            SwifQL.select(Fn.replace("hello", "el", "ol")),
            .psql("SELECT replace('hello', 'el', 'ol')"),
            .mysql("SELECT replace('hello', 'el', 'ol')")
        )
    }
    
    @Test("Select rpad")
    func selectFnRpad() {
        check(
            SwifQL.select(Fn.rpad("hello", 2, "ho")),
            .psql("SELECT rpad('hello', 2, 'ho')"),
            .mysql("SELECT rpad('hello', 2, 'ho')")
        )
    }
    
    @Test("Select rtrim")
    func selectFnRtrim() {
        check(
            SwifQL.select(Fn.rtrim(" hello ", " ")),
            .psql("SELECT rtrim(' hello ', ' ')"),
            .mysql("SELECT rtrim(' hello ', ' ')")
        )
    }
    
    @Test("Select strpos")
    func selectFnStrpos() {
        check(
            SwifQL.select(Fn.strpos("hello", "ll")),
            .psql("SELECT strpos('hello', 'll')"),
            .mysql("SELECT strpos('hello', 'll')")
        )
    }
    
    @Test("Select substring")
    func selectFnSubstring() {
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
    
    @Test("Select translate")
    func selectFnTranslate() {
        check(
            SwifQL.select(Fn.translate("hola", "hola", "hello")),
            .psql("SELECT translate('hola', 'hola', 'hello')"),
            .mysql("SELECT translate('hola', 'hola', 'hello')")
        )
    }
    
    @Test("Select ltrim")
    func selectFnLTrim() {
        check(
            SwifQL.select(Fn.ltrim("hello", "he")),
            .psql("SELECT ltrim('hello', 'he')"),
            .mysql("SELECT ltrim('hello', 'he')")
        )
    }
    
    @Test("Select upper")
    func selectFnUpper() {
        check(
            SwifQL.select(Fn.upper("hello")),
            .psql("SELECT upper('hello')"),
            .mysql("SELECT upper('hello')")
        )
    }
    
    @Test("Select count")
    func selectFnCount() {
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
    
    @Test("Select div")
    func selectFnDiv() {
        check(
            SwifQL.select(Fn.div(12, 4)),
            .psql("SELECT div(12, 4)"),
            .mysql("SELECT div(12, 4)")
        )
    }
    
    @Test("Select exp")
    func selectFnExp() {
        check(
            SwifQL.select(Fn.exp(12, 4)),
            .psql("SELECT exp(12, 4)"),
            .mysql("SELECT exp(12, 4)")
        )
    }
    
    @Test("Select floor")
    func selectFnFloor() {
        check(
            SwifQL.select(Fn.floor(12)),
            .psql("SELECT floor(12)"),
            .mysql("SELECT floor(12)")
        )
    }
    
    @Test("Select max")
    func selectFnMax() {
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
    
    @Test("Select min")
    func selectFnMin() {
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
    
    @Test("Select mod")
    func selectFnMod() {
        check(
            SwifQL.select(Fn.mod(12, 4)),
            .psql("SELECT mod(12, 4)"),
            .mysql("SELECT mod(12, 4)")
        )
    }
    
    @Test("Select power")
    func selectFnPower() {
        check(
            SwifQL.select(Fn.power(12, 4)),
            .psql("SELECT power(12, 4)"),
            .mysql("SELECT power(12, 4)")
        )
    }
    
    @Test("Select random")
    func selectFnRandom() {
        check(
            SwifQL.select(Fn.random()),
            .psql("SELECT random()"),
            .mysql("SELECT random()")
        )
    }
    
    @Test("Select round")
    func selectFnRound() {
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
    
    @Test("Select setseed")
    func selectFnSetSeed() {
        check(
            SwifQL.select(Fn.setseed(12)),
            .psql("SELECT setseed(12)"),
            .mysql("SELECT setseed(12)")
        )
    }
    
    @Test("Select sign")
    func selectFnSign() {
        check(
            SwifQL.select(Fn.sign(12)),
            .psql("SELECT sign(12)"),
            .mysql("SELECT sign(12)")
        )
    }
    
    @Test("Select sqrt")
    func selectFnSqrt() {
        check(
            SwifQL.select(Fn.sqrt(16)),
            .psql("SELECT sqrt(16)"),
            .mysql("SELECT sqrt(16)")
        )
    }
    
    @Test("Select sum")
    func selectFnSum() {
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

    @Test("Select string_agg")
    func selectFnStringAgg() {
        check(
            SwifQL.select(Fn.string_agg(CarBrands.column("name"), ", ")),
            .psql(#"SELECT string_agg("CarBrands"."name", ', ')"#),
            .mysql("SELECT string_agg(CarBrands.name, ', ')")
        )
    }

    @Test("Select regexp_replace")
    func selectFnRegexpReplace() {
        check(
            SwifQL.select(Fn.regexp_replace("/full/path/to/filename", "^.+/", "")),
            .psql(#"SELECT regexp_replace('/full/path/to/filename', '^.+/', '')"#),
            .mysql("SELECT regexp_replace('/full/path/to/filename', '^.+/', '')")
        )
    }
    
    // MARK: - SELECT with alias in select params
    
    @Test("Select With Alias In Select Params")
    func selectWithAliasInSelectParams() {
        check(
            SwifQL.select("hello", =>"aaa").from(|SwifQL.select(CarBrands.column("name")).from(CarBrands.table))| => "aaa",
            .psql(#"SELECT 'hello', "aaa" FROM (SELECT "CarBrands"."name" FROM "CarBrands") as "aaa""#),
            .mysql("SELECT 'hello', aaa FROM (SELECT CarBrands.name FROM CarBrands) as aaa")
        )
    }
}
