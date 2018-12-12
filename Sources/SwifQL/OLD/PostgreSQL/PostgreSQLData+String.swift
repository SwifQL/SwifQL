//import Foundation
//
//extension String: PostgreSQLDataConvertible {
//    /// See `PostgreSQLDataConvertible`.
//    public static func convertFromPostgreSQLData(_ data: PostgreSQLData) throws -> String {
//        switch data.storage {
//        case .text(let string): return string
//        case .binary(let value):
//            switch data.type {
//            case .uuid: return try UUID.convertFromPostgreSQLData(data).uuidString
//            case .numeric:
//                /// Represents the meta information preceeding a numeric value.
//                /// - note: all values must be accessed adding `.bigEndian`
//                struct PostgreSQLNumericMetadata {
//                    /// The number of digits after this metadata
//                    var ndigits: Int16
//                    /// How many of the digits are before the decimal point (always add 1)
//                    var weight: Int16
//                    /// If 1, this number is negative. Otherwise, positive.
//                    var sign: Int16
//                    /// The number of sig digits after the decimal place (get rid of trailing 0s)
//                    var dscale: Int16
//                }
//                
//                /// create mutable value since we will be using `.extract` which advances the buffer's view
//                var value = value
//                
//                /// grab the numeric metadata from the beginning of the array
//                let metadata = value.extract(PostgreSQLNumericMetadata.self)
//                
//                var integer = ""
//                var fractional = ""
//                for offset in 0..<metadata.ndigits.bigEndian {
//                    /// extract current char and advance memory
//                    let char = value.as(Int16.self, default: 0).bigEndian
//                    if value.count <= 2 {
//                        value = .init()
//                    } else {
//                        value = value.advanced(by: 2)
//                    }
//                    
//                    /// conver the current char to its string form
//                    let string: String
//                    if char == 0 {
//                        /// 0 means 4 zeros
//                        string = "0000"
//                    } else {
//                        string = char.description
//                    }
//                    
//                    /// depending on our offset, append the string to before or after the decimal point
//                    if offset < metadata.weight.bigEndian + 1 {
//                        integer += string
//                    } else {
//                        // Leading zeros matter with fractional
//                        fractional += fractional.count == 0 ? String(repeating: "0", count: 4 - string.count) + string : string
//                    }
//                }
//                
//                if fractional.count > metadata.dscale.bigEndian {
//                    /// use the dscale to remove extraneous zeroes at the end of the fractional part
//                    let lastSignificantIndex = fractional.index(fractional.startIndex, offsetBy: Int(metadata.dscale.bigEndian))
//                    fractional = String(fractional[..<lastSignificantIndex])
//                }
//                
//                /// determine whether fraction is empty and dynamically add `.`
//                let numeric: String
//                if fractional != "" {
//                    numeric = integer + "." + fractional
//                } else {
//                    numeric = integer
//                }
//                
//                /// use sign to determine adding a leading `-`
//                if metadata.sign.bigEndian == 1 {
//                    return "-" + numeric
//                } else {
//                    return numeric
//                }
//            default:
//                // always try to parse a UTF-8 string
//                // this allows for ENUM and other UNKNOWN types to be parsed
//                guard let string = String(data: value, encoding: .utf8) else {
//                    throw PostgreSQLError.decode(self, from: data)
//                }
//                return string
//            }
//        case .null: throw PostgreSQLError.decode(self, from: data)
//        }
//    }
//
//    /// See `PostgreSQLDataConvertible`.
//    public func convertToPostgreSQLData() throws -> PostgreSQLData {
//        return PostgreSQLData(.text, binary: Data(utf8))
//    }
//}
//
//
//extension Data {
//    /// Convert the row's data into a string, throwing if invalid encoding.
//    internal func makeString(encoding: String.Encoding = .utf8) throws -> String {
//        guard let string = String(data: self, encoding: encoding) else {
//            throw PostgreSQLError(identifier: "utf8String", reason: "Unexpected non-UTF8 string: \(hexDebug).")
//        }
//
//        return string
//    }
//}
