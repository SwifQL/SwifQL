//
//  HibridOperator.swift
//  
//
//  Created by TierraCero on 5/30/23.
//

import Foundation

extension SwifQLHibridOperator {
    
    public typealias HibridResult = SwifQLHibridOperator
    
    public static var random: HibridResult { .init("random()".operator, "rand()".operator) }
    
    private func concatWith(_ hibrid: HibridResult) -> HibridResult {
        return hibrid
    }
}
extension String {
    fileprivate var `operator`: SwifQLPartOperator { .init(self) }
}
