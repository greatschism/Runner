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
    
    var usernameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
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
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
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
        userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        userProfileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2).isActive = true
        userProfileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2).isActive = true
        
        // x, y, width, height constraints
        usernameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 10).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width, height constraints
        runDistanceLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor).isActive = true
        runDistanceLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        runDistanceLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        runDistanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width, height constraints
        runDurationLabel.leftAnchor.constraint(equalTo: runDistanceLabel.rightAnchor, constant: 20).isActive = true
        runDurationLabel.topAnchor.constraint(equalTo: runDistanceLabel.topAnchor).isActive = true
        runDurationLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        runDurationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width, height constraints
        runPaceLabel.leftAnchor.constraint(equalTo: runDurationLabel.rightAnchor, constant: 20).isActive = true
        runPaceLabel.topAnchor.constraint(equalTo: runDistanceLabel.topAnchor).isActive = true
        runPaceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        runPaceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        
        profileImage = UIImage(named: "mario-run")
        runDistanceLabel.text = RawValueFormatter().getDistanceString(with: run.totalRunDistance) + " km"
        runDurationLabel.text = RawValueFormatter().getDurationString(with: run.duration)
        runPaceLabel.text = RawValueFormatter().getPaceString(with: run.pace) + " /km"
    }
}
