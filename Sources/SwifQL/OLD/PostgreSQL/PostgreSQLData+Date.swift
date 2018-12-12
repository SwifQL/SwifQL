//import Foundation
//
//extension Date: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> Date {
//        switch data.storage {
//        case .text(let value):
//            switch data.type {
//            case .timestamp: return try value.parseDate(format:  "yyyy-MM-dd HH:mm:ss")
//            case .date: return try value.parseDate(format:  "yyyy-MM-dd")
//            case .time: return try value.parseDate(format:  "HH:mm:ss")
//            default: throw PostgreSQLError.decode(Date.self, from: data)
//            }
//        case .binary(let value):
//            switch data.type {
//            case .timestamp, .timestamptz:
//                let microseconds = value.as(Int64.self, default: 0).bigEndian
//                let seconds = Double(microseconds) / Double(_microsecondsPerSecond)
//                return Date(timeInterval: seconds, since: _psqlDateStart)
//            case .time, .timetz: throw PostgreSQLError.decode(Date.self, from: data)
//            case .date:
//                let days = value.as(Int32.self, default: 0).bigEndian
//                let seconds = Int64(days) * _secondsInDay
//                return Date(timeInterval: Double(seconds), since: _psqlDateStart)
//            default: throw PostgreSQLError.decode(Date.self, from: data)
//            }
//        case .null: throw PostgreSQLError.decode(Date.self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return PostgreSQLData(.timestamp, binary: Data.of(Int64(self.timeIntervalSince(_psqlDateStart) * Double(_microsecondsPerSecond)).bigEndian))
//    }
//}
//
//// MARK: Private
//
//private let _microsecondsPerSecond: Int64 = 1_000_000
//private let _secondsInDay: Int64 = 24 * 60 * 60
//private let _psqlDateStart = Date(timeIntervalSince1970: 946_684_800) // values are stored as seconds before or after midnight 2000-01-01
//
//private extension String {
//    /// Parses a Date from this string with the supplied date format.
//    func parseDate(format: String) throws -> Date {
//        let formatter = DateFormatter()
//        if contains(".") {
//            formatter.dateFormat = format + ".SSSSSS"
//        } else {
//            formatter.dateFormat = format
//        }
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        guard let date = formatter.date(from: self) else {
//            throw PostgreSQLError(identifier: "date", reason: "Malformed date: \(self)")
//        }
//        return date
//    }
//}
