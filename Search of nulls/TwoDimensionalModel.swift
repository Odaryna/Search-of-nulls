//
//  TwoDimensionalModel.swift
//  Search of nulls
//
//  Created by Odaryna on 4/22/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

class TwoDimensionalModel {
    
    typealias FoundedNull = (Double, Double, Double)
    
    struct FixedOneDimensionalModel {
        let fixedValue: Double
        let model: OneDimensionalModel
    }
    
    let firstStart: Double
    let firstEnd: Double
    let secondStart: Double
    let secondEnd: Double
    let numberOfSteps: Int
    
    let twoDimensionalFunction:(Double, Double) -> Double
    
    lazy var step:Double = abs((secondEnd - secondStart) / Double(numberOfSteps))

    init(startPoint a1:Double, endPoint b1:Double, secondStartPoint a2:Double, secondEndPoint b2:Double,  numberOfSteps n:Int, function f:@escaping (Double, Double) -> Double) {
        firstStart = a1
        firstEnd = b1
        secondStart = a2
        secondEnd = b2
        numberOfSteps = n
        twoDimensionalFunction = f
        
        setupModells()
    }
    
    func findNulls() -> [FoundedNull] {
        let nulls : [FoundedNull] = []
        
        return nulls
    }
    
    func findNullsSimple() -> [FoundedNull] {
        let nulls : [FoundedNull] = []
        
        return nulls
    }
    
    private func setupModells() {
        
    }
}
