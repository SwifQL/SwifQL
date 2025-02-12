@testable import SwifQL
import Testing
import XCTest

@Suite("Table Encoding Tests")
struct TableEncodingTests: SwifQLTests {
    @Test("Test Pure")
    func pure() {
        guard let encodedData = try? JSONEncoder().encode(PureTable()) else {
            XCTFail("Unable to encode PureTable")
            return
        }
        guard let _ = try? JSONDecoder().decode(PureStruct.self, from: encodedData) else {
            XCTFail("Unable to decode PureTable into PureStruct")
            return
        }
    }
    
    @Test("Test With Optional Column")
    func withOptionalColumn() {
        #if swift(>=5.4)
        XCTAssertNil(TableWithOptionalColumn().firstName)
        #endif
    }
    
    @Test("Test With KeyPaths")
    func withKeyPaths() {
        guard let encodedData = try? JSONEncoder().encode(KeyPathTable()) else {
            XCTFail("Unable to encode PureTable")
            return
        }
        guard let _ = try? JSONDecoder().decode(KeyPathStruct.self, from: encodedData) else {
            XCTFail("Unable to decode KeyPathTable into KeyPathStruct")
            return
        }
    }
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
