import XCTest
@testable import SwifQL

final class JsonTests: SwifQLTestCase {
    // MARK: - JSON
    
    func testJsonExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        let query = SwifQL.select(Fn.json_extract_path(json, path_elems: ["f4"]))
        let pg = """
        SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')
        """
        let mySQL = """
        SELECT json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    func testJsonExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        let query = SwifQL.select(Fn.json_extract_path_text(json, path_elems: ["f4", "f6"]))
        let pg = """
        SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')
        """
        let mySQL = """
        SELECT json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    func testJsonbExtractPath() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        let query = SwifQL.select(Fn.jsonb_extract_path(json, path_elems: ["f4"]))
        let pg = """
        SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')
        """
        let mySQL = """
        SELECT jsonb_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    func testJsonbExtractPathText() {
        let json = #"{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}"#
        let query = SwifQL.select(Fn.jsonb_extract_path_text(json, path_elems: ["f4", "f6"]))
        let pg = """
        SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')
        """
        let mySQL = """
        SELECT jsonb_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}', 'f4', 'f6')
        """
        checkAllDialects(query, pg: pg, mySQL: mySQL)
    }
    
    static var allTests = [
        ("testJsonExtractPath", testJsonExtractPath),
        ("testJsonExtractPathText", testJsonExtractPathText),
        ("testJsonbExtractPath", testJsonbExtractPath),
        ("testJsonbExtractPathText", testJsonbExtractPathText)
    ]
}
