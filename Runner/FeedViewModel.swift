//
//  FeedViewModel.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-17.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import ReactiveViewModel

class FeedViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellID = "cellID"
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var runItems = [Run]()
    var currentUser: User?
    
    let syncManager = SyncManager.sharedInstance
    
    var selectCommand: RACCommand?
    
    override init() {
        super.init()
        
        collectionView = getCollectionView()
        bind()
    }
    
    func getCollectionView() -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: self.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }
    
    func getChildVC(for indexPath: IndexPath) -> UIViewController? {

        let selectedRun = runItems[indexPath.item]

        let runDetailsViewModel = RunDetailsViewModel()
        runDetailsViewModel.run = selectedRun
        
        let runDetailsVC = RunDetailsViewController()
        runDetailsVC.runDetailsViewModel = runDetailsViewModel
                
        return runDetailsVC
    }
    
    func bind() {
        
        fetchCurrentUser()
        observeAddedRuns()
        observeRemovedRuns()
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                user.id = uid
                user.name = dictionary["name"] as? String
                
                self.currentUser = user
                
                print("[FEEDVIEWMODEL] current user is \(user.name)")
            }
        }, withCancel: nil)
    }
    
    func observeAddedRuns() {
        
        syncManager.getAddedRun { (run, error) in
            
            if error != nil {
                
                print("[FEEDVIEWMODEL] unable to fetch run, error = \(error)")
                return
            }
            
            DispatchQueue.main.async {

                self.runItems.insert(run, at: 0)

                self.collectionView?.performBatchUpdates({
                    
                    self.collectionView?.insertItems(at: [IndexPath(row: 0, section: 0)])
                }, completion: nil)
            }
        }
    }
    
    func observeRemovedRuns() {
        
        syncManager.getRemovedRun { (removedIndex, error) in
        
            if error != nil {
                
                print("[FEEDVIEWMODEL] unable to fetch run, error = \(error)")
                return
            }
            
            DispatchQueue.main.async {
                
                if let index = removedIndex {
                    
                    self.runItems.remove(at: index)
                    
                    self.collectionView?.performBatchUpdates({
                        
                        self.collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
                    }, completion: nil)
                }
            }
        }
    }
    
    //MARK: CollectionView Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return runItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! FeedCell
        let run = runItems[indexPath.item]
        cell.configure(with: run)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let childVC: UIViewController? = getChildVC(for: indexPath)
        selectCommand?.execute(childVC)
    }
    
    // To delete a run item
    
    // syncManager.removeRunFromDataBase(with: runToDelete)
}
