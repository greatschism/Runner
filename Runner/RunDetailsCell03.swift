//
//  RunDetailsCell03.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-09.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class RunDetailsCell03: UICollectionViewCell, ChartViewDelegate {
    
    var isAlreadyShown = false
    
    // Fonts
    let titleFont = UIFont(name: "AvenirNext-Regular", size: 12)
    let titleTextColor = UIColor(r: 32, g: 32, b: 32)
    
    let valueFont = UIFont(name: "DINAlternate-bold", size: 24)
    let valueTextColor = UIColor(r: 64, g: 64, b: 64)
    
    let graphTitle: UILabel = {
        
        let label = UILabel()
        label.text = "Pace Zone Analysis"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let graphContainerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var paceZonesGraphView: BarChartView = {
        
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
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        
        view.xAxis.labelPosition = .bottom
        view.xAxis.labelTextColor = self.valueTextColor
        
        // set left axis minimun value to Zero (to be static)
        view.leftAxis.axisMinimum = 0
        
        view.dragEnabled = false
        view.pinchZoomEnabled = false
        view.doubleTapToZoomEnabled = false
        
        // set no data text placeholder
        view.noDataText = " No pace zones data\nto display for this run"
        view.noDataFont = UIFont(name: "AvenirNext-Regular", size: 12)
        view.noDataTextColor = UIColor(r: 255, g: 55, b: 55)
        
        view.legend.enabled = false
        
        view.chartDescription?.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var xUnitTitle: UILabel = {
        
        let label = UILabel()
        label.text = "X AXIS UNITS"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var xUnitValue: UILabel = {
        
        let label = UILabel()
        label.text = "min/km"
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var yUnitTitle: UILabel = {
        
        let label = UILabel()
        label.text = "Y AXIS UNITS"
        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var yUnitValue: UILabel = {
        
        let label = UILabel()
        label.text = "min"
        label.font = self.valueFont
        label.textColor = self.valueTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        addSubview(graphContainerView)
        graphContainerView.addSubview(paceZonesGraphView)
        addSubview(xUnitTitle)
        addSubview(xUnitValue)
        addSubview(yUnitTitle)
        addSubview(yUnitValue)
        
        // x, y, width, height constraints
        graphTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        graphTitle.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        graphTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        graphContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphContainerView.topAnchor.constraint(equalTo: graphTitle.bottomAnchor, constant: 10).isActive = true
        graphContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        graphContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        
        // x, y, width, height constraints
        paceZonesGraphView.centerXAnchor.constraint(equalTo: graphContainerView.centerXAnchor).isActive = true
        paceZonesGraphView.topAnchor.constraint(equalTo: graphContainerView.topAnchor).isActive = true
        paceZonesGraphView.widthAnchor.constraint(equalTo: graphContainerView.widthAnchor, constant: -10).isActive = true
        paceZonesGraphView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -10).isActive = true
        
        // x, y, width, height constraints
        xUnitTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xUnitTitle.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: 10).isActive = true
        xUnitTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        xUnitTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        xUnitValue.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xUnitValue.topAnchor.constraint(equalTo: xUnitTitle.bottomAnchor, constant: 10).isActive = true
        xUnitValue.widthAnchor.constraint(equalTo: xUnitTitle.widthAnchor).isActive = true
        xUnitValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        yUnitTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        yUnitTitle.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: 10).isActive = true
        yUnitTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        yUnitTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        yUnitValue.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        yUnitValue.topAnchor.constraint(equalTo: yUnitTitle.bottomAnchor, constant: 10).isActive = true
        yUnitValue.widthAnchor.constraint(equalTo: yUnitTitle.widthAnchor).isActive = true
        yUnitValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // Bar chart for pace zones
    func configure(with run: Run) {
        
        guard run.paceZones.count > 0 else { return }
        
        let zones = ["zoneUnder4","zone45","zone56","zone67","zone7plus"]           // TODO: find a way to not hard code this
        let zonesLabels = ["under 4'","4'-4:59'","5'-5:59'","6'-6:59'","7' or more"]
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<run.paceZones.count {
            
            guard let paceZoneValue = run.paceZones[zones[i]] else { return }
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(paceZoneValue))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Pace Zones")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let valueFormatter = ChartValueFormatter()
        chartData.setValueFormatter(valueFormatter)
        
        paceZonesGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values:zonesLabels)
        paceZonesGraphView.xAxis.granularity = 1
        
        // Setup font for values. Show values only if ran 10 km or less (to avoid clashing value strings)
        chartData.setValueFont(UIFont(name: "AvenirNext-Regular", size: 14))
        chartData.setValueTextColor(valueTextColor)
        
        paceZonesGraphView.data = chartData
        
        paceZonesGraphView.isHidden = !isAlreadyShown
    }
}
