//
//  ViewController.swift
//  Chart-test
//
//  Created by Kai on 2019/7/6.
//  Copyright © 2019 AppCode. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [2.0, 4.0, 6.0, 10.0, 12.0, 16.0, 24.0, 28.0, 32.0, 40.0, 50.0, 90.0, 4.0, 6.0, 10.0, 12.0, 16.0, 24.0, 28.0, 32.0, 40.0, 50.0, 90.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.viewDidLoad()
    }
    
    @IBAction func btnShowChart(_ sender: Any) {
        setChart(dataPoint: months, value: unitsSold)

    }
    func setChart(dataPoint: [String], value: [Double]) {
        
//        lineChartView = LineChartView()
        
        
        // 無資料時顯示文字
//        barChartView.noDataText = "You need to provide data for the chart."
        
        // 存放資料的陣列，Type : BarChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        // 載入每筆資料內容
        for i in 0..<dataPoint.count {
            // X, Y 座標顯示東西
            let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i])
            // 把entry放入
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Test Chart")
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
    }

}

