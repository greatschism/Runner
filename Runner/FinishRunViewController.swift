//
//  FinishRunViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-08.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Firebase
import HealthKit
import MapKit

protocol FinishRunProtocol {
    
    func shouldDismiss()
}

class FinishRunViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate/*, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource*/ {

    var newRun: Run?
    
    var delegate: FinishRunProtocol?
    
    lazy var navBarBottomPosition: CGFloat = {
       var height = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        return height
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Name:"
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.font = UIFont(name: "DINAlternate-bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let limitRunNameLength = 40
    
    lazy var nameTextField: UITextField = {
        
        let text = UITextField()
        text.delegate = self
        text.textColor = UIColor(r: 64, g: 64, b: 64)
        text.font = UIFont(name: "DINAlternate-bold", size: 18)
        text.contentVerticalAlignment = .center
        text.placeholder = "New Run"
//        text.attributedPlaceholder = NSAttributedString(string: "New Run", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.9)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var mapview: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // Stats views
    lazy var statsContainerView: CompleteRunStatsContainerView = {
        
        var containerView = CompleteRunStatsContainerView(frame: .zero)
        
        // Process distance
        if let totalRunDistance = self.newRun?.totalRunDistance {
            
            containerView.distanceContainer[1].text = RawValueFormatter().getDistanceString(with: totalRunDistance)
        }
        else {
            containerView.distanceContainer[1].text = "no data"
        }
        
        // Process duration
        if let duration = self.newRun?.duration {
            
            containerView.durationContainer[1].text = RawValueFormatter().getDurationString(with: duration)
        }
        else {
            
            containerView.durationContainer[1].text = "no data"
        }
        
        // Process pace
        if let pace = self.newRun?.pace {
            
            containerView.paceContainer[1].text = RawValueFormatter().getPaceString(with: pace)
        }
        else {
            // did not form the pace components array correctly
            containerView.paceContainer[1].text = "no data"
        }
        
        // Process calories
        let calString = self.newRun?.calories != nil ? RawValueFormatter().getCaloriesString(with: self.newRun!.calories) : "no data"
        
        // Assign calories label
        containerView.caloriesContainer[1].text = "\(calString)"
        
        return containerView
    }()
    
    lazy var createClubButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Your Own Running Club", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 0, g: 128, b: 255), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(r: 0, g: 128, b: 255).cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(createClubButtonPressed), for: .touchUpInside)
        
        return button
    }()

    lazy var discardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"TrashCan"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(discard), for: .touchUpInside)
        
        return button
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.image = UIImage(named: "piste-athle2")
        imageView.alpha = 0.15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white        

        self.title = "Save New Run"
        
        self.hideKeyboardWhenTappedAround()
        
        addNavButtons()
        
        setupNameLabel()
        setupNameTextField()
        setupMapView()
        setupCreateClubButton()
        setupStatsContainerView()
        setupDiscardButton()
        
        // debug
        if newRun != nil, let run = newRun {
            print(run)
        }
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    func addNavButtons() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(resume))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImageFirst))

        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupNameLabel() {
        
        view.addSubview(nameLabel)
        
        // x, y, width, height constraints
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (navBarBottomPosition + 20)).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupNameTextField() {
        
        view.addSubview(nameTextField)
        
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupMapView() {
        
        view.addSubview(mapview)
        
        // x, y, width, height constraints
        mapview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapview.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        mapview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapview.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        loadMap()
    }
    
    func setupCreateClubButton() {
        
        view.addSubview(createClubButton)
        
        // x, y, width, height constraints
        createClubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createClubButton.topAnchor.constraint(equalTo: mapview.bottomAnchor, constant: 20).isActive = true
        createClubButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        createClubButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    func setupStatsContainerView() {
        
        view.addSubview(statsContainerView)
        
        // x, y, width, height constraints
        statsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statsContainerView.topAnchor.constraint(equalTo: createClubButton.bottomAnchor, constant: 20).isActive = true
        statsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        statsContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupDiscardButton() {
        
        view.addSubview(discardButton)
        
        // x, y, width, height constraints
        discardButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35).isActive = true
        discardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        discardButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        discardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func createClubButtonPressed() {
        
        print("button pressed")
    }
    
    func saveImageFirst() {
        
        let ref = FIRDatabase.database().reference().child("runs")
        let runRef = ref.childByAutoId()
        
        if let image = self.mapview.renderToImage() {
            
            let imageName = UUID().uuidString
            let ref = FIRStorage.storage().reference().child("run_images").child(runRef.key).child(imageName)
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                
                ref.put(data, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        
                        print("[FINISH VIEW CONTROLLER] failed to upload image:", error.debugDescription)
                        return
                    }
                    
                    if let urlString = metadata?.downloadURL()?.absoluteString {
                        
                        self.saveRun(with: runRef, imageURL: urlString, imageName: imageName)
                    }
                })
            }
        }
    }
    
    private func saveRun(with runRef: FIRDatabaseReference, imageURL: String, imageName: String) {
        
        let locationsRef = runRef.child("locations")
        let imagesRef = runRef.child("images")
        
        guard let user = newRun?.user, let uid = user.id else { return }
                
        var values = [String:Any]()
        var locationValues = [String:Any]()
        var imageValues = [String:Any]()
        
        guard let newRun = newRun, let timestamp = newRun.timestamp else { return }
        
        var runName = "New run"
        if nameTextField.text != nil && nameTextField.text != "" {
            runName = nameTextField.text!
        }
        
        values = ["name":runName, "totalRunDistance":newRun.totalRunDistance, "duration":newRun.duration, "pace": newRun.pace, "pacesBySegment":newRun.pacesBySegment, "userID":uid, "timestamp": timestamp, "elevations":newRun.elevations, "calories":newRun.calories, "paceZones":newRun.paceZones]
        
        runRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            
            // save locations
            if let locations = newRun.locations {
                for eachLocation in locations {
                    
                    let eachLocationRef = locationsRef.childByAutoId()
                    locationValues = ["latitude": eachLocation.coordinate.latitude, "longitude": eachLocation.coordinate.longitude]
                    eachLocationRef.updateChildValues(locationValues)
                }
            }
            
            // save image
            let imageRef = imagesRef.childByAutoId()
            imageValues = ["imageName":imageName, "imageURL": imageURL]
            imageRef.updateChildValues(imageValues)
            
            print("[FINISH VIEW CONTROLLER] saved new run to firebase.")
            
            self.dismiss(animated: true) {
                
                if let del = self.delegate {
                    
                    del.shouldDismiss()
                }
            }
        }
    }
    
    func resume() {
        
        newRun = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func discard() {
        
        newRun = nil
        self.dismiss(animated: true) { 
            
            if let del = self.delegate {
                
                del.shouldDismiss()
            }
        }
    }

    // MARK: - MapKit delegates and helper methods
    func mapRegion() -> MKCoordinateRegion {
        
        guard let locations = newRun?.locations, let initialLoc = newRun?.locations?.first else {
        
            return MKCoordinateRegion()
        }
        
        var minLat = Double(initialLoc.coordinate.latitude)
        var minLng = Double(initialLoc.coordinate.longitude)
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, Double(location.coordinate.latitude))
            minLng = min(minLng, Double(location.coordinate.longitude))
            maxLat = max(maxLat, Double(location.coordinate.latitude))
            maxLng = max(maxLng, Double(location.coordinate.longitude))
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2),span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLng - minLng) * 1.3))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay.isKind(of: MKPolyline.self){
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(r: 0, g: 128, b: 255)
            polylineRenderer.lineWidth = 5
            polylineRenderer.lineCap = .round
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func polyline() -> MKPolyline {
        
        guard let locations = newRun?.locations else { return MKPolyline() }
        var coords = [CLLocationCoordinate2D]()
        for location in locations {
            
            coords.append(CLLocationCoordinate2D(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude)))
        }
        
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    func loadMap() {
        
        guard let locations = newRun?.locations else { return }
        
        if locations.count > 0 {
            
            mapview.isHidden = false
            
            // Set the map bounds
            mapview.region = mapRegion()
            
            // Make the line(s) on the map
            mapview.add(polyline())
        }
        else {
            // No locations were found!
            mapview.isHidden = true
            
            print("[FINISH VIEW CONTROLLER] no locations found, so hide the map.")
        }
    }
    
    // MARK: - Text Field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitRunNameLength
    }
}

