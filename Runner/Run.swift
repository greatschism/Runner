//
//  Run.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-08.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

enum RunType {
    case walk, run, longrun, race
}

struct Run {

    var type: RunType?
    var time: NSDate?
    var duration: Int
    var totalRunDistance: Int       // total distance actually ran, considering (minus) all distance in paused mode (this is the one displayed on screen)
    var totalDistanceInPause: Int
    var pace: Double                // pace value as a Double
    var pacesBySegment: [Int]       // each item is the pace value for a segment(split) of 1 km run
    var calories: Int
    var feeling: String?
}
