//
//  GraphManager.swift
//  Search of nulls
//
//  Created by Odaryna on 5/28/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Foundation

enum PlotTypeDimensional : String {
    case function = "f(x)=ln(2x)"
}

enum PlotTypeSystem : String {
    case firstFunction = "f(x)=〖(x-2)〗^2"
    case secondFunction = "f(x)=x"
}

enum PlotTypeTwoDimensional : String {
    case zeroes = "Zeroes"
}

enum ModelType {
    case dimensional
    case system
    case twodimensional
}


class GraphManager {
    
    static let shared = GraphManager()
    
    lazy var modelType : ModelType = .dimensional
    
    var functionIdentifiers : [String] {
        if modelType == .dimensional {
            return [PlotTypeDimensional.function.rawValue, PlotTypeTwoDimensional.zeroes.rawValue]
        } else if modelType == .system {
            return [PlotTypeSystem.firstFunction.rawValue,
                    PlotTypeSystem.secondFunction.rawValue,
                    PlotTypeTwoDimensional.zeroes.rawValue]
        } else {
            return [PlotTypeTwoDimensional.zeroes.rawValue]
        }
    }
    
    var xValues = [Double]()
    var yValues = [PlotTypeSystem: [Double]]()
    
    var foundTwoDimensionalNulls = [FoundTwoDimensionalNull]()
    
    // MARK: public

    func resetValues() {
        xValues = []
        yValues = [:]
        foundTwoDimensionalNulls = []
    }
    
    func numberOfRecords(title : String) -> UInt {
        
        if title == PlotTypeTwoDimensional.zeroes.rawValue {
            return UInt(foundTwoDimensionalNulls.count)
        } else {
            return UInt(xValues.count)
        }
    }
    
    func xValueForPlot(_ title: String, with record: UInt) -> NSNumber {
        
        if title == PlotTypeTwoDimensional.zeroes.rawValue {
            return foundTwoDimensionalNulls[Int(record)].x as NSNumber
        } else {
            return xValues[Int(record)] as NSNumber
        }
    }
    
    func yValueForPlot(_ title: String, with record: UInt) -> NSNumber {
        
        switch modelType {
        case .dimensional:
            if title == PlotTypeTwoDimensional.zeroes.rawValue {
                return foundTwoDimensionalNulls[Int(record)].f as NSNumber
            } else {
                return yValues[PlotTypeSystem.firstFunction]![Int(record)] as NSNumber
            }
            
        case .system:
            if title == PlotTypeTwoDimensional.zeroes.rawValue {
                return foundTwoDimensionalNulls[Int(record)].y as NSNumber
            } else if title == PlotTypeSystem.firstFunction.rawValue {
                return yValues[PlotTypeSystem.firstFunction]![Int(record)] as NSNumber
            } else {
                return yValues[PlotTypeSystem.secondFunction]![Int(record)] as NSNumber
            }
        case .twodimensional:
            return foundTwoDimensionalNulls[Int(record)].f as NSNumber
        }
    }
}
