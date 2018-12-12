///// The data type's raw object ID.
///// Use `select * from pg_type where oid = <idhere>;` to lookup more information.
//public struct PostgreSQLDataFormat: Codable, Equatable, ExpressibleByIntegerLiteral {
//    /// `0`
//    public static let null = PostgreSQLDataFormat(0)
//    /// `16`
//    public static let bool = PostgreSQLDataFormat(16)
//    /// `17`
//    public static let bytea = PostgreSQLDataFormat(17)
//    /// `18`
//    public static let char = PostgreSQLDataFormat(18)
//    /// `19`
//    public static let name = PostgreSQLDataFormat(19)
//    /// `20`
//    public static let int8 = PostgreSQLDataFormat(20)
//    /// `21`
//    public static let int2 = PostgreSQLDataFormat(21)
//    /// `23`
//    public static let int4 = PostgreSQLDataFormat(23)
//    /// `24`
//    public static let regproc = PostgreSQLDataFormat(24)
//    /// `25`
//    public static let text = PostgreSQLDataFormat(25)
//    /// `26`
//    public static let oid = PostgreSQLDataFormat(26)
//    /// `114`
//    public static let json = PostgreSQLDataFormat(114)
//    /// `194`
//    public static let pg_node_tree = PostgreSQLDataFormat(194)
//    /// `600`
//    public static let point = PostgreSQLDataFormat(600)
//    /// `700`
//    public static let float4 = PostgreSQLDataFormat(700)
//    /// `701`
//    public static let float8 = PostgreSQLDataFormat(701)
//    /// `1000`
//    public static let _bool = PostgreSQLDataFormat(1000)
//    /// `1001`
//    public static let _bytea = PostgreSQLDataFormat(1001)
//    /// `1002`
//    public static let _char = PostgreSQLDataFormat(1002)
//    /// `1003`
//    public static let _name = PostgreSQLDataFormat(1003)
//    /// `1005`
//    public static let _int2 = PostgreSQLDataFormat(1005)
//    /// `1007`
//    public static let _int4 = PostgreSQLDataFormat(1007)
//    /// `1009`
//    public static let _text = PostgreSQLDataFormat(1009)
//    /// `1016`
//    public static let _int8 = PostgreSQLDataFormat(1016)
//    /// `1017`
//    public static let _point = PostgreSQLDataFormat(1017)
//    /// `1021`
//    public static let _float4 = PostgreSQLDataFormat(1021)
//    /// `1022`
//    public static let _float8 = PostgreSQLDataFormat(1022)
//    /// `1034`
//    public static let _aclitem = PostgreSQLDataFormat(1034)
//    /// `1042`
//    public static let bpchar = PostgreSQLDataFormat(1042)
//    /// `1043`
//    public static let varchar = PostgreSQLDataFormat(1043)
//    /// `1082`
//    public static let date = PostgreSQLDataFormat(1082)
//    /// `1083`
//    public static let time = PostgreSQLDataFormat(1083)
//    /// `1114`
//    public static let timestamp = PostgreSQLDataFormat(1114)
//    /// `1115`
//    public static let _timestamp = PostgreSQLDataFormat(1115)
//    /// `1184`
//    public static let timestamptz = PostgreSQLDataFormat(1184)
//    /// `1266`
//    public static let timetz = PostgreSQLDataFormat(1266)
//    /// `1700`
//    public static let numeric = PostgreSQLDataFormat(1700)
//    /// `2278`
//    public static let void = PostgreSQLDataFormat(2278)
//    /// `2950`
//    public static let uuid = PostgreSQLDataFormat(2950)
//    /// `2951`
//    public static let _uuid = PostgreSQLDataFormat(2951)
//    /// `3802`
//    public static let jsonb = PostgreSQLDataFormat(3802)
//    /// `3807`
//    public static let _jsonb = PostgreSQLDataFormat(3807)
//
//    /// See `Equatable.==`
//    public static func ==(lhs: PostgreSQLDataFormat, rhs: PostgreSQLDataFormat) -> Bool {
//        return lhs.raw == rhs.raw
//    }
//
//    /// The raw data type code recognized by PostgreSQL.
//    public var raw: Int32
//
//    /// See `ExpressibleByIntegerLiteral.init(integerLiteral:)`
//    public init(integerLiteral value: Int32) {
//        self.init(value)
//    }
//
//    /// Creates a new `PostgreSQLDataType`
//    public init(_ raw: Int32) {
//        self.raw = raw
//    }
//}
//
//extension PostgreSQLDataFormat {
//    /// Returns the known SQL name, if one exists.
//    /// Note: This only supports a limited subset of all PSQL types and is meant for convenience only.
//    public var knownSQLName: String? {
//        switch self {
//        case .bool: return "BOOLEAN"
//        case .bytea: return "BYTEA"
//        case .char: return "CHAR"
//        case .name: return "NAME"
//        case .int8: return "BIGINT"
//        case .int2: return "SMALLINT"
//        case .int4: return "INTEGER"
//        case .regproc: return "REGPROC"
//        case .text: return "TEXT"
//        case .oid: return "OID"
//        case .json: return "JSON"
//        case .pg_node_tree: return "PGNODETREE"
//        case .point: return "POINT"
//        case .float4: return "REAL"
//        case .float8: return "DOUBLE PRECISION"
//        case ._bool: return "BOOLEAN[]"
//        case ._bytea: return "BYTEA[]"
//        case ._char: return "CHAR[]"
//        case ._name: return "NAME[]"
//        case ._int2: return "SMALLINT[]"
//        case ._int4: return "INTEGER[]"
//        case ._text: return "TEXT[]"
//        case ._int8: return "BIGINT[]"
//        case ._point: return "POINT[]"
//        case ._float4: return "REAL[]"
//        case ._float8: return "DOUBLE PRECISION[]"
//        case ._aclitem: return "ACLITEM[]"
//        case .bpchar: return "BPCHAR"
//        case .varchar: return "VARCHAR"
//        case .date: return "DATE"
//        case .time: return "TIME"
//        case .timestamp: return "TIMESTAMP"
//        case ._timestamp: return "TIMESTAMP[]"
//        case .numeric: return "NUMERIC"
//        case .void: return "VOID"
//        case .uuid: return "UUID"
//        case ._uuid: return "UUID[]"
//        case .jsonb: return "JSONB"
//        case ._jsonb: return "JSONB[]"
//        default: return nil
//        }
//    }
//    
//    /// Returns the array type for this type if one is known.
//    internal var arrayType: PostgreSQLDataFormat? {
//        switch self {
//        case .bool: return ._bool
//        case .bytea: return ._bytea
//        case .char: return ._char
//        case .name: return ._name
//        case .int2: return ._int2
//        case .int4: return ._int4
//        case .int8: return ._int8
//        case .point: return ._point
//        case .float4: return ._float4
//        case .float8: return ._float8
//        case .uuid: return ._uuid
//        case .jsonb: return ._jsonb
//        case .text: return ._text
//        default: return nil
//        }
//    }
//}
//
//extension PostgreSQLDataType {
//    internal var dataFormat: PostgreSQLDataFormat? {
//        switch primitive {
//        case .bigint, .bigserial: return .int8
//        case .bit, .char: return .char
//        case .boolean: return .bool
//        case .bytea: return .bytea
//        case .date: return .date
//        case .doublePrecision: return .float8
//        case .integer, .serial: return .int4
//        case .json: return .json
//        case .jsonb: return .jsonb
//        case .numeric: return .numeric
//        case .smallint, .smallserial: return .int2
//        case .text: return .text
//        case .time: return .time
//        case .timestamptz: return .timestamptz
//        case .uuid: return .uuid
//        default: return nil
//        }
//    }
//}
//
//extension PostgreSQLDataFormat: CustomStringConvertible {
//    /// See `CustomStringConvertible.description`
//    public var description: String {
//        return knownSQLName ?? "UNKNOWN \(raw)"
//    }
//}
