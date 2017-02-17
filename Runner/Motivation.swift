//
//  MotivationTitle.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-14.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation

struct Motivation {
    
    private let titles = ["GOOD JOB!", "GOOD WORK!", "NICE JOB!", "WAY TO GO!", "GREAT JOB!", "AWESOME JOB!", "NICELY DONE!"]
    private let phrases = ["You are riding the wave of success!", "You make things happen!", "See you next time!", "Have a nice day!", "You are doing great!", "Never, never, never give up!", "You are a CHAMPION!", "Have a good rest!"]
    
    var title = String()
    var phrase = String()
    
    init() {
        
        self.title = randomTitle()
        self.phrase = randomPhrase()
    }
    
    private func randomTitle() -> String {
    
        let randomNum = arc4random_uniform(UInt32(titles.count)) // range is 0 to index of last item in array
        let randomInt = Int(randomNum)
        
        return randomInt < titles.count ? titles[randomInt] : "GREAT JOB!"
    }
    
    private func randomPhrase() -> String {
        
        let randomNum = arc4random_uniform(UInt32(phrases.count)) // range is 0 to index of last item in array
        let randomInt = Int(randomNum)
        
        return randomInt < phrases.count ? phrases[randomInt] : "You make things happen!"
    }
}
