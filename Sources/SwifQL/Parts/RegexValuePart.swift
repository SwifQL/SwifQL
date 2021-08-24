//
//  RegexValuePart.swift
//  SwifQL
//
//  Created by Julien Di Marco on 04/02/2021.
//

import Foundation

public struct SwifQLPartRegexValue {

  var elements: [SwifQLable]

  public init (_ elements: [SwifQLable]) {
    self.elements = elements
  }

}

extension SwifQLPartRegexValue: SwifQLable {

  public var parts: [SwifQLPart] { [self] }

}

extension SwifQLPartRegexValue: SwifQLPart {

  public func prepare(_ dialect: SQLDialect, preparator: inout SwifQLPrepared) -> String {
    var regexBuilder = ""
    guard let regexDialect = dialect.regexDialect else { return "" }

    elements.enumerated().forEach { i, v in
      let prepared = v.prepare(regexDialect)
      preparator._values.append(contentsOf: prepared._values)
      preparator._formattedValues.append(contentsOf: prepared._formattedValues)
      regexBuilder += prepared._query
    }

    return regexBuilder
  }

}

// MARK: -

extension SwifQLPartOperator {

  public static var regexNotMatch: Result { "!~".operator }
  public static var regexMatch: Result { "=~".operator }

  public static var caret: Result { "^".operator }
  public static var slash: Result { "/".operator }
  public static var dollar: Result { "$".operator }

  public static var pipe: Result { "|".operator }

}

// MARK: -

public struct SwifQLRegex: SwifQLable {

// MARK: - Properties

internal var internals: [SwifQLPart]

// MARK: - Computed Properties

  public var parts: [SwifQLPart] {
    var parts: [SwifQLPart] = []

    parts.append(o: .slash)
    parts += internals
    parts.append(o: .slash)

    return parts
  }

  // MARK: - Initializers

  public init (_ parts: SwifQLPart...) {
    self.init(parts)
  }

  public init (_ parts: [SwifQLPart]) {
    self.internals = parts
  }

  public init (_ parts: SwifQLable...) {
    self.init(parts)
  }

  public init (_ parts: [SwifQLable]) {
    self.internals = [SwifQLPartRegexValue(parts)]
  }

}

extension Array {

  func insert(separator: Element) -> [Element] {
    (0 ..< 2 * count - 1).map { $0 % 2 == 0 ? self[$0/2] : separator }
  }

}

infix operator =~ : ComparisonPrecedence
public func =~ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
  let regex = SwifQLRegex(rhs)
  return SwifQLPredicate(operator: .regexMatch, lhs: lhs, rhs: regex)
}

public func =~ (lhs: SwifQLable, rhs: [SwifQLable]) -> SwifQLable {
  let regex = SwifQLRegex(rhs.insert(separator: SwifQLPartOperator.pipe))
  return SwifQLPredicate(operator: .regexMatch, lhs: lhs, rhs: regex)
}

infix operator !~ : ComparisonPrecedence
public func !~ (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
  let regex = SwifQLRegex(rhs)
  return SwifQLPredicate(operator: .regexNotMatch, lhs: lhs, rhs: regex)
}

public func !~ (lhs: SwifQLable, rhs: [SwifQLable]) -> SwifQLable {
  let regex = SwifQLRegex(rhs.insert(separator: SwifQLPartOperator.pipe))
  return SwifQLPredicate(operator: .regexNotMatch, lhs: lhs, rhs: regex)
}

infix operator |: AdditionPrecedence
public func | (lhs: SwifQLable, rhs: SwifQLable) -> SwifQLable {
  return SwifQLPredicate(operator: .pipe, lhs: lhs, rhs: rhs)
}

// ^ Regex Operator
prefix operator ^
prefix public func ^(rhs: SwifQLable) -> SwifQLable {
  var parts: [SwifQLPart] = []
  parts.append(o: .caret)
  parts.append(contentsOf: rhs.parts)
  return SwifQLableParts(parts: parts)
}

prefix public func ^(rhs: [SwifQLable]) -> SwifQLable {
  var parts: [SwifQLPart] = []
  parts.append(o: .caret)
  parts.append(contentsOf: rhs.flatMap({ $0.parts }))
  return SwifQLableParts(parts: parts)
}

// $ Regex Operator
postfix operator ^
postfix public func ^(lhs: SwifQLable) -> SwifQLable {
  var parts: [SwifQLPart] = []
  parts.append(contentsOf: lhs.parts)
  parts.append(o: .dollar)
  return SwifQLableParts(parts: parts)
}

postfix public func ^(lhs: [SwifQLable]) -> SwifQLable {
  var parts: [SwifQLPart] = []
  parts.append(contentsOf: lhs.flatMap({ $0.parts }))
  parts.append(o: .dollar)
  return SwifQLableParts(parts: parts)
}

postfix operator ||
postfix public func ||(lhs: [SwifQLable]) -> SwifQLable {
  let transformed = lhs.insert(separator: SwifQLPartOperator.pipe)
  return SwifQLableParts(parts: transformed.flatMap({ $0.parts }))
}

/// No Specific operator for AND comparison, could do (SwifQable) foreach elemnent
//postfix operator &&
//postfix public func &&(lhs: [SwifQLable]) -> SwifQLable {
//  return SwifQLableParts(parts: rhs.insert(separator: SwifQLPartOperator.pipe))
//}
