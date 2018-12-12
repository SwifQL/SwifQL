////
////  FQSelect.swift
////  FluentQuery
////
////  Created by Mihael Isaev on 05.06.2018.
////
//
//import Foundation
//import Fluent
//
//public class FQSelect: FQPart {
//    
//    var fields: [FQPart] = []
//    
//    public init(copy from: FQSelect? = nil) {
//        if let from = from {
//            fields = from.fields.map { $0 }
//        }
//    }
//    
//    //@available(*, deprecated: 1.0, message: "will soon become unavailable.")
//    @discardableResult
//    public func field(_ str: String) -> Self {
//        fields.append(str)
//        return self
//    }
//    
//    @discardableResult
//    public func all<T>(_ table: T.Type) -> Self where T: Model {
//        fields.append("\(T.FQType.alias.doubleQuotted).*")
//        return self
//    }
//    
//    @discardableResult
//    public func all<T>(_ alias: FQAlias<T>) -> Self where T: Model {
//        fields.append("\(alias.alias.doubleQuotted).*")
//        return self
//    }
//    
//    @discardableResult
//    public func field<T>(_ kp: T, as: String? = nil) -> Self where T: FQUniversalKeyPath {
//        _append(kp.queryValue, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func field(as: String? = nil, _ json: FQJSON) -> Self {
//        fields.append(FQJSON.ForSelectField(json, as: `as`))
//        return self
//    }
//    
//    @discardableResult
//    public func distinct<T>(_ kp: T, as: String? = nil) -> Self where T: FQUniversalKeyPath {
//        _append("DISTINCT \(kp.queryValue)", `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<M>(_ func: FQAggregate.FunctionWithKeyPath<M>, as: String? = nil) -> Self where M: FQUniversalKeyPath {
//        _append(`func`.func, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<M>(_ func: FQJSON.FunctionWithModelAlias<M>, as: String? = nil) -> Self where M: Model {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<M>(_ func: FQJSON.FunctionWithModel<M>, as: String? = nil) -> Self where M: Model {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<M, V>(_ func: FQJSON.FuncOptionKP<M, V>, as: String? = nil) -> Self where M: Model {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<M, V>(_ func: FQJSON.FuncOptionAKP<M, V>, as: String? = nil) -> Self where M: Model {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<T>(_ func: FQJSON.FunctionWithSubquery<T>, as: String? = nil) -> Self where T: FQPart {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func `func`<T>(_ func: FQJSON.FunctionWithFunctionWithModelAlias<T>, as: String? = nil) -> Self where T: Model {
//        _append(`func`.func.roundBracketted, `as`)
//        return self
//    }
//    
//    @discardableResult
//    public func field(_ subquery: FluentQuery, as: String? = nil) -> Self {
//        _append(subquery.query.roundBracketted, `as`)
//        return self
//    }
//    
//    private func _append(_ field: String, _ as: String? = nil) {
//        var string = "\(field)"
//        if let `as` = `as` {
//            string.append(" as \(`as`.doubleQuotted)")
//        }
//        fields.append(string)
//    }
//    
//    public var query: String {
//        var result = ""
//        
//        for (index, field) in fields.enumerated() {
//            if index > 0 {
//                result.append(",")
//                result.append(FluentQueryNextLine)
//            }
//            result.append(field.query)
//        }
//        
//        return result
//    }
//    
//    func joinAnotherInstance(_ inst: FQSelect) {
//        fields.append(contentsOf: inst.fields)
//    }
//}
