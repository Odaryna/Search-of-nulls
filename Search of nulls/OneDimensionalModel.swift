//
//  OneDimensionalModel.swift
//  Search of nulls
//
//  Created by Odaryna on 2/9/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

struct OneDimensionalModel {
    
    let start:Double
    let end:Double
    let numberOfSteps:Int
    let function:(Double)->Double
    
    lazy var xPoints:[Double] = Array.init(repeating: 0.0, count: numberOfSteps + 1)
    lazy var fPoints:[Double] = Array.init(repeating: 0.0, count: numberOfSteps + 1)
    
    var step:Double {
        return abs((self.start - self.end) / Double(self.numberOfSteps))
    }
    
    init(startPoint a:Double, endPoint b:Double, numberOfSteps n:Int, function f:@escaping (Double) -> Double) {
        
        start = a
        end = b
        numberOfSteps = n
        function = f

        var index = 0
        
        for pointX in stride(from: a, to: b + step, by: step) {
            xPoints[index] = pointX
            fPoints[index] = 1 + abs(f(pointX))
            index += 1
        }
    }
    
    
    mutating func findNulls() -> [Double] {
        
        var nulls: [Double] = []
        var i = 0
        
        func firstStep() {
            if abs(function(start)) < step {
                
                nulls.append(start)
                forthStep()
            } else if abs(function(end)) < step {
                return
            }
            secondStep()
        }
        func secondStep() {
            for k in 1..<numberOfSteps-1 {
                let rk1 = pow(fPoints[k] / fPoints[k + 1], 1 / step)
                let rk11 = pow(fPoints[k + 1] / fPoints[k + 2], 1 / step)
                
                print("r1 = \(rk1) r11 = \(rk11)")
                
                if rk1 >= 1.0 && rk11 <= 1.0 {
                    i = k + 1
                    if abs(function(xPoints[i])) < step {
                        nulls.append(xPoints[i])
                        forthStep()
                        return
                    } else {
                        thirdStep()
                        return
                    }
                }
            }
            thirdStep()
        }
        func thirdStep() {
            for l in 1..<numberOfSteps - i - 1 {
                let ril1 = fPoints[i] / fPoints[i + l]
                let ril11 = fPoints[i] / fPoints[i + l + 1]
                
                if ril1 >= 1.0 && ril11 <= 1.0 {
                    i += l
                    if abs(function(xPoints[i])) < step {
                        nulls.append(xPoints[i])
                        forthStep()
                        return
                    }
                    break
                }
            }
        }
        func forthStep() {
            for k in 1..<numberOfSteps-i-1 {
                let rik1 = fPoints[i] / fPoints[i + k]
                let rik11 = fPoints[i] / fPoints[i + k + 1]
                
                if abs(1.0 - rik1) <= step && abs(1.0 - rik11) > step {
                    nulls.append(xPoints[i + k])
                }
            }
        }
        firstStep()
        
        
        return nulls
    }
    
}
