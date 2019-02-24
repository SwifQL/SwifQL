//
//  Predicates.swift
//  App
//
//  Created by Mihael Isaev on 24/02/2019.
//

import Foundation
import SwifQL

public func == <T>(lhs: T, rhs: T.AType) -> SwifQLable where T: FQUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType: Encodable {
    return SwifQLPredicate(operator: .equal, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartUnsafeValue(rhs)))
}
public func == <T>(lhs: T, rhs: T.AType.RawValue) -> SwifQLable where T: FQUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType.RawValue: SwifQLable {
    return SwifQLPredicate(operator: .equal, lhs: lhs, rhs: rhs)
}
public func != <T>(lhs: T, rhs: T.AType) -> SwifQLable where T: FQUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType: Encodable {
    return SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: SwifQLableParts(parts: SwifQLPartUnsafeValue(rhs)))
}
public func != <T>(lhs: T, rhs: T.AType.RawValue) -> SwifQLable where T: FQUniversalKeyPath, T: SwifQLable, T.AType: RawRepresentable, T.AType.RawValue: SwifQLable {
    return SwifQLPredicate(operator: .notEqual, lhs: lhs, rhs: rhs)
}
