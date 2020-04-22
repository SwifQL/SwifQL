////
////  SwifQLableFunctionBuilder.swift
////  SwifQL
////
////  Created by Mihael Isaev on 11.04.2020.
////
//
//import Foundation
//
//@_functionBuilder public struct SwifQLableFunctionBuilder {
//    public typealias Block = () -> SwifQLable
//    
//    /// Builds an empty view from an block containing no statements, `{ }`.
//    public static func buildBlock() -> SwifQLable { [] }
//    
//    /// Passes a single view written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
//    public static func buildBlock(_ attrs: SwifQLable...) -> SwifQLable {
//        buildBlock(attrs)
//    }
//    
//    /// Passes a single view written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
//    public static func buildBlock(_ attrs: [SwifQLable]) -> SwifQLable {
//        
//        ViewBuilderItems(items: attrs.flatMap { $0.viewBuilderItems })
//    }
//    
//    /// Provides support for "if" statements in multi-statement closures, producing an `Optional` view
//    /// that is visible only when the `if` condition evaluates `true`.
//    public static func buildIf(_ content: SwifQLable?) -> SwifQLable {
//        guard let content = content else { return [] }
//        return content
//    }
//    
//    /// Provides support for "if" statements in multi-statement closures, producing
//    /// ConditionalContent for the "then" branch.
//    public static func buildEither(first: SwifQLable) -> SwifQLable {
//        first
//    }
//
//    /// Provides support for "if-else" statements in multi-statement closures, producing
//    /// ConditionalContent for the "else" branch.
//    public static func buildEither(second: SwifQLable) -> SwifQLable {
//        second
//    }
//}
//
//public protocol SwifQLableFunctionBuilderItem {
//    var expressions: [SwifQLable] { get }
//}
//
//extension SwifQLable: SwifQLableFunctionBuilderItem {
//    public var expressions: [SwifQLable] { [self] }
//}
//extension Array: SwifQLableFunctionBuilderItem where Element: SwifQLable {
//    public var expressions: [SwifQLable] { self }
//}
//extension Optional: SwifQLableFunctionBuilderItem where Wrapped: SwifQLable {
//    public var expressions: [SwifQLable] {
//        switch self {
//        case .none: return []
//        case .some(let value): return [value]
//        }
//    }
//}
