import XCTest
@testable import SwifQL

final class TableEncoding: SwifQLTestCase {
    func testPure() {
        guard let encodedData = try? JSONEncoder().encode(PureTable()) else {
            XCTFail("Unable to encode PureTable")
            return
        }
        guard let _ = try? JSONDecoder().decode(PureStruct.self, from: encodedData) else {
            XCTFail("Unable to decode PureTable into PureStruct")
            return
        }
    }
    
    func testWithOptionalColumn() {
        #if swift(>=5.4)
        XCTAssertNil(TableWithOptionalColumn().firstName)
        #endif
    }
    
    func testWithKeyPaths() {
        guard let encodedData = try? JSONEncoder().encode(KeyPathTable()) else {
            XCTFail("Unable to encode PureTable")
            return
        }
        guard let _ = try? JSONDecoder().decode(KeyPathStruct.self, from: encodedData) else {
            XCTFail("Unable to decode KeyPathTable into KeyPathStruct")
            return
        }
    }
    
    static var allTests = [
        ("testPure", testPure),
        ("testWithOptionalColumn", testWithOptionalColumn),
        ("testWithKeyPaths", testWithKeyPaths)
    ]
}

fileprivate struct PureStruct: Codable {
    let id: UUID
    let first_name: String
}

fileprivate final class PureTable: Table {
    @Column("id")
    var id: UUID
    
    @Column("first_name")
    var firstName: String

    init () {
        id = UUID()
        firstName = ""
    }
}

fileprivate final class TableWithOptionalColumn: Table {
    @Column("first_name")
    var firstName: String?

    init () {}
}

fileprivate struct KeyPathStruct: Codable {
    let id: UUID
    let firstName: String
}

fileprivate final class KeyPathTable: Table, KeyPathEncodable {
    @Column("id")
    var id: UUID
    
    @Column("first_name")
    var firstName: String

    init () {
        id = UUID()
        firstName = ""
    }
}
