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

class RunningViewController: UIViewController {

    var duration = 0
    var distance = 0
    
    // for calulation of calories burned
    let isMan = true
    let age = Double(49)
    let weight = Double(70)
    var heartRate = Double(140)
    
    var calories = 0
    
    // for calculation of total distance during pause mode
    var isPaused = false
    var distanceWhenPaused = 0
    var totalDistanceInPause = 0
    
    // total distance considering all distance in paused mode (this is the one displayed on screen)
    var totalRunningDistance = 0
    
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
    
    let mainView: UIView = {
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
    
    let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var startPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("START", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.layer.cornerRadius = 50
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(startPauseButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        
        view.addSubview(mainView)
        view.addSubview(startPauseButton)
        
        setupMainView()
        setupStartPauseButton()
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
        mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 10).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        mainView.bottomAnchor.constraint(equalTo: startPauseButton.topAnchor, constant: -12).isActive = true
        
        mainView.addSubview(durationView)
        mainView.addSubview(durationSeparatorView)
        mainView.addSubview(distanceView)
        mainView.addSubview(distanceSeparatorView)
        mainView.addSubview(avgPaceView)
        mainView.addSubview(avgPaceSeparatorView)
        mainView.addSubview(calView)
        mainView.addSubview(calSeparatorView)
        mainView.addSubview(graphView)
        
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
        durationView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        durationView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        durationView.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        durationView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1/5).isActive = true
        
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
        durationSeparatorView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        durationSeparatorView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        durationSeparatorView.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -24).isActive = true
        durationSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainView.bringSubview(toFront: durationSeparatorView)
    }
    
    func setupDistanceView() {
        // x, y, width, height constraints
        distanceView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        distanceView.topAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        distanceView.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        distanceView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1/5).isActive = true
        
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
        distanceSeparatorView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        distanceSeparatorView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        distanceSeparatorView.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -24).isActive = true
        distanceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainView.bringSubview(toFront: distanceSeparatorView)
    }
    
    func setupAvgPaceView() {
        // x, y, width, height constraints
        avgPaceView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        avgPaceView.topAnchor.constraint(equalTo: distanceView.bottomAnchor).isActive = true
        avgPaceView.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        avgPaceView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1/5).isActive = true
        
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
        avgPaceSeparatorView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        avgPaceSeparatorView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        avgPaceSeparatorView.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -24).isActive = true
        avgPaceSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainView.bringSubview(toFront: avgPaceSeparatorView)
    }
    
    func setupCalView() {
        // x, y, width, height constraints
        calView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: avgPaceView.bottomAnchor).isActive = true
        calView.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        calView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1/5).isActive = true
        
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
        calSeparatorView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        calSeparatorView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        calSeparatorView.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -24).isActive = true
        calSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        mainView.bringSubview(toFront: calSeparatorView)
    }
    
    func setupGraphView() {
        // x, y, width, height constraints
        graphView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        graphView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        graphView.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        graphView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    // TODO: add a graph bar (look for a cool component/pod) as a subview of graphView
    
    func setupStartPauseButton() {
        // x, y, width, height constraints
        startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startPauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        startPauseButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startPauseButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
            
            startPauseButton.setTitle("START", for: .normal)
            timer?.invalidate()
            timer = nil
            stopLocationUpdates()
            isPaused = true
            distanceWhenPaused = distance
            
        }
        else {
            
            startPauseButton.setTitle("PAUSE", for: .normal)
            startLocationUpdates()
            locations.removeAll(keepingCapacity: false)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                
                // calculate distance when resuming from pause mode (needs that to substract it from total distance)
                if self.isPaused == true {
                    
                    self.totalDistanceInPause = self.totalDistanceInPause + (self.distance - self.distanceWhenPaused)
                    self.isPaused = false
                }
                
                // time calculation
                self.duration = self.duration + 1
                let hours = String(format: "%02d", self.duration / 3600)
                let minutes = String(format: "%02d", self.duration / 60 % 60)
                let seconds = String(format: "%02d", self.duration % 60)
                
                // assing duration label
                self.durationLabel.text = "\(hours):\(minutes):\(seconds)"
                
                // running distance taking into account total distance in pause mode
                self.totalRunningDistance = self.distance - self.totalDistanceInPause
                
                let kmInt = self.totalRunningDistance / 1000 % 1000
                
                let dmTemp = Double(self.totalRunningDistance) / 1000
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
                let paceValue = (Double(self.duration) / Double(self.totalRunningDistance)) * (1000.0 / 60.0)
                let roundPaceValue = Double(paceValue).roundTo(places: 2)
                let roundPaceString = "\(roundPaceValue)"
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
                let speed = Double(self.distance) / Double(self.duration)   // speed in 'm/s'
                self.heartRate = self.heartRateFor(speed)                   // average for man around 30 years old
                
                let totalMinutes = Double(self.duration) / 60.0
                if self.isMan {
                    self.calories = Int(((self.age * 0.2017) + (self.weight * 0.1988) + (self.heartRate * 0.6309) - 55.0969) * totalMinutes / 4.184)
                }
                else {
                    self.calories = Int(((self.age * 0.074) + (self.weight * 0.1263) + (self.heartRate * 0.4472) - 20.4022) * totalMinutes / 4.184)
                }
                
                let calString = String(format: "%03d", self.calories)
                
                // asign calories label
                self.calLabel.text = "\(calString)"
                
                //                print("distance = \(self.distance), kmInt = \(kmInt) dmInt = \(dmInt), totalDistInPause = \(self.totalDistanceInPause), pace = \(paceMinutesPart):\(paceSecondsPart)")
            }
        }
    }
    
    // TODO: add finish running button to UI
    func finishRunning() {
        
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
