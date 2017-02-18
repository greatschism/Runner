//
//  AfterRunFeeling.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-11.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class AfterRunFeeling: NSObject {
    
    let numberOfEmojis = 12
    private let emojiString = "emoji"
    
    func getEmojiImage(with index: String) -> UIImage? {
        
        return UIImage(named: "\(self.emojiString)\(index)") ?? nil
    }
}
