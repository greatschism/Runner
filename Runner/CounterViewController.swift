//
//  CounterViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-14.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

protocol CounterVCProtocol {
    
    func completed(_ done: Bool)
}

class CounterViewController: UIViewController {

    var delegate: CounterVCProtocol?
    
    var timer: Timer?
    var counter = 3
    
    var numLabelVerticalConstraint = NSLayoutConstraint() // need property for animation
    
    lazy var numLabel01: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = self.counter
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.textAlignment = .center
        label.font = UIFont(name: "DINAlternate-bold", size: 350)
        label.text = "1"
        return label
    }()

    lazy var numLabel02: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = self.counter
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.textAlignment = .center
        label.font = UIFont(name: "DINAlternate-bold", size: 350)
        label.text = "2"
        return label
    }()

    lazy var numLabel03: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = self.counter
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.textAlignment = .center
        label.font = UIFont(name: "DINAlternate-bold", size: 350)
        label.text = "3"
        return label
    }()
    
    let rectTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()

    let rectBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The goal of this VC is to present a regressive count from 3 to 1 and dismiss itself
        view.backgroundColor = UIColor.white
        
        setupNumLabels()
        setupRectViews()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
    }
    
    func setupRectViews() {
        
        view.addSubview(rectTopView)
        
        // x, y, width, height constraints
        rectTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rectTopView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rectTopView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rectTopView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6).isActive = true
        
        view.addSubview(rectBottomView)

        // x, y, width, height constraints
        rectBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rectBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rectBottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rectBottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6).isActive = true
    }
    
    func setupNumLabels() {
        
        view.addSubview(numLabel03)
        
        // x, y, width, height constraints
        numLabel03.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        numLabelVerticalConstraint = numLabel03.topAnchor.constraint(equalTo: view.bottomAnchor)
        numLabelVerticalConstraint.isActive = true
        
        numLabel03.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        numLabel03.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        view.addSubview(numLabel02)

        // x, y, width, height constraints
        numLabel02.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numLabel02.topAnchor.constraint(equalTo: numLabel03.bottomAnchor).isActive = true
        numLabel02.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        numLabel02.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        view.addSubview(numLabel01)

        // x, y, width, height constraints
        numLabel01.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numLabel01.topAnchor.constraint(equalTo: numLabel02.bottomAnchor).isActive = true
        numLabel01.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        numLabel01.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func eachSecond() {
        
        if counter == 0 { // we are done here so inform the delegate
            
            timer = nil
            
            if let del = delegate {
                del.completed(true)
            }
        }
        else {
            
            numLabelVerticalConstraint.constant = numLabelVerticalConstraint.constant - view.frame.height

            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
            
            counter = counter - 1
        }
    }
}
