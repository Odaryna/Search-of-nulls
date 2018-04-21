//
//  ViewController.swift
//  Search of nulls
//
//  Created by Odaryna on 11/2/17.
//  Copyright © 2017 Odaryna. All rights reserved.
//

import Cocoa
import CorePlot

class ViewController: NSViewController {
    
    var graph: CPTGraph!
    var oneDimensionalModel: OneDimensionalModel!
    var nullsFound: [Double]!
    
    private func function(_ x:Double) -> Double {
        //return 16 * x * x * x * x * x - 20 * x * x * x + 5 * x
        //return x * sin(x)
        //return 8 * x * x * x * x - 8 * x * x + 1
        //return 4 * x * x * x - 3 * x
        return 2 * x * x - 1
    }
    
    @IBAction func calculateAction(_ sender: NSButton) {
        

        
        oneDimensionalModel = OneDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), function: function)
        
        
        
        
//        { x in
//            16 * x * x * x * x * x - 20 * x * x * x + 5 * x
//        }
        nullsFound = oneDimensionalModel.findNullsSimple()
        
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = 2.0
        graph.plotAreaFrame?.paddingBottom = -2.0
        graph.plotAreaFrame?.paddingRight = CGFloat(enterATextField.doubleValue)
        graph.plotAreaFrame?.paddingLeft = CGFloat(oneDimensionalModel.end)
        
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 12
        
        let axisSet: CPTXYAxisSet = graph.axisSet as! CPTXYAxisSet
        
        let xAxis = axisSet.xAxis
        xAxis?.majorIntervalLength = 1.0
        xAxis?.labelingPolicy = .fixedInterval
        xAxis?.labelTextStyle = textStyle
        
        let yAxis = axisSet.yAxis
        yAxis?.majorIntervalLength = 1.0
        yAxis?.labelingPolicy = .fixedInterval
        yAxis?.labelTextStyle = textStyle
        
        let plotSpace = graph.defaultPlotSpace
        plotSpace?.setPlotRange(CPTPlotRange(location: enterATextField.doubleValue as NSNumber, length: (oneDimensionalModel.end + 5.0 as NSNumber)), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: -2, length: 4), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = "Function"
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.blue()
        lineStyle3.lineWidth = 2.0
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
//        graph.legendAnchor = .topLeft
//        graph.legend = CPTLegend(graph: graph)
//        graph.legend?.fill = CPTFill(color: .white())
//        graph.legendDisplacement = CGPoint(x: -20.0, y: -30.0)
//        let titleStyle = CPTMutableTextStyle()
//
//        titleStyle.color = CPTColor.lightGray()
//        titleStyle.fontSize = 11.0
//        graph.legend?.textStyle = titleStyle
//
//        let lineStyle = CPTMutableLineStyle()
//        lineStyle.lineWidth = 0.5
//        lineStyle.lineColor = CPTColor(genericGray: 0.45)
//
//        graph.legend?.borderLineStyle = lineStyle
//        graph.legend?.cornerRadius = 5.0
        
    }
    
    @IBOutlet weak var resultScrollView: NSScrollView!
    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet var plotView: CPTGraphHostingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: CPTPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(oneDimensionalModel.numberOfSteps)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        guard
            //let title = plot.title,
            let field =  CPTScatterPlotField(rawValue: Int(field))
            
            else {
                return nil
        }
        
        let number:Int = Int(record)
        
        switch field {
        case .X:
            return oneDimensionalModel.xPoints[number]
        case .Y:
            return sin(oneDimensionalModel.xPoints[number])
        }
    }
}


