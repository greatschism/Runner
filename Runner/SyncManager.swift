//
//  SyncManager.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-23.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation
import Firebase

class SyncManager {
    
    static let sharedInstance = SyncManager()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    var indexKeys = [String]()
    
    func getAddedRun(completion: @escaping (_ run: Run, _ error: NSError?) -> Void) {
        
        FIRDatabase.database().reference().child("runs").observe(.childAdded, with: { (snapshot) in
            
            print("[SYNC MANAGER] about to get in \(#function) an item added on Database: \(snapshot)")
            
            if let runDictionary = snapshot.value as? [String: Any] {
                
                var foundRun = Run(type: RunType.run, time: nil, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [], calories: 0, feeling: nil, user: nil)
                
                if let runDuration = runDictionary["duration"] as? Int,
                    let runDistance = runDictionary["totalRunDistance"] as? Int,
                    let runPace = runDictionary["pace"] as? Double, let userID = runDictionary["userID"] as? String  {
                    
                    let user = User()
                    user.id = userID
                    
                    foundRun.user = user
                    foundRun.duration = runDuration
                    foundRun.totalRunDistance = runDistance
                    foundRun.pace = runPace
                    
                    self.indexKeys.insert(snapshot.key, at: 0)
                    
                    completion(foundRun, nil)
                }
            }
        }, withCancel: nil)
    }
    
    func getRemovedRun(completion: @escaping (_ index: Int?, _ error: NSError?) -> Void) {
        
        FIRDatabase.database().reference().child("runs").observe(.childRemoved, with: { (snapshot) in
            
            print("[SYNC MANAGER] about to get in \(#function) an item removed on Database: \(snapshot)")
            
            guard let removedIndex = self.removeIndex(of: snapshot.key) else { return }
            
            completion(removedIndex, nil)
            
            
        }, withCancel: nil)
    }
    
    func removeIndex(of key: String) -> Int? {
        
        if let index = indexKeys.index(of: key) {
            
            indexKeys.remove(at: index)
            return index
        }
        
        return nil
    }
}
