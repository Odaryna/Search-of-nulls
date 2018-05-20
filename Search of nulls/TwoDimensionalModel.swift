//
//  TwoDimensionalModel.swift
//  Search of nulls
//
//  Created by Odaryna on 4/22/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

struct FoundTwoDimensionalNull {
    let x: Double
    let y: Double
    let f: Double
}

class TwoDimensionalModel {
    
    typealias FoundedNull = (Double, Double, Double)
    
    struct FixedOneDimensionalModel {
        let fixedValue: Double
        let model: OneDimensionalModel
    }
    
    var firstStart: Double
    let firstEnd: Double
    var secondStart: Double
    let secondEnd: Double
    let numberOfSteps: Int
    
    let twoDimensionalFunction:(Double, Double) -> Double
    
    lazy var xPoints:[Double] = Array.init(repeating: 0.0, count: numberOfSteps + 1)
    
    lazy var step:Double = abs((secondEnd - secondStart) / Double(numberOfSteps))

    init(startPoint a1:Double, endPoint b1:Double, secondStartPoint a2:Double, secondEndPoint b2:Double,  numberOfSteps n:Int, function f:@escaping (Double, Double) -> Double) {
        firstStart = a1
        firstEnd = b1
        secondStart = a2
        secondEnd = b2
        numberOfSteps = n
        twoDimensionalFunction = f
        
        var index = 0
        
        for pointX in stride(from: a1, to: b1, by: step) {
            xPoints[index] = pointX
            index += 1
        }
    }
    
    func findNulls() -> [FoundTwoDimensionalNull] {
        let nulls : [FoundTwoDimensionalNull] = []
        
        return nulls
    }
    
    func findNullsSimple() -> [FoundTwoDimensionalNull] {
        var nulls : [FoundTwoDimensionalNull] = []
        
        while firstStart <= firstEnd {
            
            let oneDimensionalModel = OneDimensionalModel(startPoint: secondStart, endPoint: secondEnd, numberOfSteps: numberOfSteps) { x -> Double in
                return self.twoDimensionalFunction(self.firstStart , x)
            }
            
            let foundNulls = oneDimensionalModel.findNullsSimple()
            
            for foundNull in foundNulls {
                nulls.append(FoundTwoDimensionalNull(x: firstStart, y: foundNull.x, f: foundNull.y))
            }
            firstStart += step
        }
        
        return nulls
    }
    
    private func setupModells() {

    }
}
