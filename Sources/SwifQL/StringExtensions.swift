//
//  StringExtensions.swift
//  App
//
//  Created by Mihael Isaev on 06.06.2018.
//

import Foundation

extension String {
    public var singleQuotted: String {
        return "'\(self)'"
    }
    
    public var doubleQuotted: String {
        return "\"\(self)\""
    }
    
    public var roundBracketted: String {
        return "(\(self))"
    }
    
    public static func singleQuotted(_ v: Any) -> String {
        return "\(v)".singleQuotted
    }
    
    public static func doubleQuotted(_ v: Any) -> String {
        return "\(v)".doubleQuotted
    }
    
    public static func roundBracketted(_ v: Any) -> String {
        return "\(v)".roundBracketted
    }
    
    public func `as`(_ v: String) -> String {
        return self + " as " + v
    }
}
