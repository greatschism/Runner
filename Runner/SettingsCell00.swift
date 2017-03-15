//
//  SettingsCell00.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-14.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class SettingsCell00: UITableViewCell {
    
    var labelTextColor = UIColor(r: 32, g: 32, b: 32)
    
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
    
    var userProfileImageViewHorizontalConstraint = NSLayoutConstraint()    // need property for hide profile imageView when needed

    var profileImage: UIImage? {
        didSet {
            if let image = profileImage {
                userProfileImageView.image = image
            }
        }
    }
    
    var changeProfileImageLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 255, g: 55, b: 55)
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(r: 255, g: 55, b: 55)
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white
        
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        // x, y, width, height constraints
        userProfileImageViewHorizontalConstraint = userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        userProfileImageViewHorizontalConstraint.isActive = true
        
        userProfileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userProfileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        userProfileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        
        // x, y, width, height constraints
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func configure(with user: User, indexPath: IndexPath) {

        userProfileImageViewHorizontalConstraint.constant = 0
        userProfileImageView.isHidden = true

        // Personal info section
        if indexPath.section == 0 {
            
           if indexPath.row == 0 {
            
                userProfileImageViewHorizontalConstraint.isActive = false
                userProfileImageViewHorizontalConstraint = userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
                userProfileImageViewHorizontalConstraint.isActive = true
                userProfileImageView.isHidden = false
                profileImage = UIImage(named: "mario-run")
            
                addChangeProfileImageLabel()
            }
            else if indexPath.row == 1 {
                
                titleLabel.text = user.name
            }
            else if indexPath.row == 2 {
            
                titleLabel.textColor = labelTextColor
                titleLabel.text = user.email
            }
        }
        // Terms section
        else if indexPath.section == 1 {
            
            titleLabel.textColor = labelTextColor

            if indexPath.row == 0 {
                
                titleLabel.text = "Terms of Use"
            }
            else if indexPath.row == 1 {
                
                titleLabel.text = "Privacy Policy"
            }
            else if indexPath.row == 2 {
                
                titleLabel.text = "Contact Us"
            }
        }
        // Logout section
        else if indexPath.section == 2 {
            
            titleLabel.textColor = .red
            titleLabel.text = "Logout"
        }
    }
    
    func addChangeProfileImageLabel() {
        
        addSubview(changeProfileImageLabel)

        changeProfileImageLabel.text = "Change"
        changeProfileImageLabel.textColor = UIColor(r: 0, g: 128, b: 255)
        
        // x, y, width, height constraints
        changeProfileImageLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 10).isActive = true
        changeProfileImageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        changeProfileImageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        changeProfileImageLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
