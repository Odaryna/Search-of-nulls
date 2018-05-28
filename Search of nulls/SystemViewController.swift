//
//  SystemViewController.swift
//  Search of nulls
//
//  Created by Odaryna on 5/20/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Cocoa
import CorePlot

class SystemViewController: NSViewController {

    var graph: CPTGraph!
    var twoDimensionalModel: TwoDimensionalModel!
    
    private var maxFunctionPadding : Int = 200
    private var minFunctionPadding : Int = -200
    
    @IBOutlet weak var tableView: NSTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private func firstFunction(_ x:Double) -> Double {
        
        //return x * x
        //return 2 - x
        let const = log(2 * Double.pi)
        return (2 * x - 1) / (log(x) + const - 1)
    }
    
    private func secondFunction(_ x:Double) -> Double {
    //return x + 1
        //return 1 - x * x
        let const = log(2 * Double.pi)
        let radius = log(x) + const - 1
        return 1 - x - sqrt((2 * x - 2) * (2 * x - 2) + 4 * radius / x * 100000) / 2
    }
    
    private func systemFunction(_ x:Double, y: Double) -> Double {
        //return abs(x + y - 2) + abs(x - y + 1)
        //return abs(y - x * x) + abs(y - 1 + x * x)
        
        let const = log(2 * Double.pi)
        let f = abs(y - (2 * x - 1) / (log(x) + const - 1))
        let radius = 100000 * (log(x) + const - 1)
        let g = abs(x * y * (2 * x + y - 2) - radius)
        
        return f + g
    }
    
    @IBOutlet weak var plotView: CPTGraphHostingView!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterA2TextField: NSTextField!
    @IBOutlet weak var enterB2TextField: NSTextField!
    @IBOutlet weak var enterN2TextField: NSTextField!
    
    private func calculatePaddings() {
        var max = firstFunction(twoDimensionalModel.xPoints[0])
        for xPoint in twoDimensionalModel.xPoints {
            if firstFunction(xPoint) > max {
                max = firstFunction(xPoint)
            }
        }
        if max < Double(maxFunctionPadding) {
            maxFunctionPadding = Int(round(max) + 1.0)
        }

        var min = firstFunction(twoDimensionalModel.xPoints[0])
        for xPoint in twoDimensionalModel.xPoints {
            if firstFunction(xPoint) < min {
                min = xPoint
            }
        }
        if min > Double(minFunctionPadding) {
            minFunctionPadding = Int(floor(min) - 1.0)
        }
    }
    
    @IBAction func calculateTapped(_ sender: NSButton) {
        twoDimensionalModel = TwoDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, secondStartPoint: enterATextField.doubleValue, secondEndPoint: enterBTextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), secondNumberOfSteps: Int(enterN2TextField.intValue), function:systemFunction)
        
        GraphManager.shared.modelType = .system
        GraphManager.shared.foundTwoDimensionalNulls = twoDimensionalModel.findNullsSimple()
        
        GraphManager.shared.xValues = twoDimensionalModel.xPoints
        
        var yPointsFirst = [Double]()
        for xPoint in twoDimensionalModel.xPoints {
            yPointsFirst.append(firstFunction(xPoint))
        }
        
        var yPointsSecond = [Double]()
        for xPoint in twoDimensionalModel.xPoints {
            yPointsSecond.append(secondFunction(xPoint))
        }
        
        GraphManager.shared.yValues = [PlotTypeSystem.firstFunction: yPointsFirst, PlotTypeSystem.secondFunction: yPointsSecond]
        
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
        plotSpace?.setPlotRange(CPTPlotRange(location: enterATextField.doubleValue as NSNumber, length: (twoDimensionalModel.firstEnd + fabs(enterATextField.doubleValue) as NSNumber)), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: Double(minFunctionPadding) as NSNumber, length: Double(abs(minFunctionPadding) + abs(maxFunctionPadding)) as NSNumber), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = GraphManager.shared.functionIdentifiers[0]
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.purple()
        lineStyle3.lineWidth = 1.5
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
        let plot4 = CPTScatterPlot(frame: graph.bounds)
        plot4.title = GraphManager.shared.functionIdentifiers[1]
        plot4.dataSource = self
        
        let lineStyle4 = CPTMutableLineStyle()
        lineStyle4.lineColor = CPTColor.cyan()
        lineStyle4.lineWidth = 1.5
        plot4.dataLineStyle = lineStyle4
        
        graph.add(plot4)
        
        let plotForNulls = CPTScatterPlot(frame: graph.bounds)
        plotForNulls.title = GraphManager.shared.functionIdentifiers[2]
        plotForNulls.dataSource = self
        
        let plotForNullsLineStyle = CPTMutableLineStyle()
        plotForNullsLineStyle.lineColor = CPTColor.clear()
        plotForNulls.dataLineStyle = plotForNullsLineStyle
        
        graph.add(plotForNulls)
        
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = CPTColor.red()
        let plotSymbol = CPTPlotSymbol()
        plotSymbol.symbolType = .ellipse
        plotSymbol.fill = CPTFill(color: .red())
        plotSymbol.lineStyle = symbolLineStyle
        plotSymbol.size = CGSize(width: 5.0, height: 5.0)
        plotForNulls.plotSymbol = plotSymbol
        
        graph.legendAnchor = .topLeft
        graph.legend = CPTLegend(graph: graph)
        graph.legend?.fill = CPTFill(color: .white())
        graph.legendDisplacement = CGPoint(x: 40.0, y: -40.0)
        graph.legend?.numberOfRows = 3
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

    override func viewWillDisappear() {
        GraphManager.shared.resetValues()
    }
}

extension SystemViewController: CPTPlotDataSource {
    
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

extension SystemViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return GraphManager.shared.foundTwoDimensionalNulls.count
    }
}

extension SystemViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let XCell = "XCellID"
        static let YCell = "YCellID"
        static let FCell = "FCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        // 1
        let item = GraphManager.shared.foundTwoDimensionalNulls[row]
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = String(format:"%.5f", item.x)
            cellIdentifier = CellIdentifiers.XCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(format:"%.5f", item.y)
            cellIdentifier = CellIdentifiers.YCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(format:"%.5f", item.f)
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

