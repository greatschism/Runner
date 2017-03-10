//
//  RawValueFormatter.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-18.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation

struct RawValueFormatter {
    
    func getDurationString(with duration: Int) -> String {
        
        let hours = String(format: "%02d", duration / 3600)
        let minutes = String(format: "%02d", duration / 60 % 60)
        let seconds = String(format: "%02d", duration % 60)
        
        return "\(hours):\(minutes):\(seconds)"
    }
    
    func getDistanceString(with distance: Int) -> String {
        
        let kmInt = distance / 1000 % 1000
        
        let dmTemp = Double(distance) / 1000
        let dmInt = Int((Double(dmTemp) * 100)) % 100
        
        let km: String
        
        if kmInt < 10 {
            km = String(format: "%01d", kmInt)
        }
        else {
            km = String(format: "%02d", kmInt)
        }
        
        let dm = String(format: "%02d", dmInt)
        
        return "\(km).\(dm)"
    }
    
    func getPaceString(with pace: Double) -> String {
        
        let roundPaceString = "\(pace)"
        let paceComponents = roundPaceString.components(separatedBy: ".")
        
        if paceComponents.count == 2 {
            
            let paceMinutesPart = paceComponents[0]
            var paceSecondsPart = paceComponents[1]
            
            if paceSecondsPart.characters.count == 1 {
                
                paceSecondsPart = paceSecondsPart.appending("0")
            }
            
            let paceSecondsPartInt = Int(paceSecondsPart) ?? 0
            
            let paceSecondsPartResult = paceSecondsPartInt * 60 / 100
            paceSecondsPart = String(format: "%02d", paceSecondsPartResult)
            
            return "\(paceMinutesPart):\(paceSecondsPart)"
        }
        else {
            // did not form the pace components array correctly
            return "00:00"
        }
    }
    
    func getPaceString(with paceInSeconds: Int) -> String {
        
        let minutes: String
        
        if (paceInSeconds / 60 % 60) >= 10 {
            minutes = String(format: "%02d", paceInSeconds / 60 % 60)
        }
        else {
            minutes = String(format: "%01d", paceInSeconds / 60 % 60)
        }
        
        let seconds = String(format: "%02d", paceInSeconds % 60)
        
        return "\(minutes):\(seconds) /km"
    }
    
    func getCaloriesString(with calories: Int) -> String {
        return String(format: "%03d", calories)
    }
}
