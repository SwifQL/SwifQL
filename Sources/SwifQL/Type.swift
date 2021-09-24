//
//  Type.swift
//  SwifQL
//
//  Created by Mihael Isaev on 12/10/2019.
//

typealias CastType = Type

public struct Type {
    public let name: String
    
    public init (_ name: String) {
        self.name = name
    }
    
    // MARK: -
    
    /// enum
    public static var `enum`: Type = .init("ENUM")
    
    /// range
    public static var range: Type = .init("RANGE")
    
    
    // MARK: -
    // MARK: Numeric Types
    
    /// signed two-byte integer
    public static var smallint: Type = .init("smallint")
    public static var smallintArray: Type = .init("smallint[]")
    
    /// signed four-byte integer
    public static var int4: Type = .init("int4")
    public static var int4Array: Type = .init("int4[]")
    
    /// signed two-byte integer
    public static var int2: Type = .init("int2")
    public static var int2Array: Type = .init("int2[]")
    
    /// signed eight-byte integer
    public static var int8: Type = .init("int8")
    public static var int8Array: Type = .init("int8[]")
    
    /// signed four-byte integer
    public static var int: Type = .init("int")
    public static var intArray: Type = .init("int[]")
    
    /// signed four-byte integer
    public static var integer: Type = .init("integer")
    public static var integerArray: Type = .init("integer[]")
    
    /// signed eight-byte integer
    public static var bigint: Type = .init("bigint")
    public static var bigintArray: Type = .init("bigint[]")
    
    /// exact numeric of selectable precision
    public static var decimal: Type = .init("decimal")
    public static var decimalArray: Type = .init("decimal[]")
    /// exact numeric of selectable precision
    public static func decimal(_ p: Int, _ s: Int) -> Type { .init("decimal(\(p), \(s))") }
    
    /// exact numeric of selectable precision
    public static var numeric: Type = .init("numeric")
    public static var numericArray: Type = .init("numeric[]")
    /// exact numeric of selectable precision
    public static func numeric(_ p: Int, _ s: Int) -> Type { .init("numeric(\(p), \(s))") }
    
    /// single precision floating-point number (4 bytes)
    public static var real: Type = .init("real")
    public static var realArray: Type = .init("real[]")
    
    public static func float(_ v: Int) -> Type { .init("float(\(v))") }
    
    /// single precision floating-point number (4 bytes)
    public static var float4: Type = .init("float4")
    public static var float4Array: Type = .init("float4[]")
    
    /// double precision floating-point number (8 bytes)
    public static var float8: Type = .init("float8")
    public static var float8Array: Type = .init("float8[]")
    
    /// double precision floating-point number (8 bytes)
    public static var doublePrecision: Type = .init("double precision")
    public static var doublePrecisionArray: Type = .init("double precision[]")
    
    /// autoincrementing two-byte integer
    public static var smallserial: Type = .init("smallserial")
    public static var smallserialArray: Type = .init("smallserial[]")
    
    /// autoincrementing two-byte integer
    public static var serial2: Type = .init("serial2")
    public static var serial2Array: Type = .init("serial2[]")
    
    /// autoincrementing four-byte integer
    public static var serial: Type = .init("serial")
    public static var serialArray: Type = .init("serial[]")
    
    /// autoincrementing four-byte integer
    public static var serial4: Type = .init("serial4")
    public static var serial4Array: Type = .init("serial4[]")
    
    /// autoincrementing eight-byte integer
    public static var serial8: Type = .init("serial8")
    public static var serial8Array: Type = .init("serial8[]")
    
    /// autoincrementing eight-byte integer
    public static var bigserial: Type = .init("bigserial")
    public static var bigserialArray: Type = .init("bigserial[]")
    
    // MARK: Monetary Types
    
    /// currency amount
    public static var money: Type = .init("money")
    public static var moneyArray: Type = .init("money[]")
    
    // MARK: Character Types
    
    /// fixed-length character string
    public static var char: Type = .init("char")
    public static var charArray: Type = .init("char[]")
    
    /// variable-length character string
    public static var varchar: Type = .init("varchar")
    public static func varchar(_ n: Int) -> Type { .init("varchar(\(n))") }
    public static var varcharArray: Type = .init("varchar[]")
    
    /// variable-length character string
    public static var text: Type = .init("text")
    public static var textArray: Type = .init("text[]")
    
    // MARK: Binary Data Types
    
    /// binary data (“byte array”)
    public static var bytea: Type = .init("bytea")
    public static var byteaArray: Type = .init("bytea[]")
    
    // MARK: Date/Time Types
    
    /// date and time (no time zone)
    public static var timestamp: Type = .init("timestamp")
    public static var timestampArray: Type = .init("timestamp[]")
    
    /// date and time (no time zone)
    public static var timestampWithoutTimeZone: Type = .init("timestamp without time zone")
    public static var timestampWithoutTimeZoneArray: Type = .init("timestamp without time zone[]")
    
    /// date and time, including time zone
    public static var timestampWithTimeZone: Type = .init("timestamp with time zone")
    public static var timestampWithTimeZoneArray: Type = .init("timestamp with time zone[]")
    
    /// date and time, including time zone
    public static var timestamptz: Type = .init("timestamptz")
    public static var timestamptzArray: Type = .init("timestamptz[]")
    
    /// date and time
    public static func timestamp(_ p: Int, withTimeZone: Bool = false) -> Type {
        return .init("timestamp(\(p)) \(withTimeZone ? "without time zone" : "with time zone")")
    }
    
    /// calendar date (year, month, day)
    public static var date: Type = .init("date")
    public static var dateArray: Type = .init("date[]")
    
    /// time of day (no time zone)
    public static var time: Type = .init("time")
    public static var timeArray: Type = .init("time[]")
    
    /// time of day (no time zone)
    public static var timeWithoutTimeZone: Type = .init("time without time zone")
    public static var timeWithoutTimeZoneArray: Type = .init("time without time zone[]")
    
    /// time of day, including time zone
    public static var timeWithTimeZone: Type = .init("time with time zone")
    public static var timeWithTimeZoneArray: Type = .init("time with time zone[]")
    
    /// time of day, including time zone
    public static var timetz: Type = .init("timetz")
    public static var timetzArray: Type = .init("timetz[]")
    
    /// time of day
    public static func time(_ p: Int, withTimeZone: Bool = false) -> Type {
        return .init("time(\(p)) \(withTimeZone ? "without time zone" : "with time zone")")
    }
    
    /// time span
    public static var interval: Type = .init("interval")
    public static var intervalArray: Type = .init("interval[]")
    
    /// time span
    public static func interval(_ fields: String, p: Int) -> Type {
        return .init("interval \(fields) (\(p))")
    }
    
    // MARK: Boolean Type
    
    /// logical Boolean (true/false)
    public static var boolean: Type = .init("boolean")
    public static var booleanArray: Type = .init("boolean[]")
    
    /// logical Boolean (true/false)
    public static var bool: Type = .init("bool")
    public static var boolArray: Type = .init("bool[]")
    
    // MARK: Geometric Types
    
    /// geometric point on a plane
    public static var point: Type = .init("point")
    public static var pointArray: Type = .init("point[]")
    
    /// infinite line on a plane
    public static var line: Type = .init("line")
    public static var lineArray: Type = .init("line[]")
    
    /// line segment on a plane
    public static var lseg: Type = .init("lseg")
    public static var lsegArray: Type = .init("lseg[]")
    
    /// rectangular box on a plane
    public static var box: Type = .init("box")
    public static var boxArray: Type = .init("box[]")
    
    /// geometric path on a plane
    public static var path: Type = .init("path")
    public static var pathArray: Type = .init("path[]")
    
    /// closed geometric path on a plane
    public static var polygon: Type = .init("polygon")
    public static var polygonArray: Type = .init("polygon[]")
    
    /// circle on a plane
    public static var circle: Type = .init("circle")
    public static var circleArray: Type = .init("circle[]")
    
    // MARK: Network Address Types
    
    /// IPv4 or IPv6 network address
    public static var cidr: Type = .init("cidr")
    public static var cidrArray: Type = .init("cidr[]")
    
    /// IPv4 or IPv6 host address
    public static var inet: Type = .init("inet")
    public static var inetArray: Type = .init("inet[]")
    
    /// MAC (Media Access Control) address
    public static var macaddr: Type = .init("macaddr")
    public static var macaddrArray: Type = .init("macaddr[]")
    
    /// MAC (Media Access Control) address (EUI-64 format)
    public static var macaddr8: Type = .init("macaddr8")
    public static var macaddr8Array: Type = .init("macaddr8[]")
    
    // MARK: Bit String Types
    
    /// fixed-length bit string
    public static var bit: Type = .init("bit")
    public static var bitArray: Type = .init("bit[]")
    /// fixed-length bit string
    public static func bit(_ v: Int) -> Type { .init("bit(\(v))") }
    
    /// variable-length bit string
    public static var bitVarying: Type = .init("bit varying")
    public static var bitVaryingArray: Type = .init("bit varying[]")
    /// variable-length bit string
    public static func bitVarying(_ v: Int) -> Type { .init("bit varying(\(v))") }
    
    /// variable-length bit string
    public static var varbit: Type = .init("varbit")
    /// variable-length bit string
    public static func varbit(_ v: Int) -> Type { .init("varbit(\(v))") }
    
    // MARK: Text Search Types
    
    /// text search document
    public static var tsvector: Type = .init("tsvector")
    public static var tsvectorArray: Type = .init("tsvector[]")
    
    /// text search query
    public static var tsquery: Type = .init("tsquery")
    public static var tsqueryArray: Type = .init("tsquery[]")
    
    // MARK: UUID Type
    
    /// universally unique identifier
    public static var uuid: Type = .init("uuid")
    public static var uuidArray: Type = .init("uuid[]")
    
    // MARK: XML Type
    
    /// XML data
    public static var xml: Type = .init("xml")
    public static var xmlArray: Type = .init("xml[]")
    
    // MARK: Postgres JSON Types
    
    /// textual JSON data
    public static var json: Type = .init("json")
    public static var jsonArray: Type = .init("json[]")
    
    /// binary JSON data, decomposed
    public static var jsonb: Type = .init("jsonb")
    public static var jsonbArray: Type = .init("jsonb[]")
    
    // MARK: Postgres Built-in Range Types
    
    /// Range of integer
    public static var int4range: Type = .init("int4range")
    public static var int4rangeArray: Type = .init("int4range[]")

    /// Range of bigint
    public static var int8range: Type = .init("int8range")
    public static var int8rangeArray: Type = .init("int8range[]")

    /// Range of numeric
    public static var numrange: Type = .init("numrange")
    public static var numrangeArray: Type = .init("numrange[]")

    /// Range of timestamp without time zone
    public static var tsrange: Type = .init("tsrange")
    public static var tsrangeArray: Type = .init("tsrange[]")

    /// Range of timestamp with time zone
    public static var tstzrange: Type = .init("tstzrange")
    public static var tstzrangeArray: Type = .init("tstzrange[]")

    /// Range of date
    public static var daterange: Type = .init("daterange")
    public static var daterangeArray: Type = .init("daterange[]")
    
    // MARK: Object Identifier Types
    
    /// numeric object identifier
    public static var oid: Type = .init("oid")
    public static var oidArray: Type = .init("oid[]")
    
    /// function name
    public static var regproc: Type = .init("regproc")
    public static var regprocArray: Type = .init("regproc[]")
    
    /// function name
    public static var pg_proc: Type = .init("pg_proc")
    public static var pg_procArray: Type = .init("pg_proc[]")
    
    /// function with argument types
    public static var regprocedure: Type = .init("regprocedure")
    public static var regprocedureArray: Type = .init("regprocedure[]")
    
    /// operator name
    public static var regoper: Type = .init("regoper")
    public static var regoperArray: Type = .init("regoper[]")
    
    /// operator name
    public static var pg_operator: Type = .init("pg_operator")
    public static var pg_operatorArray: Type = .init("pg_operator[]")
    
    /// operator with argument types
    public static var regoperator: Type = .init("regoperator")
    public static var regoperatorArray: Type = .init("regoperator[]")
    
    /// relation name
    public static var regclass: Type = .init("regclass")
    public static var regclassArray: Type = .init("regclass[]")
    
    /// relation name
    public static var pg_class: Type = .init("pg_class")
    public static var pg_classArray: Type = .init("pg_class[]")
    
    /// data type name
    public static var regtype: Type = .init("regtype")
    public static var regtypeArray: Type = .init("regtype[]")
    
    /// data type name
    public static var pg_type: Type = .init("pg_type")
    public static var pg_typeArray: Type = .init("pg_type[]")
    
    /// role name
    public static var regrole: Type = .init("regrole")
    public static var regroleArray: Type = .init("regrole[]")
    
    /// role name
    public static var pg_authid: Type = .init("pg_authid")
    public static var pg_authidArray: Type = .init("pg_authid[]")
    
    /// namespace name
    public static var regnamespace: Type = .init("regnamespace")
    public static var regnamespaceArray: Type = .init("regnamespace[]")
    
    /// namespace name
    public static var pg_namespace: Type = .init("pg_namespace")
    public static var pg_namespaceArray: Type = .init("pg_namespace[]")
    
    /// text search configuration
    public static var regconfig: Type = .init("regconfig")
    public static var regconfigArray: Type = .init("regconfig[]")
    
    /// text search configuration
    public static var pg_ts_config: Type = .init("pg_ts_config")
    public static var pg_ts_configArray: Type = .init("pg_ts_config[]")
    
    /// text search dictionary
    public static var regdictionary: Type = .init("regdictionary")
    public static var regdictionaryArray: Type = .init("regdictionary[]")
    
    /// text search dictionary
    public static var pg_ts_dict: Type = .init("pg_ts_dict")
    public static var pg_ts_dictArray: Type = .init("pg_ts_dict[]")
    
    // MARK: Postgres Log Sequence Number
    
    /// PostgreSQL Log Sequence Number
    public static var pgLsn: Type = .init("pg_lsn")
    public static var pgLsnArray: Type = .init("pg_lsn[]")
    
    // MARK: Postgres Pseudo-Types
    // The PostgreSQL type system contains a number of special-purpose entries that are collectively called pseudo-types.
    // A pseudo-type cannot be used as a column data type, but it can be used to declare a function's argument or result type.
    // Each of the available pseudo-types is useful in situations where a function's behavior does not correspond to
    // simply taking or returning a value of a specific SQL data type.
    
    /// Indicates that a function accepts any input data type.
    public static var any: Type = .init("any")
    
    /// Indicates that a function accepts any data type (see Section 37.2.5).
    public static var anyelement: Type = .init("anyelement")
    
    /// Indicates that a function accepts any array data type (see Section 37.2.5).
    public static var anyarray: Type = .init("anyarray")
    
    /// Indicates that a function accepts any non-array data type (see Section 37.2.5).
    public static var anynonarray: Type = .init("anynonarray")
    
    /// Indicates that a function accepts any enum data type (see Section 37.2.5 and Section 8.7).
    public static var anyenum: Type = .init("anyenum")
    
    /// Indicates that a function accepts any range data type (see Section 37.2.5 and Section 8.17).
    public static var anyrange: Type = .init("anyrange")
    
    /// Indicates that a function accepts or returns a null-terminated C string.
    public static var cstring: Type = .init("cstring")
    
    /// Indicates that a function accepts or returns a server-internal data type.
    public static var `internal`: Type = .init("internal")
    
    /// A procedural language call handler is declared to return language_handler.
    public static var language_handler: Type = .init("language_handler")
    
    /// A foreign-data wrapper handler is declared to return fdw_handler.
    public static var fdw_handler: Type = .init("fdw_handler")
    
    /// An index access method handler is declared to return index_am_handler.
    public static var index_am_handler: Type = .init("index_am_handler")
    
    /// A tablesample method handler is declared to return tsm_handler.
    public static var tsm_handler: Type = .init("tsm_handler")
    
    /// Identifies a function taking or returning an unspecified row type.
    public static var record: Type = .init("record")
    
    /// A trigger function is declared to return trigger.
    public static var trigger: Type = .init("trigger")
    
    /// An event trigger function is declared to return event_trigger.
    public static var event_trigger: Type = .init("event_trigger")
    
    /// Identifies a representation of DDL commands that is available to event triggers.
    public static var pg_ddl_command: Type = .init("pg_ddl_command")
    
    /// Indicates that a function returns no value.
    public static var void: Type = .init("void")
    
    /// Identifies a not-yet-resolved type, e.g. of an undecorated string literal.
    public static var unknown: Type = .init("unknown")
    
    /// An obsolete type name that formerly served many of the above purposes.
    public static var opaque: Type = .init("opaque")
    
    // MARK: Other
    
    /// user-level transaction ID snapshot
    public static var txid_snapshot: Type = .init("txid_snapshot")
    public static var txid_snapshotArray: Type = .init("txid_snapshot[]")
    
    // MARK: -
    // MARK: Array Subscript
    
    public subscript () -> Type { .init("\(name)[]") }
    
    // MARK: -
    // MARK: Custom
    
    public static func custom(_ name: String) -> Type { .init(name) }
    public static func customArray(_ name: String) -> Type { .init(name + "[]") }
}
