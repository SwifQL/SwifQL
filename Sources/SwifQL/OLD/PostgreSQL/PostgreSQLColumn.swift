///// Represents a PostgreSQL column.
//public struct PostgreSQLColumn: Hashable, Equatable {
//    /// The table this column belongs to.
//    public var tableOID: UInt32
//
//    /// The column's name.
//    public var name: String
//
//    /// Creates a new `PostgreSQLColumn`.
//    public init(tableOID: UInt32 = 0, name: String) {
//        self.tableOID = tableOID
//        self.name = name
//    }
//}
//
//extension PostgreSQLColumn: CustomStringConvertible {
//    /// See `CustomStringConvertible`.
//    public var description: String {
//        switch tableOID {
//        case 0: return name
//        default: return tableOID.description + "." + name
//        }
//    }
//}
//
//extension Dictionary where Key == PostgreSQLColumn {
//    /// Accesses the _first_ value from this dictionary with a matching field name.
//    public func firstValue(tableOID: UInt32 = 0, name: String) -> Value? {
//        for (column, data) in self {
//            if (tableOID == 0 || column.tableOID == 0 || column.tableOID == tableOID) && column.name == name {
//                return data
//            }
//        }
//        return nil
//    }
//}
