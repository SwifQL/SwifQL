//
//  Types+Nested.swift
//  SwifQL
//

import Foundation

private func quotedNestedTypeMember(_ name: String) -> String {
    let escaped = name.replacingOccurrences(of: "\"", with: "\"\"")
    return "\"\(escaped)\""
}

extension Type {
    /// Variable-length LIST type.
    public static func list(_ element: Type) -> Type {
        .init("\(element.name)[]")
    }

    /// Fixed-size ARRAY type.
    public static func array(_ element: Type, length: Int) -> Type {
        precondition(length > 0, "Fixed ARRAY length must be greater than zero")
        return .init("\(element.name)[\(length)]")
    }

    /// MAP type with the supplied key and value types.
    public static func map(key: Type, value: Type) -> Type {
        .init("MAP(\(key.name), \(value.name))")
    }

    /// STRUCT type with named members.
    public static func `struct`(_ members: (String, Type)...) -> Type {
        `struct`(members)
    }

    /// STRUCT type with named members.
    public static func `struct`(_ members: [(String, Type)]) -> Type {
        let body = members.map { member in
            "\(quotedNestedTypeMember(member.0)) \(member.1.name)"
        }.joined(separator: ", ")
        return .init("STRUCT(\(body))")
    }

    /// UNION type with named members.
    public static func union(_ members: (String, Type)...) -> Type {
        union(members)
    }

    /// UNION type with named members.
    public static func union(_ members: [(String, Type)]) -> Type {
        let body = members.map { member in
            "\(quotedNestedTypeMember(member.0)) \(member.1.name)"
        }.joined(separator: ", ")
        return .init("UNION(\(body))")
    }
}
