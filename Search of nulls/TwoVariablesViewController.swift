//
//  TwoVariablesViewController.swift
//  Search of nulls
//
//  Created by Odaryna on 5/23/18.
//  Copyright © 2018 Odaryna. All rights reserved.
//

import Cocoa
import CorePlot

class TwoVariablesViewController: NSViewController {

    var graph: CPTGraph!
    var twoDimensionalModel: TwoDimensionalModel!
    
    private var maxFunctionPadding : Int = 10
    private var minFunctionPadding : Int = -10
    
    @IBOutlet weak var tableView: NSTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private func function(_ x:Double, y: Double) -> Double {
        //return abs(x + y - 2) + abs(x - y + 1)
        //return abs(2 * x + y - 4) + abs(3 * x + 5 * y - 13)
        //return x * x - 2 * x + sin(x + y)
        return sin(x) * cos(y)
    }
    
    @IBOutlet weak var plotView: CPTGraphHostingView!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterA2TextField: NSTextField!
    @IBOutlet weak var enterB2TextField: NSTextField!
    @IBOutlet weak var enterN2TextField: NSTextField!
    
    
    @IBAction func calculateTapped(_ sender: NSButton) {
        twoDimensionalModel = TwoDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, secondStartPoint: enterA2TextField.doubleValue, secondEndPoint: enterB2TextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), secondNumberOfSteps: Int(enterNTextField.intValue), function:function)
        
        GraphManager.shared.modelType = .twodimensional
        GraphManager.shared.foundTwoDimensionalNulls = twoDimensionalModel.findNullsSimple()
        tableView.reloadData()
        
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = CGFloat(maxFunctionPadding)
        graph.plotAreaFrame?.paddingBottom = CGFloat(minFunctionPadding)
        graph.plotAreaFrame?.paddingRight = CGFloat(-5.0)
        graph.plotAreaFrame?.paddingLeft = CGFloat(5.0)
        
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
        
        let plotForNulls = CPTScatterPlot(frame: graph.bounds)
        plotForNulls.title = GraphManager.shared.functionIdentifiers[0]
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
        graph.legend?.numberOfRows = 1
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

extension TwoVariablesViewController: CPTPlotDataSource {
    
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

extension TwoVariablesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return GraphManager.shared.foundTwoDimensionalNulls.count
    }
}

extension TwoVariablesViewController: NSTableViewDelegate {
    
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
            text = String(format:"%.4f", item.x)
            cellIdentifier = CellIdentifiers.XCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(format:"%.4f", item.y)
            cellIdentifier = CellIdentifiers.YCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(format:"%.4f", item.f)
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

