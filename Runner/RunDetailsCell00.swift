//
//  RunDetailsCell.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-08.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class RunDetailsCell00: UICollectionViewCell {
    
    var userProfileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var profileImage: UIImage? {
        didSet {
            if let image = profileImage {
                userProfileImageView.image = image
            }
        }
    }
    
    var runNameLabel: UILabel = {
        
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(r: 32, g: 32, b: 32)
        label.font = UIFont(name: "DINAlternate-bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let runTimeLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var runImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with run: Run) {
        
        addSubview(userProfileImageView)
        addSubview(runNameLabel)
        addSubview(runTimeLabel)
        addSubview(runImageView)
        
        let statsContainerView = getStatsViews(with: run)
        addSubview(statsContainerView)
        
        // x, y, width, height constraints
        userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // x, y, width, height constraints
        runNameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 10).isActive = true
        runNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        runNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        runNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        runTimeLabel.leftAnchor.constraint(equalTo: runNameLabel.leftAnchor).isActive = true
        runTimeLabel.topAnchor.constraint(equalTo: runNameLabel.bottomAnchor, constant: 6).isActive = true
        runTimeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        runTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        runImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        runImageView.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 10).isActive = true
        runImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        runImageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        // x, y, width, height constraints
        statsContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statsContainerView.topAnchor.constraint(equalTo: runImageView.bottomAnchor, constant: 20).isActive = true
        statsContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        statsContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileImage = UIImage(named: "mario-run")
        
        runNameLabel.text = run.name
        
        if let startRunTime = run.timestamp {
            
            let timestampDate = Date(timeIntervalSince1970: Double(startRunTime))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            runTimeLabel.text = dateFormatter.string(from: timestampDate)
        }
        
        if let imageURL = run.imageURL {
            runImageView.loadImageUsingCache(with: imageURL)
        }
    }
    
    func getStatsViews(with run: Run) -> CompleteRunStatsContainerView {
        
        let containerView = CompleteRunStatsContainerView(frame: .zero)
        containerView.backgroundColor = .white
        
        // Process distance
        containerView.distanceContainer[1].text = RawValueFormatter().getDistanceString(with: run.totalRunDistance)

        // Process duration
        containerView.durationContainer[1].text = RawValueFormatter().getDurationString(with: run.duration)
        
        // Process pace
        containerView.paceContainer[1].text = RawValueFormatter().getPaceString(with: run.pace)

        // Process calories
        let calString = RawValueFormatter().getCaloriesString(with: run.calories)
        
        // Assign calories label
        containerView.caloriesContainer[1].text = "\(calString)"
        
        return containerView
    }
}
