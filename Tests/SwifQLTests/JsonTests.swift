import XCTest
@testable import SwifQL

final class JsonTests: SwifQLTestCase {
    // MARK: - JSON
    
    func testJsonExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.json_extract_path(json, path_elems: ["f4"])),
            .psql(#"SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#),
            .mysql(#"SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#)
        )
    }
    
    func testJsonExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.json_extract_path_text(json, path_elems: ["f4", "f6"])),
            .psql(#"SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#),
            .mysql(#"SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#)
        )
    }
    
    func testJsonbExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.jsonb_extract_path(json, path_elems: ["f4"])),
            .psql(#"SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#),
            .mysql(#"SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')"#)
        )
    }
    
    func testJsonbExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        check(
            SwifQL.select(Fn.jsonb_extract_path_text(json, path_elems: ["f4", "f6"])),
            .psql(#"SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#),
            .mysql(#"SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')"#)
        )
    }
    
    static var allTests = [
        ("testJsonExtractPath", testJsonExtractPath),
        ("testJsonExtractPathText", testJsonExtractPathText),
        ("testJsonbExtractPath", testJsonbExtractPath),
        ("testJsonbExtractPathText", testJsonbExtractPathText)
    ]
}
