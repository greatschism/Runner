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
            
//            print("[SYNC MANAGER] about to get in \(#function) the item added on Database: \(snapshot)")
            print("[SYNC MANAGER] about to get in \(#function) an item added on Database")
            
            if let runDictionary = snapshot.value as? [String: Any] {
                
                var foundRun = Run(id: nil, name: nil, timestamp: 0, duration: 0, totalRunDistance: 0, totalDistanceInPause: 0, pace: 0.0, pacesBySegment: [], elevations: [], calories: 0, locations: nil, imageURL: nil, imageName: nil, user: nil, paceZones: ["zoneUnder4" : 0, "zone45":0, "zone56":0, "zone67":0, "zone7plus":0])
                
                let runName = runDictionary["name"] as? String ?? ""
                let runDuration = runDictionary["duration"] as? Int ?? 0
                let runDistance = runDictionary["totalRunDistance"] as? Int ?? 0
                let runPace = runDictionary["pace"] as? Double ?? 0.0
                let userID = runDictionary["userID"] as? String ?? ""
                let startingTime = runDictionary["timestamp"] as? Int ?? 0
                let calories = runDictionary["calories"] as? Int ?? 0
                let elevations = runDictionary["elevations"] as? [Int] ?? []
                let paceZones = runDictionary["paceZones"] as? [String: Int] ?? ["":0]
                let pacesBySegment = runDictionary["pacesBySegment"] as? [Int] ?? []
                
                let user = User()
                user.id = userID
                
                foundRun.id = snapshot.key
                foundRun.user = user
                foundRun.name = runName
                foundRun.duration = runDuration
                foundRun.totalRunDistance = runDistance
                foundRun.pace = runPace
                foundRun.timestamp = startingTime
                foundRun.pacesBySegment = pacesBySegment
                foundRun.calories = calories
                foundRun.elevations = elevations
                foundRun.paceZones = paceZones
                
                FIRDatabase.database().reference().child("runs").child(snapshot.key).child("images").observe(.childAdded, with: { (snapshot) in
                
                    if let imageDictionary = snapshot.value as? [String: Any] {
                    
                        let imageURL = imageDictionary["imageURL"] as? String ?? ""
                        let imageName = imageDictionary["imageName"] as? String ?? ""
                        foundRun.imageURL = imageURL
                        foundRun.imageName = imageName
                        
                        guard let runID = foundRun.id else { return }
                        
                        self.indexKeys.insert(runID, at: 0)
                        
                        completion(foundRun, nil)
                    }
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }

    func getRemovedRun(completion: @escaping (_ index: Int?, _ error: NSError?) -> Void) {
        
        FIRDatabase.database().reference().child("runs").observe(.childRemoved, with: { (snapshot) in
            
            print("[SYNC MANAGER] about to get in \(#function) the item removed on Database: \(snapshot)")
            
            guard let removedIndex = self.removeIndex(of: snapshot.key) else { return }
            
            completion(removedIndex, nil)
            
            
        }, withCancel: nil)
    }
    
    private func removeIndex(of key: String) -> Int? {
        
        if let index = indexKeys.index(of: key) {
            
            indexKeys.remove(at: index)
            return index
        }
        
        return nil
    }
    
    func removeRunFromDataBase(with run: Run) {
        
        if let id = run.id {
            
            FIRDatabase.database().reference().child("runs").child(id).removeValue(completionBlock: { (error, reference) in
                
                if error != nil {
                    
                    print("[SYNC MANAGER] fail to delete run in \(#function), error: \(error)")
                }
                else {
                    
                    print("[SYNC MANAGER] succeded to remove run in \(#function) the item: \(run)")
                    
                    self.removeRunImagesFromStorage(with: run)
                }
            })
        }
    }
    
    func removeRunImagesFromStorage(with run: Run) {
        
        if let runID = run.id, let imageName = run.imageName {
            
            FIRStorage.storage().reference().child("run_images").child(runID).child(imageName).delete { error in
                
                if error != nil {

                    print("[SYNC MANAGER] fail to delete run image in \(#function), error: \(error)")
                }
                else {

                    print("[SYNC MANAGER] succeded to remove file in \(#function) the item: \(run)")
                }
            }
        }
    }
}
