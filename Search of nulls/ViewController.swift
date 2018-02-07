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
    
    @IBOutlet var plotView: CPTGraphHostingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = 10.0
        graph.plotAreaFrame?.paddingBottom = 20.0
        graph.plotAreaFrame?.paddingRight = 10.0
        graph.plotAreaFrame?.paddingLeft = 20.0
        
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 12
        
        let axisSet: CPTXYAxisSet = graph.axisSet as! CPTXYAxisSet
        
        let xAxis = axisSet.xAxis
        xAxis?.majorIntervalLength = 0.5
        xAxis?.labelingPolicy = .fixedInterval
        xAxis?.labelTextStyle = textStyle
        
        let yAxis = axisSet.yAxis
        yAxis?.majorIntervalLength = 5
        yAxis?.labelingPolicy = .fixedInterval
        yAxis?.labelTextStyle = textStyle
        
        let plotSpace = graph.defaultPlotSpace
        plotSpace?.setPlotRange(CPTPlotRange(location: -1.5, length: 3.0), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: 0, length: 5), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = "Function"
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.blue()
        lineStyle3.lineWidth = 2.0
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
        graph.legendAnchor = .topLeft
        graph.legend = CPTLegend(graph: graph)
        graph.legend?.fill = CPTFill(color: .white())
        graph.legendDisplacement = CGPoint(x: -20.0, y: -30.0)
        let titleStyle = CPTMutableTextStyle()
        
        titleStyle.color = CPTColor.lightGray()
        titleStyle.fontSize = 11.0
        graph.legend?.textStyle = titleStyle
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0.75
        lineStyle.lineColor = CPTColor(genericGray: 0.45)
        
        graph.legend?.borderLineStyle = lineStyle
        graph.legend?.cornerRadius = 5.0
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: CPTPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 10
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        guard let title = plot.title,
            let field =  CPTScatterPlotField(rawValue: Int(field))
            
            else {
                return nil
        }
        
        switch field {
        case .X:
            return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        case .Y:
            return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        }
    }
}


