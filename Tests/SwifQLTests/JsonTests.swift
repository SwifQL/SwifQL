@testable import SwifQL
import Testing
import XCTest

@Suite("Json Tests")
struct JsonTests: SwifQLTests {
    // MARK: - JSON
    
    @Test("Test Json Extract Path")
    func jsonExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.json_extract_path(json, path_elems: ["f4"])),
            .psql(#"SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#),
            .mysql(#"SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#)
        )
    }
    
    @Test("Test Json Extract Path Text")
    func jsonExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.json_extract_path_text(json, path_elems: ["f4", "f6"])),
            .psql(#"SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#),
            .mysql(#"SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#)
        )
    }
    
    @Test("Test Jsonb Extract Path")
    func jsonbExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.jsonb_extract_path(json, path_elems: ["f4"])),
            .psql(#"SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#),
            .mysql(#"SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#)
        )
    }
    
    @Test("Test Jsonb Extract Path Text")
    func jsonbExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.jsonb_extract_path_text(json, path_elems: ["f4", "f6"])),
            .psql(#"SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#),
            .mysql(#"SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#)
        )
    }
}
