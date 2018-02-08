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
    
    var xPoints:[Double] = []
    var fPoints:[Double] = []
    
    init(startPoint a:Double, endPoint b:Double, numberOfSteps n:Int, function f:(Double) -> Double) {
        
        start = a
        end = b
        numberOfSteps = n
        
        let h = (b - a) / Double(n)
        var index = 0
        
        for pointX in stride(from: a, to: b, by: h) {
            xPoints[index] = pointX
            fPoints[index] = 1 + log(f(pointX))
            index += 1
        }
    }
    
}
