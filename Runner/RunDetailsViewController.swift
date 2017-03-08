//
//  RunDetailsViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-07.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class RunDetailsViewController: UIViewController {

    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = run?.name
    }
}
