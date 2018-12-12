//import SQL
//
///// PostgreSQL specific `SQLDataType`.
//public struct PostgreSQLDataType: SQLDataType, Equatable {
//    /// See `Equatable`.
//    public static func == (lhs: PostgreSQLDataType, rhs: PostgreSQLDataType) -> Bool {
//        // FIXME: more performant equatable is possible
//        var binds: [Encodable] = []
//        return lhs.serialize(&binds) == rhs.serialize(&binds)
//    }
//    
//    /// See `SQLDataType`.
//    public static func dataType(appropriateFor type: Any.Type) -> PostgreSQLDataType? {
//        guard let type = type as? PostgreSQLDataTypeStaticRepresentable.Type else {
//            return .jsonb
//        }
//        return type.postgreSQLDataType
//    }
//    
//    /// signed eight-byte integer
//    public static var int8: PostgreSQLDataType {
//        return .bigint
//    }
//    
//    /// signed eight-byte integer
//    public static var bigint: PostgreSQLDataType {
//        return .init(.bigint)
//    }
//    
//    /// autoincrementing eight-byte integer
//    public static var serial8: PostgreSQLDataType {
//        return .bigserial
//    }
//    
//    /// autoincrementing eight-byte integer
//    public static var bigserial: PostgreSQLDataType {
//        return .init(.bigserial)
//    }
//    
//    /// fixed-length bit string
//    public static var bit: PostgreSQLDataType {
//        return .init(.bit(nil))
//    }
//    
//    /// fixed-length bit string
//    public static func bit(_ n: Int) -> PostgreSQLDataType {
//        return .init(.bit(n))
//    }
//    
//    /// variable-length bit string
//    public static var varbit: PostgreSQLDataType {
//        return .init(.varbit(nil))
//    }
//    
//    /// variable-length bit string
//    public static func varbit(_ n: Int) -> PostgreSQLDataType {
//        return .init(.varbit(n))
//    }
//    
//    /// logical Boolean (true/false)
//    public static var bool: PostgreSQLDataType {
//        return .boolean
//    }
//    
//    /// logical Boolean (true/false)
//    public static var boolean: PostgreSQLDataType {
//        return .init(.boolean)
//    }
//    
//    /// rectangular box on a plane
//    public static var box: PostgreSQLDataType {
//        return .init(.box)
//    }
//    
//    /// binary data (“byte array”)
//    public static var bytea: PostgreSQLDataType {
//        return .init(.bytea)
//    }
//    
//    /// fixed-length character string
//    public static var char: PostgreSQLDataType {
//        return .init(.char(nil))
//    }
//    
//    /// fixed-length character string
//    public static func char(_ n: Int) -> PostgreSQLDataType {
//        return .init(.char(n))
//    }
//    
//    /// variable-length character string
//    public static var varchar: PostgreSQLDataType {
//        return .init(.varchar(nil))
//    }
//    
//    /// variable-length character string
//    public static func varchar(_ n: Int) -> PostgreSQLDataType {
//        return .init(.varchar(n))
//    }
//    
//    /// IPv4 or IPv6 network address
//    public static var cidr: PostgreSQLDataType {
//        return .init(.cidr)
//    }
//    
//    /// circle on a plane
//    public static var circle: PostgreSQLDataType {
//        return .init(.circle)
//    }
//    
//    /// calendar date (year, month, day)
//    public static var date: PostgreSQLDataType {
//        return .init(.date)
//    }
//    
//    /// floating-point number (8 bytes)
//    public static var float8: PostgreSQLDataType {
//        return .doublePrecision
//    }
//    
//    /// floating-point number (8 bytes)
//    public static var doublePrecision: PostgreSQLDataType {
//        return .init(.doublePrecision)
//    }
//    
//    /// IPv4 or IPv6 host address
//    public static var inet: PostgreSQLDataType {
//        return .init(.inet)
//    }
//    
//    /// signed four-byte integer
//    public static var int: PostgreSQLDataType {
//        return .integer
//    }
//    
//    /// signed four-byte integer
//    public static var int4: PostgreSQLDataType {
//        return .integer
//    }
//    
//    /// signed four-byte integer
//    public static var integer: PostgreSQLDataType {
//        return .init(.integer)
//    }
//    
//    /// time span
//    public static var interval: PostgreSQLDataType {
//        return .init(.interval)
//    }
//    
//    /// textual JSON data
//    public static var json: PostgreSQLDataType {
//        return .init(.json)
//    }
//    
//    /// binary JSON data, decomposed
//    public static var jsonb: PostgreSQLDataType {
//        return .init(.jsonb)
//    }
//    
//    /// infinite line on a plane
//    public static var line: PostgreSQLDataType {
//        return .init(.line)
//    }
//    
//    /// line segment on a plane
//    public static var lseg: PostgreSQLDataType {
//        return .init(.lseg)
//    }
//    
//    /// MAC (Media Access Control) address
//    public static var macaddr: PostgreSQLDataType {
//        return .init(.macaddr)
//    }
//    
//    /// MAC (Media Access Control) address (EUI-64 format)
//    public static var macaddr8: PostgreSQLDataType {
//        return .init(.macaddr8)
//    }
//    
//    /// currency amount
//    public static var money: PostgreSQLDataType {
//        return .init(.money)
//    }
//    
//    /// exact numeric of selectable precision
//    public static var decimal: PostgreSQLDataType {
//        return .init(.numeric(nil))
//    }
//    
//    /// exact numeric of selectable precision
//    public static func decimal(_ p: Int, _ s: Int) -> PostgreSQLDataType {
//        return .init(.numeric((p, s)))
//    }
//    
//    /// exact numeric of selectable precision
//    public static func numeric(_ p: Int, _ s: Int) -> PostgreSQLDataType {
//        return .init(.numeric((p, s)))
//    }
//    
//    /// exact numeric of selectable precision
//    public static var numeric: PostgreSQLDataType {
//        return .init(.numeric(nil))
//    }
//    
//    /// geometric path on a plane
//    public static var path: PostgreSQLDataType {
//        return .init(.path)
//    }
//    
//    /// PostgreSQL Log Sequence Number
//    public static var pgLSN: PostgreSQLDataType {
//        return .init(.pgLSN)
//    }
//    
//    /// geometric point on a plane
//    public static var point: PostgreSQLDataType {
//        return .init(.point)
//    }
//    
//    /// closed geometric path on a plane
//    public static var polygon: PostgreSQLDataType {
//        return .init(.polygon)
//    }
//    
//    /// single precision floating-point number (4 bytes)
//    public static var float4: PostgreSQLDataType {
//        return .real
//    }
//    
//    /// single precision floating-point number (4 bytes)
//    public static var real: PostgreSQLDataType {
//        return .init(.real)
//    }
//    
//    /// signed two-byte integer
//    public static var int2: PostgreSQLDataType {
//        return .smallint
//    }
//    
//    /// signed two-byte integer
//    public static var smallint: PostgreSQLDataType {
//        return .init(.smallint)
//    }
//    
//    /// autoincrementing two-byte integer
//    public static var serial2: PostgreSQLDataType {
//        return .smallserial
//    }
//    
//    /// autoincrementing two-byte integer
//    public static var smallserial: PostgreSQLDataType {
//        return .init(.smallserial)
//    }
//    
//    /// autoincrementing four-byte integer
//    public static var serial4: PostgreSQLDataType {
//        return .serial
//    }
//    
//    /// autoincrementing four-byte integer
//    public static var serial: PostgreSQLDataType {
//        return .init(.serial)
//    }
//    
//    /// variable-length character string
//    public static var text: PostgreSQLDataType {
//        return .init(.text)
//    }
//    
//    /// time of day (no time zone)
//    public static var time: PostgreSQLDataType {
//        return .init(.time(nil))
//    }
//    
//    /// time of day (no time zone)
//    public static func time(_ n: Int) -> PostgreSQLDataType {
//        return .init(.time(n))
//    }
//    
//    /// time of day, including time zone
//    public static var timetz: PostgreSQLDataType {
//        return .init(.timetz(nil))
//    }
//    
//    /// time of day, including time zone
//    public static func timetz(_ n: Int) -> PostgreSQLDataType {
//        return .init(.timetz(n))
//    }
//    
//    /// date and time (no time zone)
//    public static var timestamp: PostgreSQLDataType {
//        return .init(.timestamp(nil))
//    }
//    
//    /// date and time (no time zone)
//    public static func timestamp(_ n: Int) -> PostgreSQLDataType {
//        return .init(.timestamp(n))
//    }
//    
//    /// date and time, including time zone
//    public static var timestamptz: PostgreSQLDataType {
//        return .init(.timestamptz(nil))
//    }
//    
//    /// date and time, including time zone
//    public static func timestamptz(_ n: Int) -> PostgreSQLDataType {
//        return .init(.timestamptz(n))
//    }
//    
//    /// text search query
//    public static var tsquery: PostgreSQLDataType {
//        return .init(.tsquery)
//    }
//    
//    /// text search document
//    public static var tsvector: PostgreSQLDataType {
//        return .init(.tsvector)
//    }
//    
//    /// user-level transaction ID snapshot
//    public static var txidSnapshot: PostgreSQLDataType {
//        return .init(.txidSnapshot)
//    }
//    
//    /// universally unique identifier
//    public static var uuid: PostgreSQLDataType {
//        return .init(.uuid)
//    }
//    
//    /// XML data
//    public static var xml: PostgreSQLDataType {
//        return .init(.xml)
//    }
//    
//    /// User-defined type
//    public static func custom(_ name: String) -> PostgreSQLDataType {
//        return .init(.custom(name))
//    }
//    
//    /// Creates an array type from a `PostgreSQLDataType`.
//    public static func array(_ dataType: PostgreSQLDataType) -> PostgreSQLDataType {
//        return .init(dataType.primitive, isArray: true)
//    }
//    
//    let primitive: Primitive
//    let isArray: Bool
//    
//    private init(_ primitive: Primitive, isArray: Bool = false) {
//        self.primitive = primitive
//        self.isArray = isArray
//    }
//    
//    enum Primitive {
//        /// signed eight-byte integer
//        case bigint
//        
//        /// autoincrementing eight-byte integer
//        case bigserial
//        
//        /// fixed-length bit string
//        case bit(Int?)
//        
//        /// variable-length bit string
//        case varbit(Int?)
//        
//        /// logical Boolean (true/false)
//        case boolean
//        
//        /// rectangular box on a plane
//        case box
//        
//        /// binary data (“byte array”)
//        case bytea
//        
//        /// fixed-length character string
//        case char(Int?)
//        
//        /// variable-length character string
//        case varchar(Int?)
//        
//        /// IPv4 or IPv6 network address
//        case cidr
//        
//        /// circle on a plane
//        case circle
//        
//        /// calendar date (year, month, day)
//        case date
//        
//        /// floating-point number (8 bytes)
//        case doublePrecision
//        
//        /// IPv4 or IPv6 host address
//        case inet
//        
//        /// signed four-byte integer
//        case integer
//        
//        /// time span
//        case interval
//        
//        /// textual JSON data
//        case json
//        
//        /// binary JSON data, decomposed
//        case jsonb
//        
//        /// infinite line on a plane
//        case line
//        
//        /// line segment on a plane
//        case lseg
//        
//        /// MAC (Media Access Control) address
//        case macaddr
//        
//        /// MAC (Media Access Control) address (EUI-64 format)
//        case macaddr8
//        
//        /// currency amount
//        case money
//        
//        /// exact numeric of selectable precision
//        case numeric((Int, Int)?)
//        
//        /// geometric path on a plane
//        case path
//        
//        /// PostgreSQL Log Sequence Number
//        case pgLSN
//        
//        /// geometric point on a plane
//        case point
//        
//        /// closed geometric path on a plane
//        case polygon
//        
//        /// single precision floating-point number (4 bytes)
//        case real
//        
//        /// signed two-byte integer
//        case smallint
//        
//        /// autoincrementing two-byte integer
//        case smallserial
//        
//        /// autoincrementing four-byte integer
//        case serial
//        
//        /// variable-length character string
//        case text
//        
//        /// time of day (no time zone)
//        case time(Int?)
//        
//        /// time of day, including time zone
//        case timetz(Int?)
//        
//        /// date and time (no time zone)
//        case timestamp(Int?)
//        
//        /// date and time, including time zone
//        case timestamptz(Int?)
//        
//        /// text search query
//        case tsquery
//        
//        /// text search document
//        case tsvector
//        
//        /// user-level transaction ID snapshot
//        case txidSnapshot
//        
//        /// universally unique identifier
//        case uuid
//        
//        /// XML data
//        case xml
//        
//        /// User-defined type
//        case custom(String)
//        
//        /// See `SQLSerializable`.
//        public func serialize(_ binds: inout [Encodable]) -> String {
//            switch self {
//            case .bigint: return "BIGINT"
//            case .bigserial: return "BIGSERIAL"
//            case .varbit(let n):
//                if let n = n {
//                    return "VARBIT(" + n.description + ")"
//                } else {
//                    return "VARBIT"
//                }
//            case .varchar(let n):
//                if let n = n {
//                    return "VARCHAR(" + n.description + ")"
//                } else {
//                    return "VARCHAR"
//                }
//            case .bit(let n):
//                if let n = n {
//                    return "BIT(" + n.description + ")"
//                } else {
//                    return "BIT"
//                }
//            case .boolean: return "BOOLEAN"
//            case .box: return "BOX"
//            case .bytea: return "BYTEA"
//            case .char(let n):
//                if let n = n {
//                    return "CHAR(" + n.description + ")"
//                } else {
//                    return "CHAR"
//                }
//            case .cidr: return "CIDR"
//            case .circle: return "CIRCLE"
//            case .date: return "DATE"
//            case .doublePrecision: return "DOUBLE PRECISION"
//            case .inet: return "INET"
//            case .integer: return "INTEGER"
//            case .interval: return "INTEVERAL"
//            case .json: return "JSON"
//            case .jsonb: return "JSONB"
//            case .line: return "LINE"
//            case .lseg: return "LSEG"
//            case .macaddr: return "MACADDR"
//            case .macaddr8: return "MACADDER8"
//            case .money: return "MONEY"
//            case .numeric(let sp):
//                if let sp = sp {
//                    return "NUMERIC(" + sp.0.description + ", " + sp.1.description + ")"
//                } else {
//                    return "NUMERIC"
//                }
//            case .path: return "PATH"
//            case .pgLSN: return "PG_LSN"
//            case .point: return "POINT"
//            case .polygon: return "POLYGON"
//            case .real: return "REAL"
//            case .smallint: return "SMALLINT"
//            case .smallserial: return "SMALLSERIAL"
//            case .serial: return "SERIAL"
//            case .text: return "TEXT"
//            case .time(let p):
//                if let p = p {
//                    return "TIME(" + p.description + ")"
//                } else {
//                    return "TIME"
//                }
//            case .timetz(let p):
//                if let p = p {
//                    return "TIMETZ(" + p.description + ")"
//                } else {
//                    return "TIMETZ"
//                }
//            case .timestamp(let p):
//                if let p = p {
//                    return "TIMESTAMP(" + p.description + ")"
//                } else {
//                    return "TIMESTAMP"
//                }
//            case .timestamptz(let p):
//                if let p = p {
//                    return "TIMESTAMPTZ(" + p.description + ")"
//                } else {
//                    return "TIMESTAMPTZ"
//                }
//            case .tsquery: return "TSQUERY"
//            case .tsvector: return "TSVECTOR"
//            case .txidSnapshot: return "TXID_SNAPSHOT"
//            case .uuid: return "UUID"
//            case .xml: return "XML"
//            case .custom(let custom): return custom
//            }
//        }
//    }
//    
//    /// See `SQLSerializable`.
//    public func serialize(_ binds: inout [Encodable]) -> String {
//        if isArray {
//            return primitive.serialize(&binds) + "[]"
//        } else {
//            return primitive.serialize(&binds)
//        }
//    }
//}
