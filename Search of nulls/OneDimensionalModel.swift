//
//  OneDimensionalModel.swift
//  Search of nulls
//
//  Created by Odaryna on 2/9/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

struct FoundNull {
    let x: Double
    let y: Double
}

class OneDimensionalModel {
    
    var start:Double
    let end:Double
    let numberOfSteps:Int
    let function:(Double)->Double
    
    lazy var xPoints = [Double]()
    
    lazy var step:Double = abs((end - start) / Double(numberOfSteps))
    
    init(startPoint a:Double, endPoint b:Double, numberOfSteps n:Int, function f:@escaping (Double) -> Double) {
        
        start = a
        end = b
        numberOfSteps = n
        function = f

        for pointX in stride(from: a, to: b + step, by: step) {
            xPoints.append(pointX)
        }
    }
    
    func findNullsSimple() -> [FoundNull] {
        var nulls: [FoundNull] = []
        
        if abs(function(start)) < step {
            nulls.append(FoundNull(x: start, y: function(start)))
        } else if abs(function(end)) < step {
            nulls.append(FoundNull(x: end, y: function(end)))
        }
        
        while start < end {
            
            let ri = pow((1 + abs(function(start))) / (1 + abs(function(start + step))), 1 / step)
            let ri1 = pow((1 + abs(function(start + 2 * step))) / (1 + abs(function(start + 3 * step))), 1 / step)

            if ri > 1.0 && ri1 < 1.0 {

                if (step > 0.0001) {
                    step /= 2
                    start -= step
                } else {
                    if abs(function((2 * start + step) / 2)) < 0.01 {
                        nulls.append(FoundNull(x: (2 * start + step) / 2, y: function((2 * start + step) / 2)))
                    }
                    step = abs((xPoints.last! - xPoints.first!) / Double(numberOfSteps))
                }
            } else if fabs(ri - 1.0) <= Double.ulpOfOne {

                if (step > 0.0001) {
                    step /= 2
                    start -= step
                } else {
                    if abs(function((2 * start - step) / 2)) < 0.01 {
                        nulls.append(FoundNull(x: (2 * start - step) / 2, y: function((2 * start - step) / 2)))
                    }
                    step = abs((xPoints.last! - xPoints.first!) / Double(numberOfSteps))
                }
            }
            
            start += step
        }
        
        
        return nulls
    }
    
}
