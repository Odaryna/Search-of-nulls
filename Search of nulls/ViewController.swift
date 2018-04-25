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
    var nullsFound: [FoundNull]? = nil
    
    private var maxFunctionPadding : Int = 10
    private var minFunctionPadding : Int = -10
    
    @IBOutlet weak var tableView: NSTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private func function(_ x:Double) -> Double {
        return 16 * x * x * x * x * x - 20 * x * x * x + 5 * x
        //return 2 * x * x - 1
        //return x * sin(x)
        
        //return x * x * x + 3 * x * x - 1
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
                min = xPoint
            }
        }
        if min > Double(minFunctionPadding) {
            minFunctionPadding = Int(floor(min) - 1.0)
        }
    }
    
    @IBAction func calculateAction(_ sender: NSButton) {
        
        oneDimensionalModel = OneDimensionalModel(startPoint: enterATextField.doubleValue, endPoint: enterBTextField.doubleValue, numberOfSteps: Int(enterNTextField.intValue), function: function)
         nullsFound = oneDimensionalModel.findNullsSimple()
        tableView.reloadData()
        calculatePaddings()
        
        graph = CPTXYGraph(frame: NSRectToCGRect(plotView.bounds))
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        
        graph.apply(theme)
        plotView.hostedGraph = graph
        
        graph.plotAreaFrame?.paddingTop = CGFloat(maxFunctionPadding)
        graph.plotAreaFrame?.paddingBottom = CGFloat(minFunctionPadding)
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
        plotSpace?.setPlotRange(CPTPlotRange(location: enterATextField.doubleValue as NSNumber, length: (oneDimensionalModel.end + fabs(enterATextField.doubleValue) as NSNumber)), for: .X)
        plotSpace?.setPlotRange(CPTPlotRange(location: Double(minFunctionPadding) as NSNumber, length: Double(abs(minFunctionPadding) + abs(maxFunctionPadding)) as NSNumber), for: .Y)
        
        let plot3 = CPTScatterPlot(frame: graph.bounds)
        plot3.title = "Function"
        plot3.dataSource = self
        
        let lineStyle3 = CPTMutableLineStyle()
        lineStyle3.lineColor = CPTColor.blue()
        lineStyle3.lineWidth = 2.0
        plot3.dataLineStyle = lineStyle3
        
        graph.add(plot3)
        
    }

    @IBOutlet weak var enterNTextField: NSTextField!
    @IBOutlet weak var enterBTextField: NSTextField!
    @IBOutlet weak var enterATextField: NSTextField!
    @IBOutlet var plotView: CPTGraphHostingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search of zeros"
        
    }

    override var representedObject: Any? {
        didSet {
            
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
            return function(oneDimensionalModel.xPoints[number])
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return nullsFound?.count ?? 0
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


