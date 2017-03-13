//
//  RunDetailsCell03.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-09.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class RunDetailsCell02: UICollectionViewCell, ChartViewDelegate {
    
    // Fonts
    let titleFont = UIFont(name: "AvenirNext-Regular", size: 12)
    let titleTextColor = UIColor(r: 32, g: 32, b: 32)
    
    let valueFont = UIFont(name: "DINAlternate-bold", size: 24)
    let valueTextColor = UIColor(r: 64, g: 64, b: 64)
    
    let graphTitle: UILabel = {
        
        let label = UILabel()
        label.text = "Altitude"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var maxAltitudeTitle: UILabel = {
        
        let label = UILabel()
        label.text = "MAX ALTITUDE"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var maxAltitudeValue: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var minAltitudeTitle: UILabel = {
        
        let label = UILabel()
        label.text = "MIN ALTITUDE"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var minAltitudeValue: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var altitudeGraphView: LineChartView = {
        let view = LineChartView()
        
        view.backgroundColor = .white
        
        view.delegate = self
        
        // hide grid lines
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        
        // hide axis lines
        view.xAxis.drawAxisLineEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        view.rightAxis.drawAxisLineEnabled = true
        
        // hide labels on X axis
        view.xAxis.drawLabelsEnabled = false
        
        view.leftAxis.drawLabelsEnabled = true
        view.leftAxis.labelTextColor = self.valueTextColor

        view.rightAxis.drawLabelsEnabled = true
        view.rightAxis.labelTextColor = self.valueTextColor
        
        view.leftAxis.axisMinimum = 0
        view.rightAxis.axisMinimum = 0
        
        view.dragEnabled = false
        view.pinchZoomEnabled = false
        
        // set no data text placeholder
        view.noDataText = "No altitude data\n  to display yet"
        view.noDataFont = UIFont(name: "AvenirNext-Regular", size: 11)
        view.noDataTextColor = self.valueTextColor
        
        view.legend.enabled = false
        
        view.chartDescription?.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(graphTitle)
        addSubview(altitudeGraphView)
        addSubview(maxAltitudeTitle)
        addSubview(maxAltitudeValue)
        addSubview(minAltitudeTitle)
        addSubview(minAltitudeValue)
        
        // x, y, width, height constraints
        graphTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        graphTitle.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        graphTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        altitudeGraphView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        altitudeGraphView.topAnchor.constraint(equalTo: graphTitle.bottomAnchor, constant: 10).isActive = true
        altitudeGraphView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        altitudeGraphView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        
        // x, y, width, height constraints
        maxAltitudeTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        maxAltitudeTitle.topAnchor.constraint(equalTo: altitudeGraphView.bottomAnchor, constant: 10).isActive = true
        maxAltitudeTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        maxAltitudeTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        maxAltitudeValue.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        maxAltitudeValue.topAnchor.constraint(equalTo: maxAltitudeTitle.bottomAnchor, constant: 10).isActive = true
        maxAltitudeValue.widthAnchor.constraint(equalTo: maxAltitudeTitle.widthAnchor).isActive = true
        maxAltitudeValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        minAltitudeTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        minAltitudeTitle.topAnchor.constraint(equalTo: altitudeGraphView.bottomAnchor, constant: 10).isActive = true
        minAltitudeTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        minAltitudeTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        minAltitudeValue.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        minAltitudeValue.topAnchor.constraint(equalTo: minAltitudeTitle.bottomAnchor, constant: 10).isActive = true
        minAltitudeValue.widthAnchor.constraint(equalTo: minAltitudeTitle.widthAnchor).isActive = true
        minAltitudeValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // Line chart for elevations
    func configure(with run: Run) {
        
        var dataEntries = [ChartDataEntry]()
        var maxAltitude = run.elevations[0]
        var minAltitude = run.elevations[1]
        
        for i in 0..<run.elevations.count {
            
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(run.elevations[i]))
            dataEntries.append(dataEntry)
            
            if run.elevations[i] > maxAltitude {
                maxAltitude = run.elevations[i]
            }
            if run.elevations[i] < minAltitude {
                minAltitude = run.elevations[i]
            }
        }
        
        // update max altitude labels
        maxAltitudeValue.text = "\(maxAltitude) m"
        
        // update min altitude labels
        minAltitudeValue.text = "\(minAltitude) m"
        
        let chartDataSet: LineChartDataSet
        
        if let datSetCount = altitudeGraphView.data?.dataSetCount {
            
            if datSetCount > 0 {
                
                chartDataSet = altitudeGraphView.data?.dataSets[0] as! LineChartDataSet
                chartDataSet.values = dataEntries
                altitudeGraphView.data?.notifyDataChanged()
                altitudeGraphView.notifyDataSetChanged()
            }
        }
        else {
            
            chartDataSet = LineChartDataSet(values: dataEntries, label: "Altitude")
            chartDataSet.mode = .cubicBezier
            chartDataSet.cubicIntensity = 0.2
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.lineWidth = 1.0
            chartDataSet.setColor(UIColor(r: 153, g: 255, b: 204))
            chartDataSet.fillColor = UIColor(r: 153, g: 255, b: 204)
            chartDataSet.fillAlpha = 1.0
            chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            chartDataSet.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: chartDataSet)
            data.setDrawValues(false)
            altitudeGraphView.data = data
        }
        
        // animate graph
        altitudeGraphView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
}
