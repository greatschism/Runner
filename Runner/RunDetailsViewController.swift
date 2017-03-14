//
//  RunDetailsViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-07.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Social

class RunDetailsViewController: UIViewController {

    var runDetailsViewModel: RunDetailsViewModel?
    var collectionView: UICollectionView?
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share this run", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "DINAlternate-bold", size: 20)
        button.backgroundColor = UIColor(r: 255, g: 55, b: 55)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var navBarBottomPosition: CGFloat = {
        var height = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        return height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Run Details"
        
        if let runDetailsVM = runDetailsViewModel, let collectionView = runDetailsViewModel?.collectionView {
            
            // CollectionView delegate and datasource are handled in the view model.
            self.collectionView?.delegate = runDetailsVM
            self.collectionView?.dataSource = runDetailsVM
            self.collectionView = collectionView
            self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
            view.addSubview(collectionView)
        }
        
        setupShareButton()
        setupCollectionView()
        setupPageControlView()
    }

    func setupShareButton() {
        
        view.addSubview(shareButton)
        
        // x, y, width, height constraints
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupCollectionView() {
        
        guard let collectionView = self.collectionView else { return }
        
        view.addSubview(collectionView)
        
        // x, y, width, height constraints
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navBarBottomPosition)).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -90).isActive = true
    }

    func setupPageControlView() {
        
        guard let runDetailsVM = runDetailsViewModel else { return }
        view.addSubview(runDetailsVM.pageControl)
        
        // x, y, width, height constraints
        runDetailsVM.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runDetailsVM.pageControl.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -30).isActive = true
        runDetailsVM.pageControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        runDetailsVM.pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func shareButtonPressed() {
    
        print("share my run: \(runDetailsViewModel?.run?.name)")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            guard let shareOnFacebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else { return }
            
            // grab the imgage
            let iv = UIImageView()
            if let imageURL = runDetailsViewModel?.run?.imageURL {

                iv.loadImageUsingCache(with: imageURL)
                
                // add overlay layer to the image with some running info
                guard let image = iv.image, let imageToShare = addRunningInfoToImage(with: image) else { return }
                
                shareOnFacebook.add(imageToShare)

                present(shareOnFacebook, animated: true, completion: nil)
            }
            else {
                // something went wrong, please try again later
            }
        }
        else {
            
            let alert = UIAlertController(title: "Unable to Share", message: "Please, make sure your are logged in on Facebook App.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func addRunningInfoToImage(with image: UIImage) -> UIImage? {
        
        guard let distance = runDetailsViewModel?.run?.totalRunDistance else { return nil }
        guard let duration = runDetailsViewModel?.run?.duration else { return nil }
        guard let pace = runDetailsViewModel?.run?.pace else { return nil }
        
        let background = UIImage(named: "backgroundForSharing")
        
        let valueFont = UIFont(name: "DINAlternate-bold", size: 20)
        let valueAttributes = [NSFontAttributeName: valueFont, NSForegroundColorAttributeName:UIColor.white]

        let textFont = UIFont(name: "AvenirNext-Regular", size: 12)
        let textAttributes = [NSFontAttributeName: textFont, NSForegroundColorAttributeName:UIColor.white]
        
        let distanceValue = RawValueFormatter().getDistanceString(with: distance)
        let distanceUnit = "km"

        let runningTime = RawValueFormatter().getDurationString(with: duration)
        
        let paceValue = RawValueFormatter().getPaceString(with: pace)
        let paceUnit = "min/km"
        
        let distanceTitle = "distance"
        let durationTitle = "duration"
        let paceTitle = "pace"
        
        // getting sizes
        let distanceValueTextSize = distanceValue.size(attributes: valueAttributes)
        let distanceUnitTextSize = distanceUnit.size(attributes: textAttributes)
        
        let runningTimeTextSize = runningTime.size(attributes: valueAttributes)
        
        let paceValueTextSize = paceValue.size(attributes: valueAttributes)
        
        let originalImageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: originalImageRect.size.width, height: originalImageRect.size.height), true, 0)
        
        // drawing our orinigal image to the graphics context
        image.draw(in: originalImageRect)
        
        // background
        background?.draw(in: CGRect(x: 0, y: 0, width: originalImageRect.size.width, height: 60))
        
        // drawing values, title and units texts
        
        var xRef: CGFloat = 10
        
        distanceValue.draw(in: CGRect(x: xRef, y: 5, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: valueAttributes)
        
        distanceTitle.draw(in: CGRect(x: xRef, y: distanceValueTextSize.height + 2, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: textAttributes)
        
        xRef = xRef + distanceValueTextSize.width + 2
        
        distanceUnit.draw(in: CGRect(x: xRef, y: distanceValueTextSize.height - 12, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: textAttributes)

        xRef = xRef + distanceUnitTextSize.width + 10
        
        runningTime.draw(in: CGRect(x: xRef, y: 5, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: valueAttributes)
        
        durationTitle.draw(in: CGRect(x: xRef, y: runningTimeTextSize.height + 2, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: textAttributes)
        
        xRef = xRef + runningTimeTextSize.width + 10
            
        paceValue.draw(in: CGRect(x: xRef, y: 5, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: valueAttributes)
        
        paceTitle.draw(in: CGRect(x: xRef, y: paceValueTextSize.height + 2, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: textAttributes)
        
        xRef = xRef + paceValueTextSize.width + 2
        
        paceUnit.draw(in: CGRect(x: xRef, y: distanceValueTextSize.height - 12, width: originalImageRect.size.width, height: originalImageRect.size.height), withAttributes: textAttributes)
        
        // getting an image from it
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
