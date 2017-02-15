//
//  InProgressRunStatsContainerView.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-13.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class InProgressRunStatsContainerView: UIView, ChartViewDelegate {
    
    let durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let durationTitle: UILabel = {
        let label = UILabel()
        label.text = "TIME"
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "DINAlternate-bold", size: 80)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let durationSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let distanceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let distanceTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.text = "DISTANCE (km)"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.text = "0.00"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "DINAlternate-bold", size: 70)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avgPaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avgPaceTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.text = "AVG PACE (/km)"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let avgPaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.text = "00:00"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "DINAlternate-bold", size: 70)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let avgPaceSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.text = "BURN (kCal)"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let calLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.text = "000"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "DINAlternate-bold", size: 70)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let calSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var graphView: BarChartView = {
        let view = BarChartView()
        
        view.delegate = self
        
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
        
        // Number formatting for YAxis
        //        view.leftAxis.valueFormatter = YAxisValueFormatter()
        
        // set no data text placeholder
        view.noDataText = "Run your first km to display splits data"
        view.noDataFont = UIFont(name: "AvenirNext-Regular", size: 14)
        view.noDataTextColor = UIColor(r: 32, g: 32, b: 32)
        
        // hide main descriptions
        view.legend.enabled = false
        view.chartDescription?.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        
        // setup sub views
        setupDurationView()
        setupDurationSeparatorView()
        setupDistanceView()
        setupDistanceSeparatorView()
        setupAvgPaceView()
        setupAvgPaceSeparatorView()
        setupCalView()
        setupCalSeparatorView()
        setupGraphView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDurationView() {
        
        self.addSubview(durationView)

        // x, y, width, height constraints
        durationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        durationView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        durationView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        durationView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
        
        setupDurationTitle()
        setupDurationLabel()
    }
    
    func setupDurationTitle() {
        
        durationView.addSubview(durationTitle)

        // x, y, width, height constraints
        durationTitle.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        durationTitle.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 5).isActive = true
        durationTitle.widthAnchor.constraint(equalTo: durationView.widthAnchor).isActive = true
        durationTitle.heightAnchor.constraint(equalTo: durationView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupDurationLabel() {
        
        durationView.addSubview(durationLabel)

        // x, y, width, height constraints
        durationLabel.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        durationLabel.topAnchor.constraint(equalTo: durationTitle.bottomAnchor, constant: -5).isActive = true
        durationLabel.widthAnchor.constraint(equalTo: durationView.widthAnchor, constant: -80).isActive = true
        durationLabel.heightAnchor.constraint(equalTo: durationView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupDurationSeparatorView() {
        
        self.addSubview(durationSeparatorView)

        // x, y, width, height constraints
        durationSeparatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        durationSeparatorView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        durationSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        durationSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.bringSubview(toFront: durationSeparatorView)
    }
    
    func setupDistanceView() {
        
        self.addSubview(distanceView)

        // x, y, width, height constraints
        distanceView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        distanceView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        distanceView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        distanceView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
        
        setupDistanceTitle()
        setupDistanceLabel()
    }
    
    func setupDistanceTitle() {
        
        distanceView.addSubview(distanceTitle)

        // x, y, width, height constraints
        distanceTitle.centerXAnchor.constraint(equalTo: distanceView.centerXAnchor).isActive = true
        distanceTitle.topAnchor.constraint(equalTo: distanceView.topAnchor, constant: 5).isActive = true
        distanceTitle.widthAnchor.constraint(equalTo: distanceView.widthAnchor).isActive = true
        distanceTitle.heightAnchor.constraint(equalTo: distanceView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupDistanceLabel() {
        
        distanceView.addSubview(distanceLabel)

        // x, y, width, height constraints
        distanceLabel.centerXAnchor.constraint(equalTo: distanceView.centerXAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: distanceTitle.bottomAnchor, constant: -5).isActive = true
        distanceLabel.widthAnchor.constraint(equalTo: distanceView.widthAnchor, constant: -40).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: distanceView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupDistanceSeparatorView() {
        
        self.addSubview(distanceSeparatorView)

        // x, y, width, height constraints
        distanceSeparatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        distanceSeparatorView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        distanceSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        distanceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.bringSubview(toFront: distanceSeparatorView)
    }
    
    func setupAvgPaceView() {
        
        self.addSubview(avgPaceView)

        // x, y, width, height constraints
        avgPaceView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        avgPaceView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        avgPaceView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        avgPaceView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
        
        setupAvgPaceTitle()
        setupAvgPaceLabel()
    }
    
    func setupAvgPaceTitle() {
        
        avgPaceView.addSubview(avgPaceTitle)

        // x, y, width, height constraints
        avgPaceTitle.centerXAnchor.constraint(equalTo: avgPaceView.centerXAnchor).isActive = true
        avgPaceTitle.topAnchor.constraint(equalTo: avgPaceView.topAnchor, constant: 5).isActive = true
        avgPaceTitle.widthAnchor.constraint(equalTo: avgPaceView.widthAnchor).isActive = true
        avgPaceTitle.heightAnchor.constraint(equalTo: avgPaceView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupAvgPaceLabel() {
        
        avgPaceView.addSubview(avgPaceLabel)

        // x, y, width, height constraints
        avgPaceLabel.centerXAnchor.constraint(equalTo: avgPaceView.centerXAnchor).isActive = true
        avgPaceLabel.topAnchor.constraint(equalTo: avgPaceTitle.bottomAnchor, constant: -5).isActive = true
        avgPaceLabel.widthAnchor.constraint(equalTo: avgPaceView.widthAnchor, constant: -40).isActive = true
        avgPaceLabel.heightAnchor.constraint(equalTo: avgPaceView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupAvgPaceSeparatorView() {
        
        self.addSubview(avgPaceSeparatorView)

        // x, y, width, height constraints
        avgPaceSeparatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        avgPaceSeparatorView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        avgPaceSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        avgPaceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.bringSubview(toFront: avgPaceSeparatorView)
    }
    
    func setupCalView() {
        
        self.addSubview(calView)

        // x, y, width, height constraints
        calView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        calView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        calView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
        
        setupCalTitle()
        setupCalLabel()
    }
    
    func setupCalTitle() {
        
        calView.addSubview(calTitle)

        // x, y, width, height constraints
        calTitle.centerXAnchor.constraint(equalTo: calView.centerXAnchor).isActive = true
        calTitle.topAnchor.constraint(equalTo: calView.topAnchor, constant: 5).isActive = true
        calTitle.widthAnchor.constraint(equalTo: calView.widthAnchor).isActive = true
        calTitle.heightAnchor.constraint(equalTo: calView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupCalLabel() {
        
        calView.addSubview(calLabel)

        // x, y, width, height constraints
        calLabel.centerXAnchor.constraint(equalTo: calView.centerXAnchor).isActive = true
        calLabel.topAnchor.constraint(equalTo: calTitle.bottomAnchor, constant: -5).isActive = true
        calLabel.widthAnchor.constraint(equalTo: calView.widthAnchor, constant: -40).isActive = true
        calLabel.heightAnchor.constraint(equalTo: calView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupCalSeparatorView() {
        
        self.addSubview(calSeparatorView)

        // x, y, width, height constraints
        calSeparatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        calSeparatorView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        calSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        calSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.bringSubview(toFront: calSeparatorView)
    }
    
    func setupGraphView() {
        
        self.addSubview(graphView)

        // x, y, width, height constraints
        graphView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphView.topAnchor.constraint(equalTo: calView.bottomAnchor, constant: 10).isActive = true
        graphView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
