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
