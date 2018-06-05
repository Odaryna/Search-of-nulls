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
    
    private var maxFunctionPadding : Int = 10
    private var minFunctionPadding : Int = -10
    
    @IBOutlet weak var tableView: NSTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private func function(_ x:Double) -> Double {
        //return sin(x) + cos(sqrt(3.0) * x)
        //return 16 * x * x * x * x * x - 20 * x * x * x + 5 * x
        //return 2 * x * x - 1
        //return x * sin(x)
        
        //return x * x * x + 3 * x * x - 1
        
        //return abs(x - 1)
        //return sqrt(x-2)
        
        //return pow(x-5, 8)
        
        return log(2 * x)
    }
    
    private func calculatePaddings() {
        var max = function(oneDimensionalModel.xPoints[0])
        for xPoint in oneDimensionalModel.xPoints {
            if function(xPoint) > max {
                max = function(xPoint)
            }
        }
        if max < Double(maxFunctionPadding) {
            maxFunctionPadding = Int(round(max) + 1.0)
        }
        
        var min = function(oneDimensionalModel.xPoints[0])
        for xPoint in oneDimensionalModel.xPoints {
            if function(xPoint) < min {
                min = function(xPoint)
            }
        }
        if min > Double(minFunctionPadding) {
            minFunctionPadding = Int(floor(min) - 1.0)
        }
    }
    
    @IBAction func calculateAction(_ sender: NSButton) {
        
        oneDimensionalModel = OneDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), function: function)
        
        GraphManager.shared.modelType = .dimensional
        let nullsFound = oneDimensionalModel.findNullsSimple()
        
        GraphManager.shared.foundTwoDimensionalNulls = []
        
        for foundNull in nullsFound {        GraphManager.shared.foundTwoDimensionalNulls.append(FoundTwoDimensionalNull(oneDimensional:foundNull))
        }
        
        GraphManager.shared.xValues = oneDimensionalModel.xPoints

        var yPoints = [Double]()
        for xPoint in oneDimensionalModel.xPoints {
            yPoints.append(function(xPoint))
        }
        
        GraphManager.shared.yValues = [PlotTypeSystem.firstFunction: yPoints]
        
        tableView.reloadData()
        calculatePaddings()
        
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = CGFloat(maxFunctionPadding + 20)
        graph.plotAreaFrame?.paddingBottom = CGFloat(minFunctionPadding + 20)
        graph.plotAreaFrame?.paddingRight = CGFloat(enterATextField.doubleValue + 20)
        graph.plotAreaFrame?.paddingLeft = CGFloat(enterBTextField.doubleValue + 10.0)
        
        graph.plotAreaFrame?.cornerRadius = 5.0
        
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 10
        textStyle.color = CPTColor.darkGray()
        
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
        plotSpace?.setPlotRange(CPTPlotRange(location: enterATextField.doubleValue as NSNumber, length: enterBTextField.doubleValue - enterATextField.doubleValue as NSNumber), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: Double(minFunctionPadding) as NSNumber, length: Double(abs(minFunctionPadding) + abs(maxFunctionPadding)) as NSNumber), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = GraphManager.shared.functionIdentifiers[0]
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.blue()
        lineStyle3.lineWidth = 1.5
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
        let plotForNulls = CPTScatterPlot(frame: graph.bounds)
        plotForNulls.title = GraphManager.shared.functionIdentifiers[1]
        plotForNulls.dataSource = self
        
        let plotForNullsLineStyle = CPTMutableLineStyle()
        plotForNullsLineStyle.lineColor = CPTColor.clear()
        plotForNulls.dataLineStyle = plotForNullsLineStyle
        
        graph.add(plotForNulls)
        
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = CPTColor.green()
        let plotSymbol = CPTPlotSymbol()
        plotSymbol.symbolType = .ellipse
        plotSymbol.fill = CPTFill(color: .green())
        plotSymbol.lineStyle = symbolLineStyle
        plotSymbol.size = CGSize(width: 5.0, height: 5.0)
        plotForNulls.plotSymbol = plotSymbol
        
        graph.legendAnchor = .topLeft
        graph.legend = CPTLegend(graph: graph)
        graph.legend?.fill = CPTFill(color: .white())
        graph.legendDisplacement = CGPoint(x: 40.0, y: -40.0)
        graph.legend?.numberOfRows = 2
        let titleStyle = CPTMutableTextStyle()
        
        titleStyle.color = CPTColor.darkGray()
        titleStyle.fontSize = 10.0
        graph.legend?.textStyle = titleStyle
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0.75
        lineStyle.lineColor = CPTColor(genericGray: 0.45)
        
        graph.legend?.borderLineStyle = lineStyle
        graph.legend?.cornerRadius = 5.0
        
    }

    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet var plotView: CPTGraphHostingView!
    
    override func viewWillDisappear() {
        GraphManager.shared.resetValues()
    }

}

extension ViewController: CPTPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return GraphManager.shared.numberOfRecords(title: plot.title!)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        guard
            let title = plot.title,
            let field =  CPTScatterPlotField(rawValue: Int(field))
            
            else {
                return nil
        }
        switch field {
        case .X:
            return GraphManager.shared.xValueForPlot(title, with: record)
        case .Y:
            return GraphManager.shared.yValueForPlot(title, with: record)
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return GraphManager.shared.foundTwoDimensionalNulls.count
    }
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let XCell = "XCellID"
        static let FCell = "FCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        // 1
        let item = GraphManager.shared.foundTwoDimensionalNulls[row]
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = String(format:"%.6f", item.x)
            cellIdentifier = CellIdentifiers.XCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(format:"%.6f", item.y)
            cellIdentifier = CellIdentifiers.FCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.textField?.alignment = .center
            return cell
        }
        return nil
    }
    
}


