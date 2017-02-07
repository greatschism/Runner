//
//  ChartValueFormatter.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-07.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Charts

class MyChartValueFormatter: NSObject, IValueFormatter {

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            
            let minutes = String(format: "%02d", Int(value) / 60 % 60)
            let seconds = String(format: "%02d", Int(value) % 60)
            return "\(minutes):\(seconds)"
    }
}
