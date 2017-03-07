//
//  FeedCell.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-20.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell {
    
    var userProfileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        imageView.layer.cornerRadius = 25
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
    
    var runImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var usernameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var runNameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var runDistanceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var runDurationLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var runPaceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let runTimeLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emojiView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var emoji: UIImage? {
        didSet {
            if let image = emoji {
                emojiView.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(runImageView)
        addSubview(userProfileImageView)
        addSubview(runTimeLabel)
        addSubview(usernameLabel)
        addSubview(runNameLabel)
        addSubview(runDistanceLabel)
        addSubview(runDurationLabel)
        addSubview(runPaceLabel)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        // x, y, width, height constraints
        userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // x, y, width, height constraints
        runTimeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        runTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        runTimeLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        runTimeLabel.heightAnchor.constraint(equalTo: runDistanceLabel.heightAnchor).isActive = true
        
        // x, y, width, height constraints
        usernameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 10).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: runTimeLabel.leftAnchor, constant: -8).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // x, y, width, height constraints
        runNameLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor).isActive = true
        runNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        runNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        runNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // x, y, width, height constraints
        runDistanceLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor).isActive = true
        runDistanceLabel.topAnchor.constraint(equalTo: runNameLabel.bottomAnchor, constant: 0).isActive = true
        runDistanceLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        runDistanceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // x, y, width, height constraints
        runDurationLabel.leftAnchor.constraint(equalTo: runDistanceLabel.rightAnchor, constant: 0).isActive = true
        runDurationLabel.topAnchor.constraint(equalTo: runDistanceLabel.topAnchor).isActive = true
        runDurationLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        runDurationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // x, y, width, height constraints
        runPaceLabel.leftAnchor.constraint(equalTo: runDurationLabel.rightAnchor, constant: 0).isActive = true
        runPaceLabel.topAnchor.constraint(equalTo: runDistanceLabel.topAnchor).isActive = true
        runPaceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        runPaceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // x, y, width, height constraints
        runImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        runImageView.topAnchor.constraint(equalTo: self.runPaceLabel.bottomAnchor, constant: 5).isActive = true
        runImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        runImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func configure(with run: Run) {
        
        backgroundColor = UIColor.white
        
        if let uid = run.user?.id {
            
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(snapshot)
                
                if let userDictionary = snapshot.value as? [String: Any] {
                    
                    self.usernameLabel.text = userDictionary["name"] as? String
                }
            }, withCancel: nil)
        }
        usernameLabel.text = run.user?.name
        profileImage = UIImage(named: "mario-run")
        runNameLabel.text = run.name
        runDistanceLabel.text = RawValueFormatter().getDistanceString(with: run.totalRunDistance) + " km"
        runDurationLabel.text = RawValueFormatter().getDurationString(with: run.duration)
        runPaceLabel.text = RawValueFormatter().getPaceString(with: run.pace) + " /km"
        
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
}
