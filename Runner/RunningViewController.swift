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

class RunningViewController: UIViewController, CounterVCProtocol, FinishRunProtocol {
    
    lazy var newRun: Run = {
        var run = Run(type: RunType.run, time: nil, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [], calories: 0, feeling: nil)
        
        return run
    }()
    
    var distance = 0
    
    // For calulation of calories burned
    let isMan = true
    let age = Double(49)
    let weight = Double(70)
    var heartRate = Double(140)
    
    // For calculation of total distance during pause mode
    var isPaused = false
    var distanceWhenPaused = 0
    
    // For building the pace graph
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
  
    let statsContainer = InProgressRunStatsContainerView(frame: .zero)
    
    lazy var resumePauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GO", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        
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
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.isHidden = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.image = UIImage(named: "road-track-athletic")
        imageView.alpha = 0.15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let counterVC = CounterViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        
        view.addSubview(bgImageView)
        
        view.addSubview(statsContainer)
        view.addSubview(finishRunButton)
        view.addSubview(resumePauseButton)
        view.addSubview(closeButton)
        
        setupMainView()
        setupStartPauseButton()
        setupFinishRunButton()
        setupCloseButton()
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
        statsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 10).isActive = true
        statsContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        statsContainer.bottomAnchor.constraint(equalTo: resumePauseButton.topAnchor, constant: -10).isActive = true
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

    func setupCloseButton() {
        // x, y, width, height constraints
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    // MARK: - Running Updates and Calculations
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates()  {
        locationManager.stopUpdatingLocation()
    }
    
    func startPauseButtonPressed() {
        
        animateButton(button: resumePauseButton)
        
        resumePauseButton.backgroundColor = UIColor.clear
        resumePauseButton.layer.cornerRadius = 0
        resumePauseButton.layer.masksToBounds = true

        // Is going to enter in pause mode
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
        // Pressed the button for the first time (Start), so present the Counter View Controller
        else {
         
            if newRun.time == nil {
                
                closeButton.isHidden = true
                
                newRun.time = NSDate()
                
                counterVC.delegate = self
                counterVC.modalTransitionStyle = .crossDissolve
                present(counterVC, animated: true, completion: nil)
            }
            else {
                startingResumingRun()
            }
        }
    }
    
    func closeButtonPressed() {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Counter View Controller Delegate
    func completed(_ done: Bool) {

        if done {
            counterVC.modalTransitionStyle = .crossDissolve
            counterVC.dismiss(animated: true, completion: {
                self.startingResumingRun()
            })
        }
    }
    
    func startingResumingRun() {
        
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
    
    // Called every second during a run
    func eachSecond() {
        
        // Calculate distance when resuming from pause mode (needs that to substract it from total distance)
        if self.isPaused == true {
            
            newRun.totalDistanceInPause = newRun.totalDistanceInPause + (self.distance - self.distanceWhenPaused)
            self.isPaused = false
        }
        
        // Process time calculation
        newRun.duration = newRun.duration + 1
        
        statsContainer.durationLabel.text = RawValueFormatter().getDurationString(with: newRun.duration)
        
        // Process running distance taking into account total distance in pause mode
        newRun.totalRunDistance = self.distance - newRun.totalDistanceInPause
        
        statsContainer.distanceLabel.text = RawValueFormatter().getDistanceString(with: newRun.totalRunDistance)
        
        // Process Pace in 'min/km'
        let paceValue = (Double(newRun.duration) / Double(newRun.totalRunDistance)) * (1000.0 / 60.0)
        newRun.pace = Double(paceValue).roundTo(places: 2)
        
        statsContainer.avgPaceLabel.text = RawValueFormatter().getPaceString(with: newRun.pace)
        
        // TODO: put calories calculation logic to view model
        
        // Calories calculation
        let speed = Double(newRun.totalRunDistance) / Double(newRun.duration)   // speed in 'm/s'
        self.heartRate = self.heartRateFor(speed)                   // average for man around 30 years old
        
        let totalMinutes = Double(newRun.duration) / 60.0
        if self.isMan {
            newRun.calories = Int(((self.age * 0.2017) + (self.weight * 0.1988) + (self.heartRate * 0.6309) - 55.0969) * totalMinutes / 4.184)
        }
        else {
            newRun.calories = Int(((self.age * 0.074) + (self.weight * 0.1263) + (self.heartRate * 0.4472) - 20.4022) * totalMinutes / 4.184)
        }
        
        // Assign calories label
        statsContainer.calLabel.text = RawValueFormatter().getCaloriesString(with: newRun.calories)
        
        // Build the pace graph. Add a pace bar every kilometer of run
        let kmInt = newRun.totalRunDistance / 1000 % 1000

        if kmInt != self.lastRanKM {
            
            if newRun.pacesBySegment.count == 0 {
                
                newRun.pacesBySegment.append(newRun.duration)   // duration of first segment (km)
            }
            else {
                newRun.pacesBySegment.append(newRun.duration - newRun.pacesBySegment.reduce(0, +))    // grab the duration for the last segment (km)
            }
            
            // Display the graph
            self.updateChartWithData()
            
            self.lastRanKM = kmInt
        }
    }
    
    // Bar chart for pace of each segment
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
        
        // Setup font for values. Show values only if ran 10 km or less (to avoid clashing value strings)
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
        
        statsContainer.graphView.data = chartData
        
        // animate bars
        statsContainer.graphView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
    
    func finishRunButtonPressed() {
        
        let finishRunViewController = FinishRunViewController()
        finishRunViewController.delegate = self
        finishRunViewController.newRun = self.newRun
        present(finishRunViewController, animated: true, completion: nil)
    }
    
    // MARK: - Finish Run Delegate
    func discard(_ selected: Bool) {
        
        if selected {
            
            dismiss(animated: true, completion: nil)
        }
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
    
    func animateButton(button: UIButton) {
        
        UIView.animate(withDuration: 0.05, animations: {
            
            button.transform = .init(scaleX: 0.8, y: 0.8)
        }) { _ in
            
            UIView.animate(withDuration: 0.05) {
                button.transform = .identity
            }
        }
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
