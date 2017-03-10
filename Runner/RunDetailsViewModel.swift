//
//  RunDetailsViewModel.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-08.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class RunDetailsViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellIDs = ["detailsCell00", "detailsCell01","detailsCell02","detailsCell03"]
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var run: Run?
    
    var selectCommand: RACCommand?
    
    let numberOfPages = 4

    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = UIColor(r: 255, g: 55, b: 55)
        pc.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        pc.numberOfPages = self.numberOfPages
        return pc
    }()
    
    
    override init() {
        super.init()
        
        collectionView = getCollectionView()
    }
    
    func getCollectionView() -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RunDetailsCell00.self, forCellWithReuseIdentifier: self.cellIDs[0])
        collectionView.register(RunDetailsCell01.self, forCellWithReuseIdentifier: self.cellIDs[1])
        collectionView.register(RunDetailsCell02.self, forCellWithReuseIdentifier: self.cellIDs[2])
        collectionView.register(RunDetailsCell03.self, forCellWithReuseIdentifier: self.cellIDs[3])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }
    
    //MARK: CollectionView Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIDs[0], for: indexPath) as! RunDetailsCell00
            if let run = self.run {
                cell.configure(with: run)
            }
            return cell
        }
        else if indexPath.row == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIDs[1], for: indexPath) as! RunDetailsCell01
            if let run = self.run {
                cell.configure(with: run)
            }
            return cell
        }
        else if indexPath.row == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIDs[2], for: indexPath) as! RunDetailsCell02
            if let run = self.run {
                cell.configure(with: run)
            }
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIDs[3], for: indexPath) as! RunDetailsCell03
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
