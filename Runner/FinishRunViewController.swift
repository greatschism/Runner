//
//  FinishRunViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-08.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class FinishRunViewController: UIViewController {

    var newRun: Run?
    
    // TODO: present the newRun info to user on screen
    // TODO: change VC to TableView or CollectionView controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        cancelButton.tintColor = UIColor(r: 0, g: 128, b: 255)
        navigationItem.leftBarButtonItem = cancelButton
    
        // debug
        if newRun != nil, let run = newRun {
            print(run)
        }
    }
    
    func cancel() {
        
        newRun = nil
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
