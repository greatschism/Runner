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
import MapKit

class RunningViewController: UIViewController, CounterVCProtocol, FinishRunProtocol {
    
    var newRun: Run = {
        var run = Run(id: nil, name: nil, timestamp: nil, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [], elevations: [], calories: 0, locations: nil, imageURL: nil, user: nil)
        return run
    }()
    
    var currentUser: User?
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
    
    // For building the altitude graph
    var last100m = 0
    
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
        button.setBackgroundImage(UIImage(named: "ResumeButton4"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startPauseButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var resumePauseButtonHorizontalConstraint = NSLayoutConstraint() // need property for animation

    lazy var finishRunButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"FinishRunButton3"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(finishRunButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var finishButtonHorizontalConstraint = NSLayoutConstraint() // need property for animation
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .red
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.isHidden = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mapview: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var mapviewHorizontalConstraint = NSLayoutConstraint() // need property for animation

    lazy var toggleMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "mapButtonDeselected"), for: .normal)
        button.addTarget(self, action: #selector(toggleMapButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var toggleMapButtonOn = false
    
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
//        view.backgroundColor = UIColor(r: 40, g: 43, b: 53)

//        view.addSubview(bgImageView)
        
        view.addSubview(statsContainer)
        view.addSubview(finishRunButton)
        view.addSubview(resumePauseButton)
        view.addSubview(closeButton)
        view.addSubview(mapview)
        view.addSubview(toggleMapButton)
        
        setupMainView()
        setupStartPauseButton()
        setupFinishRunButton()
        setupCloseButton()
        setupMapView()
        setupToggleMapButton()
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
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/3).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: resumePauseButton.centerYAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupMapView() {
        
        // x, y, width, height constraints
        mapviewHorizontalConstraint = mapview.leftAnchor.constraint(equalTo: view.rightAnchor)
        mapviewHorizontalConstraint.isActive = true
        mapview.topAnchor.constraint(equalTo: statsContainer.distanceView.topAnchor).isActive = true
        mapview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapview.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor).isActive = true
    }
    
    func setupToggleMapButton() {
        
        // x, y, width, height constraints
        toggleMapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/3).isActive = true
        toggleMapButton.centerYAnchor.constraint(equalTo: resumePauseButton.centerYAnchor).isActive = true
        toggleMapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        toggleMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

        if timer != nil {
            
            // Is going to enter in pause mode
            resumePauseButton.setBackgroundImage(UIImage(named:"ResumeButton4"), for: .normal)
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
         
            if newRun.timestamp == nil {
                
                // Pressed the button for the first time (Start), so hide the close button
                closeButton.isHidden = true
                newRun.timestamp = Int(NSDate().timeIntervalSince1970)
                
//                counterVC.delegate = self
//                counterVC.modalTransitionStyle = .crossDissolve
//                present(counterVC, animated: true, completion: nil)
                
                startingResumingRun()
            }
            else {
                // Is going to resume run
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
        
        resumePauseButton.setBackgroundImage(UIImage(named:"PauseButton2"), for: .normal)
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
        if newRun.totalRunDistance != 0 {

            let paceValue = (Double(newRun.duration) / Double(newRun.totalRunDistance)) * (1000.0 / 60.0)
            newRun.pace = Double(paceValue).roundTo(places: 2)
        }
        
        statsContainer.avgPaceLabel.text = RawValueFormatter().getPaceString(with: newRun.pace)
        
        // TODO: put calories calculation logic to view model
        
        // Calories calculation
        if newRun.duration != 0 {
            
            let speed = Double(newRun.totalRunDistance) / Double(newRun.duration)   // speed in 'm/s'
            self.heartRate = self.heartRateFor(speed)                   // average for man around 30 years old
        }
        
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
            
            // Display graphs
            self.updatePaceChart()
            
            self.lastRanKM = kmInt
        }
        
        // Build the elevation graph. Add an elevation entry data every 100m of run
        let last100m = newRun.totalRunDistance / 100 % 100
        
        guard let altitudeRawValue = locations.last?.altitude else { return }
        
        let altitude = Int(altitudeRawValue)
        
        let randomNum = arc4random_uniform(UInt32(10)) + 50 // TODO: remove random number
        let randomInt = Int(randomNum)
        
        if newRun.elevations.count == 0 {
            
            newRun.elevations.append(randomInt)   // altitude when start runing
            
            // Update graph
//            self.updateElevationChart()
        }
        
        if last100m != self.last100m {
            
                newRun.elevations.append(randomInt)   // altitude of each 50 m
            
            // Update graph
            self.updateElevationChart()
            
            self.last100m = last100m
        }
    }
    
    // Bar chart for pace of each segment
    func updatePaceChart() {
        
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<newRun.pacesBySegment.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(newRun.pacesBySegment[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Avg pace by segment")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let valueFormatter = ChartValueFormatter()
        chartData.setValueFormatter(valueFormatter)
        
        // Setup font for values. Show values only if ran 5 km or less (to avoid clashing value strings)
        if newRun.pacesBySegment.count <= 5 {
            
            chartData.setValueFont(UIFont(name: "AvenirNext-Regular", size: 11))
//            chartData.setValueTextColor(UIColor(r: 32, g: 32, b: 32))
            chartData.setValueTextColor(statsContainer.numbersColor)
        }
        else {
            
            chartData.setDrawValues(false)
        }
        
        if newRun.pacesBySegment.count == 1 {
            
            chartData.barWidth = chartData.barWidth / 2
        }
        
        statsContainer.paceGraphView.data = chartData
        
        // animate bars
        statsContainer.paceGraphView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
    
    // Line chart for elevations
    func updateElevationChart() {
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<newRun.elevations.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(newRun.elevations[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet: LineChartDataSet
        
        if let datSetCount = statsContainer.elevationView.data?.dataSetCount {
            
            if datSetCount > 0 {
                
                chartDataSet = statsContainer.elevationView.data?.dataSets[0] as! LineChartDataSet
                chartDataSet.values = dataEntries
                statsContainer.elevationView.data?.notifyDataChanged()
                statsContainer.elevationView.notifyDataSetChanged()
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
            statsContainer.elevationView.data = data
        }
        
        // animate bars
//        statsContainer.elevationView.animate(yAxisDuration: 1.0, easingOption: .easeInOutExpo)
    }
    
    func toggleMapButtonPressed() {
        
        toggleMapButtonOn = !toggleMapButtonOn

        if toggleMapButtonOn {
            
            toggleMapButton.setBackgroundImage(UIImage(named: "mapButtonSelected"), for: .normal)
            mapviewHorizontalConstraint.isActive = false
            mapviewHorizontalConstraint = mapview.leftAnchor.constraint(equalTo: view.leftAnchor)
            mapviewHorizontalConstraint.isActive = true
        }
        else {
            toggleMapButton.setBackgroundImage(UIImage(named: "mapButtonDeselected"), for: .normal)
            mapviewHorizontalConstraint.isActive = false
            mapviewHorizontalConstraint = mapview.leftAnchor.constraint(equalTo: view.rightAnchor)
            mapviewHorizontalConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func finishRunButtonPressed() {
        
        if currentUser != nil {
            
            newRun.user = currentUser
        }
        
        newRun.locations = locations
        
        let finishRunViewController = FinishRunViewController()
        finishRunViewController.delegate = self
        finishRunViewController.newRun = self.newRun
        let navController = UINavigationController(rootViewController: finishRunViewController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Finish Run Delegate
    func shouldDismiss() {
        
        dismiss(animated: true, completion: nil)
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

extension RunningViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            let howRecent = location.timestamp.timeIntervalSinceNow

            if abs(howRecent) < 10 && location.horizontalAccuracy < 15 {
                
                if let lastLocation = self.locations.last {
                    
                    //update distance
                    distance = distance + Int(location.distance(from: lastLocation))
                    
                    // update map
                    var coordinates = [CLLocationCoordinate2D]()
                    
                    if let lastCoord = self.locations.last?.coordinate {
                        
                        coordinates.append(lastCoord)
                        coordinates.append(location.coordinate)
                        
                        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                        mapview.setRegion(region, animated: true)
                        
                        mapview.add(MKPolyline(coordinates: &coordinates, count: coordinates.count))
                    }
                }
                
                //save location
                self.locations.append(location)
            }
            else {
                print("[RUNNING VIEW CONTROLLER] location data is not recent or horizontal accuracy is too large.")
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay.isKind(of: MKPolyline.self){
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(r: 0, g: 128, b: 255)
            polylineRenderer.lineWidth = 10
            polylineRenderer.lineCap = .round
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
