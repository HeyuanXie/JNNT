//
//  QNChartsTool.swift
//  SleepCare
//
//  Created by haijie on 15/12/18.
//  Copyright © 2015年 juxi. All rights reserved.
//

import Foundation
import UIKit
//制作图表工具
class QNChartsTool: NSObject {
    
}
//折线图
extension QNChartsTool {
    class func configeLineChart(lineChartView : LineChartView) {
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.pinchZoomEnabled = true          //缩放形式
        lineChartView.drawGridBackgroundEnabled = false // 绘制网格
    }
    class func dataRefreshLineChart(lineChartView : LineChartView,dataPoints: [String], values: [Double]) {
        let yVals1 = NSMutableArray()
        for var i = 0; i < values.count; i++
        {
            yVals1.addObject(ChartDataEntry(value: values[i], xIndex: i))
        }
        let yVals2 = NSMutableArray()
        for var i = 0; i < values.count; i++
        {
            yVals2.addObject(ChartDataEntry(value: values[i] + 5, xIndex: i))
        }
        
        let set1 = LineChartDataSet(yVals: yVals1 as? Array, label: "one")
        set1.axisDependency = .Left;
        set1.setColor(UIColor.blackColor())
        set1.setCircleColor(UIColor.blueColor())
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        set1.fillAlpha = 65/255.0;
        set1.fillColor = UIColor.grayColor()
        set1.highlightColor = UIColor.clearColor()
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(yVals: yVals2 as? Array, label: "two")
        let dataSets = NSMutableArray()
        dataSets.addObject(set1)
        dataSets.addObject(set2)
        let data = LineChartData(xVals: dataPoints, dataSets: dataSets as? Array)
        lineChartView.data = data;
    }
    class func configAxisLineChart(lineChartView : LineChartView) {
        let xAxis = lineChartView.xAxis;
        xAxis.labelPosition = .Bottom //x轴坐标位置
        xAxis.labelFont = UIFont.systemFontOfSize(10)
        xAxis.drawGridLinesEnabled = false // 绘制网格
        xAxis.spaceBetweenLabels = 0
        
        let leftAxis = lineChartView.leftAxis //y轴
        leftAxis.labelFont = UIFont.systemFontOfSize(10)
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter?.negativeSuffix = " $";
        leftAxis.valueFormatter?.positiveSuffix = " $"; //字段后缀
        leftAxis.labelPosition = .OutsideChart;
        leftAxis.drawGridLinesEnabled = false // 绘制网格
        lineChartView.rightAxis.enabled = false
    }
}
//柱状图
extension QNChartsTool {
    class func getBarChart(frame: CGRect) -> BarChartView{
        let barChartTmp = BarChartView()
        barChartTmp.frame = frame
        return barChartTmp
    }
    class func configeBarChart(barChartView : BarChartView) {
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.descriptionText = "jie test"
        barChartView.setDescriptionTextPosition(x: 320, y: 0)
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce) //动画
        barChartView.legend.enabled = false            //对象颜色说明
        barChartView.pinchZoomEnabled = false          //缩放形式
        barChartView.drawGridBackgroundEnabled = false // 绘制网格
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
    }
    class func dataRefreshBarChart(barChartView : BarChartView,dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.colors = ChartColorTemplates.colorful()//每一柱的颜色 [UIColor]
        
        var dataEntriesTwo: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntriesTwo.append(dataEntry)
        }
        let chartDataSetTwo = BarChartDataSet(yVals: dataEntriesTwo, label: "Units SoldTwo")
        chartDataSetTwo.drawValuesEnabled = false
        chartDataSet.colors = ChartColorTemplates.colorful()//每一柱的颜色 [UIColor]
        let chartData = BarChartData(xVals: dataPoints, dataSets: [chartDataSet,chartDataSetTwo])
        chartData.highlightEnabled = false  // 点击不高亮
        barChartView.data = chartData
        
    }
    class func configeAxisBarChart(barChartView : BarChartView) {
        let xAxis = barChartView.xAxis;
        xAxis.labelPosition = .Bottom //x轴坐标位置
        xAxis.labelFont = UIFont.systemFontOfSize(10)
        xAxis.drawGridLinesEnabled = false
        xAxis.spaceBetweenLabels = 0
        xAxis.drawGridLinesEnabled = false
        let leftAxis = barChartView.leftAxis //y轴
        leftAxis.labelFont = UIFont.systemFontOfSize(10)
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter?.negativeSuffix = " $";
        leftAxis.valueFormatter?.positiveSuffix = " $"; //字段后缀
        leftAxis.labelPosition = .OutsideChart;
        barChartView.rightAxis.enabled = false
    }
}