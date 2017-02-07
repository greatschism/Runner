//
//  YAxisValueFormatter.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-07.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class YAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let minutes = String(format: "%02d", Int(value) / 60 % 60)
        let seconds = String(format: "%02d", Int(value) % 60)
        return "\(minutes):\(seconds)"
    }
}
