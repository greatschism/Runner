//
//  RunDetailsCell02.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-09.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class RunDetailsCell01: UICollectionViewCell, ChartViewDelegate {
    
    // Fonts
    let titleFont = UIFont(name: "AvenirNext-Regular", size: 12)
    let titleTextColor = UIColor(r: 32, g: 32, b: 32)
    
    let valueFont = UIFont(name: "DINAlternate-bold", size: 24)
    let valueTextColor = UIColor(r: 64, g: 64, b: 64)
    
    let graphTitle: UILabel = {
       
        let label = UILabel()
        label.text = "Pace by Split Analysis"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    lazy var fastestSplitTitle: UILabel = {
        
        let label = UILabel()
        label.text = "FASTEST SPLIT PACE"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var fastestSplitValue: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var slowestSplitTitle: UILabel = {
        
        let label = UILabel()
        label.text = "SLOWEST SPLIT PACE"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var slowestSplitValue: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var paceGraphView: BarChartView = {
        
        let view = BarChartView()
        
        view.delegate = self
        
        view.backgroundColor = .white
        
        // hide grid lines
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        
        // hide axis lines
        view.xAxis.drawAxisLineEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        view.rightAxis.drawAxisLineEnabled = false
        
        // hide labels on axis
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        
        // set left axis minimun value to Zero (to be static)
        view.leftAxis.axisMinimum = 0
        
        view.dragEnabled = false
        view.pinchZoomEnabled = false
        
        // set no data text placeholder
        view.noDataText = "   Pace graph is displayed\nfor runs with 1 km and more"
        view.noDataFont = UIFont(name: "AvenirNext-Regular", size: 12)
        view.noDataTextColor = UIColor(r: 255, g: 55, b: 55)
        
        view.legend.enabled = false
        
        view.chartDescription?.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with run: Run) {
        
        addSubview(graphTitle)
        addSubview(paceGraphView)
        addSubview(fastestSplitTitle)
        addSubview(fastestSplitValue)
        addSubview(slowestSplitTitle)
        addSubview(slowestSplitValue)
        
        // x, y, width, height constraints
        graphTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        graphTitle.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        graphTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        paceGraphView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        paceGraphView.topAnchor.constraint(equalTo: graphTitle.bottomAnchor, constant: 10).isActive = true
        paceGraphView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        paceGraphView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        
        // x, y, width, height constraints
        fastestSplitTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        fastestSplitTitle.topAnchor.constraint(equalTo: paceGraphView.bottomAnchor, constant: 10).isActive = true
        fastestSplitTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        fastestSplitTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        fastestSplitValue.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        fastestSplitValue.topAnchor.constraint(equalTo: fastestSplitTitle.bottomAnchor, constant: 10).isActive = true
        fastestSplitValue.widthAnchor.constraint(equalTo: fastestSplitTitle.widthAnchor).isActive = true
        fastestSplitValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        slowestSplitTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        slowestSplitTitle.topAnchor.constraint(equalTo: paceGraphView.bottomAnchor, constant: 10).isActive = true
        slowestSplitTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        slowestSplitTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        slowestSplitValue.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        slowestSplitValue.topAnchor.constraint(equalTo: slowestSplitTitle.bottomAnchor, constant: 10).isActive = true
        slowestSplitValue.widthAnchor.constraint(equalTo: slowestSplitTitle.widthAnchor).isActive = true
        slowestSplitValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        updatePaceChart(with: run)
    }
    
    // Bar chart for pace of each segment
    func updatePaceChart(with run: Run) {
        
        var dataEntries = [BarChartDataEntry]()
        var fastestSplit = run.pacesBySegment[0]
        var slowestSplit = run.pacesBySegment[0]
        
        for i in 0..<run.pacesBySegment.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(run.pacesBySegment[i]))
            dataEntries.append(dataEntry)
            
            if run.pacesBySegment[i] < fastestSplit {
                fastestSplit = run.pacesBySegment[i]
            }
            if run.pacesBySegment[i] > slowestSplit {
                slowestSplit = run.pacesBySegment[i]
            }
        }

        // update fastest split labels
        fastestSplitValue.text = RawValueFormatter().getPaceString(with: fastestSplit)
        
        // update slowest split labels
        slowestSplitValue.text = RawValueFormatter().getPaceString(with: slowestSplit)
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Avg pace by segment")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let valueFormatter = ChartValueFormatter()
        chartData.setValueFormatter(valueFormatter)
        
        // Setup font for values. Show values only if ran 10 km or less (to avoid clashing value strings)
        if run.pacesBySegment.count <= 10 {
            
            chartData.setValueFont(UIFont(name: "AvenirNext-Regular", size: 14))
            chartData.setValueTextColor(valueTextColor)
        }
        else {
            
            chartData.setDrawValues(false)
        }
        
        if run.pacesBySegment.count == 1 {
            
            chartData.barWidth = chartData.barWidth / 2
        }
        
        paceGraphView.data = chartData
        
        // animate bars
        paceGraphView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
}
