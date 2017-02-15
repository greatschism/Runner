//
//  AfterRunFeeling.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-11.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class AfterRunFeeling: NSObject {
    
    static let numberOfEmojis = 12
    static let emojiString = "emoji"
    var possibleFeelings: [UIImage]?
    
    static func getPossibleFeelings() -> [UIImage] {
        
        var possibleFeelings = [UIImage]()
        
        for index in 1...numberOfEmojis {
            
            if let image = UIImage(named: "\(emojiString)\(index)") {
                possibleFeelings.append(image)
            }
        }
        
        return possibleFeelings
    }
}
