//
//  SettingsViewModel.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-14.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import ReactiveViewModel

class SettingsViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: User?
    var tableView: UITableView?
    let cellIDs = ["Cell00"]
    
    let sections = 3
    let sectionHeaderHeight: CGFloat = 50
    let cellHeight: CGFloat = 60
    
    var logoutCommand: RACCommand?
    
    override init() {
        super.init()
        
        tableView = getTableView()
    }
    
    func getTableView() -> UITableView {
        
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.backgroundColor = .white
        table.register(SettingsCell00.self, forCellReuseIdentifier: self.cellIDs[0])
        return table
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return ""
        }
        else if section == 1 {
            
            return ""
        }
        else {
            
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 3
        }
        else if section == 1 {
            
            return 3
        }
        else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell()
        
//        if indexPath.section == 0 || indexPath.section == 2 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIDs[0]) as! SettingsCell00
            
            if let user = currentUser {
                
                cell.configure(with: user, indexPath: indexPath)
                return cell
            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Logout selected
        if indexPath.section == 2 {
            
            logout()
        }
    }
    
    func logout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
            let loginVC = LoginViewController()
            logoutCommand?.execute(loginVC)            
        }
        catch let logoutError {
            print(logoutError)
        }
    }
}
