//
//  SettingsViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-18.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SettingsViewController: UITableViewController {

    var settingsViewModel: SettingsViewModel?
    
    lazy var navBarBottomPosition: CGFloat = {
        var height = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        return height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile Settings"
        
        if let settingsVM = settingsViewModel, let table = settingsViewModel?.tableView {
            
            // TableView delegate and datasource are handled in the view model.
            self.tableView.delegate = settingsVM
            self.tableView.dataSource = settingsVM
            self.tableView = table
        }

        addNavButtons()

        bind()
    }
    
    func addNavButtons() {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func dismissVC() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func bind() {

        // Define logout command when the logout cell is touched. Push the login VC onto the nav stack.
        settingsViewModel?.logoutCommand = RACCommand(signal: {[weak self](loginVC:Any!) -> RACSignal! in
            
            guard let sself = self else { return RACSignal.empty() }
            
            sself.present(loginVC as! LoginViewController, animated: true, completion: nil)
            
            print("[SETTINGS VIEW CONTROLLER] User successfuly logged out.")

            return RACSignal.empty()
        })
    }
}
