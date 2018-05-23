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
    var nullsFound: [FoundTwoDimensionalNull]? = nil
    
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
        return x * x - 2 * x + sin(x + y)
    }
    
    @IBOutlet weak var plotView: CPTGraphHostingView!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterA2TextField: NSTextField!
    @IBOutlet weak var enterB2TextField: NSTextField!
    
    private func calculatePaddings() {
        var max = nullsFound![0].x
        for null in nullsFound! {
            if null.x > max {
                max = null.x
            }
        }
        if max < Double(maxFunctionPadding) {
            maxFunctionPadding = Int(round(max) + 1.0)
        }
        
        var min = nullsFound![0].x
        for null in nullsFound! {
            if null.x < min {
                min = null.x
            }
        }
        if min > Double(minFunctionPadding) {
            minFunctionPadding = Int(floor(min) - 1.0)
        }
    }
    
    @IBAction func calculateTapped(_ sender: NSButton) {
        twoDimensionalModel = TwoDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, secondStartPoint: enterA2TextField.doubleValue, secondEndPoint: enterB2TextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), function:function)
        
        nullsFound = twoDimensionalModel.findNullsSimple()
        tableView.reloadData()
        
        if (nullsFound?.count)! > 0 {
            calculatePaddings()
        }
        
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = CGFloat(maxFunctionPadding)
        graph.plotAreaFrame?.paddingBottom = CGFloat(minFunctionPadding)
        graph.plotAreaFrame?.paddingRight = CGFloat(enterATextField.doubleValue)
        graph.plotAreaFrame?.paddingLeft = CGFloat(twoDimensionalModel.firstEnd)
        
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
        plotSpace?.setPlotRange(CPTPlotRange(location: enterATextField.doubleValue as NSNumber, length: (twoDimensionalModel.firstEnd + fabs(enterATextField.doubleValue) as NSNumber)), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: Double(minFunctionPadding) as NSNumber, length: Double(abs(minFunctionPadding) + abs(maxFunctionPadding)) as NSNumber), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = "First function"
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.blue()
        lineStyle3.lineWidth = 1.5
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
    }
}

extension TwoVariablesViewController: CPTPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt((nullsFound?.count)!)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        guard
            let field =  CPTScatterPlotField(rawValue: Int(field))
            
            else {
                return nil
        }
        
        let number:Int = Int(record)
        
        switch field {
        case .X:
            return nullsFound![number].x
        case .Y:
            return nullsFound![number].y
        }
    }
}

extension TwoVariablesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return nullsFound?.count ?? 0
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
        guard let item = nullsFound?[row] else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = String(format:"%.6f", item.x)
            cellIdentifier = CellIdentifiers.XCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(format:"%.6f", item.y)
            cellIdentifier = CellIdentifiers.FCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(format:"%.6f", item.f)
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

