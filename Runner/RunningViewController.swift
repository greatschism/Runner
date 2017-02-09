//
//  RunningViewController.swift
//  runner
//
//  Created by Thiago Heitling on 2017-01-29.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import Charts

class RunningViewController: UIViewController, ChartViewDelegate {
    
    lazy var newRun: Run = {
        var run = Run(type: RunType.run, time: nil, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [0], calories: 0, image: nil)
        
        return run
    }()
    
    var distance = 0
    
    // for calulation of calories burned
    let isMan = true
    let age = Double(49)
    let weight = Double(70)
    var heartRate = Double(140)
    
    // for calculation of total distance during pause mode
    var isPaused = false
    var distanceWhenPaused = 0
    
    // for building the pace graph
    var lastRanKM = 0
    
    var timer: Timer?
    lazy var locations = [CLLocation]()
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .fitness
    
        // Movement threshold for new events
        _locationManager.distanceFilter = 9.0
        return _locationManager
    }()
    
    lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        view.noDataTextColor = UIColor(r: 0, g: 128, b: 255)
        
        // hide main descriptions
        view.legend.enabled = false
        view.chartDescription?.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var resumePauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = UIColor.white
//        button.layer.cornerRadius = 50
//        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(startPauseButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var resumePauseButtonHorizontalConstraint = NSLayoutConstraint() // need property for animation

    lazy var finishRunButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finish", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.tintColor = UIColor(r: 0, g: 128, b: 255)
        button.setImage(UIImage(named:"FinishRunButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.isHidden = true
        button.addTarget(self, action: #selector(finishRunButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var finishButtonHorizontalConstraint = NSLayoutConstraint() // need property for animation
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        
        view.addSubview(mainContainerView)
        view.addSubview(finishRunButton)
        view.addSubview(resumePauseButton)
        
        setupMainView()
        setupStartPauseButton()
        setupFinishRunButton()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestAlwaysAuthorization()
    }
    
    func setupMainView() {
        // x, y, width, height constraints
        mainContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 10).isActive = true
        mainContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        mainContainerView.bottomAnchor.constraint(equalTo: resumePauseButton.topAnchor, constant: -10).isActive = true
        
        mainContainerView.addSubview(durationView)
        mainContainerView.addSubview(durationSeparatorView)
        mainContainerView.addSubview(distanceView)
        mainContainerView.addSubview(distanceSeparatorView)
        mainContainerView.addSubview(avgPaceView)
        mainContainerView.addSubview(avgPaceSeparatorView)
        mainContainerView.addSubview(calView)
        mainContainerView.addSubview(calSeparatorView)
        mainContainerView.addSubview(graphView)
        
        // setup sub views of the mainView
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
    
    func setupDurationView() {
        // x, y, width, height constraints
        durationView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        durationView.topAnchor.constraint(equalTo: mainContainerView.topAnchor).isActive = true
        durationView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        durationView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        durationView.addSubview(durationTitle)
        durationView.addSubview(durationLabel)
        setupDurationTitle()
        setupDurationLabel()
    }
    
    func setupDurationTitle() {
        // x, y, width, height constraints
        durationTitle.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        durationTitle.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 5).isActive = true
        durationTitle.widthAnchor.constraint(equalTo: durationView.widthAnchor).isActive = true
        durationTitle.heightAnchor.constraint(equalTo: durationView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupDurationLabel() {
        // x, y, width, height constraints
        durationLabel.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        durationLabel.topAnchor.constraint(equalTo: durationTitle.bottomAnchor, constant: -5).isActive = true
        durationLabel.widthAnchor.constraint(equalTo: durationView.widthAnchor, constant: -80).isActive = true
        durationLabel.heightAnchor.constraint(equalTo: durationView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupDurationSeparatorView() {
        // x, y, width, height constraints
        durationSeparatorView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        durationSeparatorView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        durationSeparatorView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -24).isActive = true
        durationSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainContainerView.bringSubview(toFront: durationSeparatorView)
    }
    
    func setupDistanceView() {
        // x, y, width, height constraints
        distanceView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        distanceView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        distanceView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        distanceView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        distanceView.addSubview(distanceTitle)
        distanceView.addSubview(distanceLabel)
        setupDistanceTitle()
        setupDistanceLabel()
    }
    
    func setupDistanceTitle() {
        // x, y, width, height constraints
        distanceTitle.centerXAnchor.constraint(equalTo: distanceView.centerXAnchor).isActive = true
        distanceTitle.topAnchor.constraint(equalTo: distanceView.topAnchor, constant: 5).isActive = true
        distanceTitle.widthAnchor.constraint(equalTo: distanceView.widthAnchor).isActive = true
        distanceTitle.heightAnchor.constraint(equalTo: distanceView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupDistanceLabel() {
        // x, y, width, height constraints
        distanceLabel.centerXAnchor.constraint(equalTo: distanceView.centerXAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: distanceTitle.bottomAnchor, constant: -5).isActive = true
        distanceLabel.widthAnchor.constraint(equalTo: distanceView.widthAnchor, constant: -40).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: distanceView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupDistanceSeparatorView() {
        // x, y, width, height constraints
        distanceSeparatorView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        distanceSeparatorView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        distanceSeparatorView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -24).isActive = true
        distanceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainContainerView.bringSubview(toFront: distanceSeparatorView)
    }
    
    func setupAvgPaceView() {
        // x, y, width, height constraints
        avgPaceView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        avgPaceView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        avgPaceView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        avgPaceView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        avgPaceView.addSubview(avgPaceTitle)
        avgPaceView.addSubview(avgPaceLabel)
        setupAvgPaceTitle()
        setupAvgPaceLabel()
    }
    
    func setupAvgPaceTitle() {
        // x, y, width, height constraints
        avgPaceTitle.centerXAnchor.constraint(equalTo: avgPaceView.centerXAnchor).isActive = true
        avgPaceTitle.topAnchor.constraint(equalTo: avgPaceView.topAnchor, constant: 5).isActive = true
        avgPaceTitle.widthAnchor.constraint(equalTo: avgPaceView.widthAnchor).isActive = true
        avgPaceTitle.heightAnchor.constraint(equalTo: avgPaceView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupAvgPaceLabel() {
        // x, y, width, height constraints
        avgPaceLabel.centerXAnchor.constraint(equalTo: avgPaceView.centerXAnchor).isActive = true
        avgPaceLabel.topAnchor.constraint(equalTo: avgPaceTitle.bottomAnchor, constant: -5).isActive = true
        avgPaceLabel.widthAnchor.constraint(equalTo: avgPaceView.widthAnchor, constant: -40).isActive = true
        avgPaceLabel.heightAnchor.constraint(equalTo: avgPaceView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupAvgPaceSeparatorView() {
        // x, y, width, height constraints
        avgPaceSeparatorView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        avgPaceSeparatorView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        avgPaceSeparatorView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -24).isActive = true
        avgPaceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainContainerView.bringSubview(toFront: avgPaceSeparatorView)
    }
    
    func setupCalView() {
        // x, y, width, height constraints
        calView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        calView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        calView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        calView.addSubview(calTitle)
        calView.addSubview(calLabel)
        setupCalTitle()
        setupCalLabel()
    }
    
    func setupCalTitle() {
        // x, y, width, height constraints
        calTitle.centerXAnchor.constraint(equalTo: calView.centerXAnchor).isActive = true
        calTitle.topAnchor.constraint(equalTo: calView.topAnchor, constant: 5).isActive = true
        calTitle.widthAnchor.constraint(equalTo: calView.widthAnchor).isActive = true
        calTitle.heightAnchor.constraint(equalTo: calView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupCalLabel() {
        // x, y, width, height constraints
        calLabel.centerXAnchor.constraint(equalTo: calView.centerXAnchor).isActive = true
        calLabel.topAnchor.constraint(equalTo: calTitle.bottomAnchor, constant: -5).isActive = true
        calLabel.widthAnchor.constraint(equalTo: calView.widthAnchor, constant: -40).isActive = true
        calLabel.heightAnchor.constraint(equalTo: calView.heightAnchor, multiplier: 4/5).isActive = true
    }
    
    func setupCalSeparatorView() {
        // x, y, width, height constraints
        calSeparatorView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        calSeparatorView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        calSeparatorView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -24).isActive = true
        calSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainContainerView.bringSubview(toFront: calSeparatorView)
    }
    
    func setupGraphView() {
        // x, y, width, height constraints
        graphView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        graphView.topAnchor.constraint(equalTo: calView.bottomAnchor, constant: 10).isActive = true
        graphView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor).isActive = true
    }
    
    func setupStartPauseButton() {
        // x, y, width, height constraints
        resumePauseButtonHorizontalConstraint = resumePauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        resumePauseButtonHorizontalConstraint.isActive = true
        
        resumePauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        resumePauseButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        resumePauseButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupFinishRunButton() {
        // x, y, width, height constraints
        finishButtonHorizontalConstraint = finishRunButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        finishButtonHorizontalConstraint.isActive = true
        
        finishRunButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        finishRunButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        finishRunButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    // MARK: - Running Updates and Calculations
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates()  {
        locationManager.stopUpdatingLocation()
    }
    
    func startPauseButtonPressed() {
        
        if timer != nil {
            
            resumePauseButton.setImage(UIImage(named:"ResumeButton"), for: .normal)
            resumePauseButton.tintColor = UIColor(r: 0, g: 128, b: 255)
            
            resumePauseButtonHorizontalConstraint.constant = -45
            finishButtonHorizontalConstraint.constant = 45
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                
                self.finishRunButton.isHidden = false
                self.view.layoutIfNeeded()
            })
            
            timer?.invalidate()
            timer = nil
            stopLocationUpdates()
            isPaused = true
            distanceWhenPaused = distance
        }
        else {
            
            if newRun.time == nil {
                
                newRun.time = NSDate()
            }
            
            resumePauseButton.setImage(UIImage(named:"PauseButton"), for: .normal)
            resumePauseButton.tintColor = UIColor(r: 0, g: 128, b: 255)
            
            resumePauseButtonHorizontalConstraint.constant = 0
            finishButtonHorizontalConstraint.constant = 0
            
            if newRun.duration > 0 {
            
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {

                    self.view.layoutIfNeeded()

                }, completion: { _ in
                    
                    self.finishRunButton.isHidden = true
                })
            }
            
            startLocationUpdates()
            locations.removeAll(keepingCapacity: false)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        }
    }
    
    // Called every second during a run
    func eachSecond() {
        
        // calculate distance when resuming from pause mode (needs that to substract it from total distance)
        if self.isPaused == true {
            
            newRun.totalDistanceInPause = newRun.totalDistanceInPause + (self.distance - self.distanceWhenPaused)
            self.isPaused = false
        }
        
        // time calculation
        newRun.duration = newRun.duration + 1
        let hours = String(format: "%02d", newRun.duration / 3600)
        let minutes = String(format: "%02d", newRun.duration / 60 % 60)
        let seconds = String(format: "%02d", newRun.duration % 60)
        
        // assing duration label
        self.durationLabel.text = "\(hours):\(minutes):\(seconds)"
        
        // running distance taking into account total distance in pause mode
        newRun.totalRunDistance = self.distance - newRun.totalDistanceInPause
        
        let kmInt = newRun.totalRunDistance / 1000 % 1000
        
        let dmTemp = Double(newRun.totalRunDistance) / 1000
        // let dmInt = Int(Double(dmTemp).roundTo(places: 2) * 100) % 100
        let dmInt = Int((Double(dmTemp) * 100)) % 100
        
        let km: String
        
        if kmInt < 10 {
            km = String(format: "%01d", kmInt)
        }
        else {
            km = String(format: "%02d", kmInt)
        }
        
        let dm = String(format: "%02d", dmInt)
        
        // assign distance label
        self.distanceLabel.text = "\(km).\(dm)"
        
        // Pace in 'min/km'
        let paceValue = (Double(newRun.duration) / Double(newRun.totalRunDistance)) * (1000.0 / 60.0)
        newRun.pace = Double(paceValue).roundTo(places: 2)
        let roundPaceString = "\(newRun.pace)"
        let paceComponents = roundPaceString.components(separatedBy: ".")
        
        guard paceComponents.count == 2 else { return }
        
        let paceMinutesPart = paceComponents[0]
        var paceSecondsPart = paceComponents[1]
        
        if paceSecondsPart.characters.count == 1 {
            
            paceSecondsPart = paceSecondsPart.appending("0")
        }
        
        guard let paceSecondsPartInt = Int(paceSecondsPart) else { return }
        
        let paceSecondsPartResult = paceSecondsPartInt * 60 / 100
        paceSecondsPart = String(format: "%02d", paceSecondsPartResult)
        
        // assign pace label
        self.avgPaceLabel.text = "\(paceMinutesPart):\(paceSecondsPart)"
        
        // calories calculation
        let speed = Double(self.distance) / Double(newRun.duration)   // speed in 'm/s'
        self.heartRate = self.heartRateFor(speed)                   // average for man around 30 years old
        
        let totalMinutes = Double(newRun.duration) / 60.0
        if self.isMan {
            newRun.calories = Int(((self.age * 0.2017) + (self.weight * 0.1988) + (self.heartRate * 0.6309) - 55.0969) * totalMinutes / 4.184)
        }
        else {
            newRun.calories = Int(((self.age * 0.074) + (self.weight * 0.1263) + (self.heartRate * 0.4472) - 20.4022) * totalMinutes / 4.184)
        }
        
        let calString = String(format: "%03d", newRun.calories)
        
        // asign calories label
        self.calLabel.text = "\(calString)"
        
        //                print("distance = \(self.distance), kmInt = \(kmInt) dmInt = \(dmInt), totalDistInPause = \(self.totalDistanceInPause), pace = \(paceMinutesPart):\(paceSecondsPart)")
        
        // Build the pace graph. Add a pace bar every kilometer of run
        if kmInt != self.lastRanKM {
            
            if newRun.pacesBySegment.count == 0 {
                
                newRun.pacesBySegment.append(newRun.duration)   // duration of first segment (km)
            }
            else {
                newRun.pacesBySegment.append(newRun.duration - newRun.pacesBySegment.reduce(0, +))    // grab the duration for the last segment (km)
            }
            
            // display the graph
            self.updateChartWithData()
            
            self.lastRanKM = kmInt
        }
    }
    
    // bar chart for pace of each segment
    func updateChartWithData() {
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<newRun.pacesBySegment.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(newRun.pacesBySegment[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Avg pace by segment")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let valueFormatter = ChartValueFormatter()
        chartData.setValueFormatter(valueFormatter)
        
        // setup font for values. Show values only if ran 10 km or less (to avoid clashing value strings)
        if newRun.pacesBySegment.count <= 10 {
            
            chartData.setValueFont(UIFont(name: "AvenirNext-Regular", size: 11))
            chartData.setValueTextColor(UIColor(r: 32, g: 32, b: 32))
        }
        else {
            
            chartData.setDrawValues(false)
        }
        
        if newRun.pacesBySegment.count == 1 {
            
            chartData.barWidth = chartData.barWidth / 2
        }
        
        self.graphView.data = chartData
        
        // animate bars
        self.graphView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
    
    func finishRunButtonPressed() {
        
        let finishRunViewController = FinishRunViewController()
        finishRunViewController.newRun = self.newRun
        let navController = UINavigationController(rootViewController: finishRunViewController)
        present(navController, animated: true, completion: nil)
        
        
        //        if timer != nil {
        //            startPauseButton.setTitle("START", for: .normal)
        //            duration = 0
        //            durationLabel.text = "00:00:00"
        //        }
        
        //        seconds = 0.0
        //        distance = 0.0
        //        locations.removeAll(keepCapacity: false)
    }
    
    func heartRateFor(_ speed: Double) -> Double {
        
        var rate: Double
        
        switch speed {
        case 0..<2.23:  // 0..<5 mph
            rate = 120
        case 2.23..<3.35:   // 5..<7.5 mph
            rate = 138
        default:        // equal or greater than 7.5 mph
            rate = 152
        }
        
        return rate
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


// MARK: - CLLocationManagerDelegate
extension RunningViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            if location.horizontalAccuracy < 20 {
                
                if let lastLocation = self.locations.last {
                    
                    //update distance
                    distance = distance + Int(location.distance(from: lastLocation))
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}
