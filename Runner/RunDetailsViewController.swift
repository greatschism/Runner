//
//  RunDetailsViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-07.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class RunDetailsViewController: UIViewController {

    var runDetailsViewModel: RunDetailsViewModel?
    var collectionView: UICollectionView?
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share this run", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "DINAlternate-bold", size: 20)
        button.backgroundColor = UIColor(r: 255, g: 55, b: 55)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var navBarBottomPosition: CGFloat = {
        var height = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        return height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Run Details"
        
        if let runDetailsVM = runDetailsViewModel, let collectionView = runDetailsViewModel?.collectionView {
            
            // CollectionView delegate and datasource are handled in the view model.
            self.collectionView?.delegate = runDetailsVM
            self.collectionView?.dataSource = runDetailsVM
            self.collectionView = collectionView
            self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
            view.addSubview(collectionView)
        }
        
        setupShareButton()
        setupCollectionView()
        setupPageControlView()
    }

    func setupShareButton() {
        
        view.addSubview(shareButton)
        
        // x, y, width, height constraints
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupCollectionView() {
        
        guard let collectionView = self.collectionView else { return }
        
        view.addSubview(collectionView)
        
        // x, y, width, height constraints
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navBarBottomPosition)).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -90).isActive = true
    }

    func setupPageControlView() {
        
        guard let runDetailsVM = runDetailsViewModel else { return }
        view.addSubview(runDetailsVM.pageControl)
        
        // x, y, width, height constraints
        runDetailsVM.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runDetailsVM.pageControl.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -30).isActive = true
        runDetailsVM.pageControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        runDetailsVM.pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func shareButtonPressed() {
    
        print("share my run: \(runDetailsViewModel?.run?.name)")
    
    }
}
