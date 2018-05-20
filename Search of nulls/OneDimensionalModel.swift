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
    
    lazy var xPoints:[Double] = Array.init(repeating: 0.0, count: numberOfSteps + 1)
    
    lazy var step:Double = abs((end - start) / Double(numberOfSteps))
    
    init(startPoint a:Double, endPoint b:Double, numberOfSteps n:Int, function f:@escaping (Double) -> Double) {
        
        start = a
        end = b
        numberOfSteps = n
        function = f

        var index = 0
        
        for pointX in stride(from: a, to: b, by: step) {
            xPoints[index] = pointX
            index += 1
        }
    }
    
    
    func findNulls() -> [Double] {
        
        var nulls: [Double] = []
        
        step = 0.1
        
        func firstStep() {
            if abs(function(start)) < step {
                
                nulls.append(start)
                forthStep()
                return
            } else if abs(function(end)) < step {
                return
            }
            start += step
            secondStep()
        }
        func secondStep() {
            
            while start < end {
                
                let fk = 1 + abs(function(start))
                let fk1 = 1 + abs(function(start + step))
                let fk2 = 1 + abs(function(start + 2 * step))
                
                let rk1 = pow(fk / fk1, 1 / step)
                let rk11 = pow(fk1 / fk2, 1 / step)
                
                if rk1 >= 1.0 && rk11 <= 1.0 {
                    
                    if step > 0.001 {
                        step /= 2
                        start -= step

                    } else {
                        if abs(function(start)) < step {
                            nulls.append(start)
                            forthStep()
                            return
                        } else {
                            thirdStep()
                            return
                        }
                    }
                }

                start += step
            }

            thirdStep()
        }
        func thirdStep() {
            
            let startingPoint = start
//            start += step
//            step = 0.1
            
            while start < end {
                
                let ril1 = (1 + abs(function(startingPoint))) / (1 + abs(function(start)))
                let ril11 = (1 + abs(function(startingPoint))) / (1 + abs(function(start + step)))
                
                if ril1 >= 1.0 && ril11 <= 1.0 {
                    
//                    if step > 0.0001 {
//                        start = startingPoint
//                        step /= 10
//                    } else {
                        if abs(function(start)) < step {
                            nulls.append(start)
                            forthStep()
                            return
                        }
                        break
 //                   }
                
                }
                start += step
            }
            
        }
        func forthStep() {
            
            step = 0.1
            start += 2.0 * step
            
            while start < end {
                
                let rik1 = 1 / (1 + abs(function(start)))
                let rik11 = 1 / (1 + abs(function(start + step)))
                
                if abs(1.0 - rik1) <= step && abs(1.0 - rik11) > step {
                    
                    if step > 0.0001 {
                        step /= 2
                        start -= step
                    } else {
                        nulls.append(start)
                        step = 0.1
                        start += 2.0 * step
                    }
                    
                }
                start += step
            }
        }
        firstStep()        
        
        return nulls
    }
    
    
    func findNullsSimple() -> [FoundNull] {
        var nulls: [FoundNull] = []
        
        while start < end {
            
            let ri = pow((1 + abs(function(start))) / (1 + abs(function(start + step))), 1 / step)
            let ri1 = pow((1 + abs(function(start + step))) / (1 + abs(function(start + 2 * step))), 1 / step)
            
            if ((ri >= 1.0 && ri1 < 1.0) || (ri > 1.0 && ri1 <= 1.0)) {
                
                if (step > 0.001) {
                    step /= 2
                    start -= step
                } else {
                    if abs(function(start + step)) < 0.01 {
                        nulls.append(FoundNull(x: start + step, y: function(start + step)))
                        step = abs((xPoints.last! - xPoints.first!) / Double(numberOfSteps))
                    }
                }
            }
            
            start += step
        }
        
        
        return nulls
    }
    
}
