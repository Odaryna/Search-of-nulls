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
    
    init(oneDimensional null: FoundNull) {
        self.init(x: null.x, y: 0.0, f: null.y)
    }
    
    init(x :Double, y:Double, f:Double) {
        self.x = x
        self.y = y
        self.f = f
    }
}

class TwoDimensionalModel {
    
    typealias FoundedNull = (Double, Double, Double)

    var firstStart: Double
    let firstEnd: Double
    var secondStart: Double
    let secondEnd: Double
    let numberOfSteps: Int
    let secondNumberOfSteps: Int
    
    let twoDimensionalFunction:(Double, Double) -> Double
    
    lazy var xPoints:[Double] = Array.init(repeating: 0.0, count: numberOfSteps + 1)
    
    lazy var step:Double = abs((firstEnd - firstStart) / Double(numberOfSteps))
    lazy var secondStep:Double = abs((secondEnd - secondStart) / Double(numberOfSteps))

    init(startPoint a1:Double, endPoint b1:Double, secondStartPoint a2:Double, secondEndPoint b2:Double,  numberOfSteps n:Int, secondNumberOfSteps m:Int , function f:@escaping (Double, Double) -> Double) {
        firstStart = a1
        firstEnd = b1
        secondStart = a2
        secondEnd = b2
        numberOfSteps = n
        secondNumberOfSteps = m
        twoDimensionalFunction = f
        
        var index = 0
        
        for pointX in stride(from: a1, to: b1 + step, by: step) {
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
        
        for xPoint in xPoints {
            
            let oneDimensionalModel = OneDimensionalModel(startPoint: secondStart, endPoint: secondEnd, numberOfSteps: secondNumberOfSteps) { [unowned self] x -> Double in
                return self.twoDimensionalFunction(xPoint, x)
            }
            
            let foundNulls = oneDimensionalModel.findNullsSimple()
            for foundNull in foundNulls {
                nulls.append(FoundTwoDimensionalNull(x: xPoint, y: foundNull.x, f: foundNull.y))
            }
        }
        
        return nulls
    }
    
    private func setupModells() {

    }
}
