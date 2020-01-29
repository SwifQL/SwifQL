//
//  SwifQLable+NotBetween.swift
//  SwifQLCore
//
//  Created by Mihael Isaev on 16/11/2018.
//

import Foundation

//MARK: NOT BETWEEN

extension SwifQLable {
    public func notBetween(_ part: SwifQLable) -> SwifQLable {
        SwifQLableParts(parts: self.parts).not.between(part)
    }
}
