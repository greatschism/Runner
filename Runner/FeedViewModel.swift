//
//  FeedViewModel.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-17.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation
import Firebase

class FeedViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellID = "cellID"
    let layout = UICollectionViewFlowLayout()
    
    var collectionView: UICollectionView?

    var runItems = [Run]()
    
    var currentUser: User?
    
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
    
    func bind() {
        
        fetchCurrentUser()
        observeRuns()
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                user.id = uid
                user.name = dictionary["name"] as? String
                
                self.currentUser = user
                
                print("curren user is \(user)")
            }
        }, withCancel: nil)
    }
    
    func observeRuns() {
        
        FIRDatabase.database().reference().child("runs").observe(.childAdded, with: { (snapshot) in
            
            print("\(snapshot)")
            
            if let runsDictionary = snapshot.value as? [String: Any] {
                
                var foundRun = Run(type: RunType.run, time: nil, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [], calories: 0, feeling: nil, user: nil)
                
                if let runDuration = runsDictionary["duration"] as? Int,
                    let runDistance = runsDictionary["totalRunDistance"] as? Int,
                    let runPace = runsDictionary["pace"] as? Double, let userID = runsDictionary["userID"] as? String  {

                    let user = User()
                    user.id = userID
                    
                    foundRun.user = user
                    foundRun.duration = runDuration
                    foundRun.totalRunDistance = runDistance
                    foundRun.pace = runPace
                    
                    self.runItems.append(foundRun)
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
    
    //MARK: CollectionView Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return runItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! FeedCell
        
        cell.backgroundColor = UIColor.white
        
        let run = runItems[indexPath.item]
        
        if let uid = run.user?.id {
            
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(snapshot)
                
                if let userDictionary = snapshot.value as? [String: Any] {
                    
                    cell.usernameLabel.text = userDictionary["name"] as? String
                }
            }, withCancel: nil)
            
        }
        
        cell.profileImage = UIImage(named: "mario-run")
        cell.runDistanceLabel.text = RawValueFormatter().getDistanceString(with: run.totalRunDistance) + " km"
        cell.runDurationLabel.text = RawValueFormatter().getDurationString(with: run.duration)
        cell.runPaceLabel.text = RawValueFormatter().getPaceString(with: run.pace) + " /km"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}
