//
//  HybridOperator.swift
//  
//
//  Created by TierraCero on 5/30/23.
//

import Foundation

extension SwifQLHybridOperator {
    
    public typealias HybridResult = SwifQLHybridOperator
    
    public static var random: HybridResult { .init("random()".operator, "rand()".operator) }
    
    private func concatWith(_ hybrid: HybridResult) -> HybridResult {
        return hybrid
    }
}
extension String {
    fileprivate var `operator`: SwifQLPartOperator { .init(self) }
}
