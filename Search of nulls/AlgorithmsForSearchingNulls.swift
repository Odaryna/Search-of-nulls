//
//  AlgorithmsForSearchingNulls.swift
//  Search of nulls
//
//  Created by Odaryna on 2/10/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

func findNulls(startPoint a:Double, endPoint b:Double, numberOfSteps n:Int, points x:[Double], calculatedFPoints fPoints:[Double], function f:@escaping (Double)->Double) -> [Double] {
    
    let step = (b - a) / Double(n)
    var nulls: [Double] = []
    var i = 0
    
    func firstStep() {
        if abs(f(a)) < step {
            
            nulls.append(a)
            forthStep()
        } else if abs(f(b)) < step {
            return
        }
        secondStep()
    }
    func secondStep() {
        for k in 1..<n-1 {
            let rk1 = pow(fPoints[k] / fPoints[k + 1], 1 / step)
            let rk11 = pow(fPoints[k + 1] / fPoints[k + 2], 1 / step)
            
            if rk1 >= 1.0 && rk11 <= 1.0 {
                i = k + 1
                if abs(f(x[i])) < step {
                    nulls.append(x[i])
                    forthStep()
                } else {
                    thirdStep()
                }
            }
        }
        thirdStep()
    }
    func thirdStep() {
        for l in 1..<n - i - 1 {
            let ril1 = fPoints[i] / fPoints[i + l]
            let ril11 = fPoints[i] / fPoints[i + l + 1]
            
            if ril1 >= 1.0 && ril11 <= 1.0 {
                i += l
                if abs(f(x[i])) < step {
                    nulls.append(x[i])
                    forthStep()
                }
                break
            }
        }
    }
    func forthStep() {
        for k in 1..<n-i-1 {
            let rik1 = fPoints[i] / fPoints[i + k]
            let rik11 = fPoints[i] / fPoints[i + k + 1]
            
            if abs(1.0 - rik1) <= step && abs(1.0 - rik11) > step {
                nulls.append(x[i + k])
            }
        }
    }
    firstStep()
    
    
    return nulls
}
