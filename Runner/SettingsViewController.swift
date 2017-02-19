//
//  SettingsViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-18.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGOUT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setupLogoutButtonView()
    }

    func setupLogoutButtonView() {
        
        view.addSubview(logoutButton)
        
        // x, y, width, height constraints
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    func logoutButtonPressed() {
        
        print("logging out")
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
}
