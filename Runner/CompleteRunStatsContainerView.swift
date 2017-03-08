//
//  StatsContainerView.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-12.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

class CompleteRunStatsContainerView: UIView {

    // Fonts
    let titleFont = UIFont(name: "AvenirNext-Regular", size: 14)
    let titleTextColor = UIColor(r: 32, g: 32, b: 32)
    
    let valueFont = UIFont(name: "DINAlternate-bold", size: 24)
    let valueTextColor = UIColor(r: 64, g: 64, b: 64)
    
    let unitFont = UIFont(name: "AvenirNext-Regular", size: 14)
    let unitTextColor = UIColor(r: 32, g: 32, b: 32)
    
    // Distance Views
    lazy var distanceContainer: [UILabel] = {
        var labels = self.createLabelsWith(name: "distance", value: "0.00", unit: "km")
        return labels
    }()
    
    // Duration views
    lazy var durationContainer: [UILabel] = {
        var labels = self.createLabelsWith(name: "duration", value: "00:00:00", unit: "hh:mm:ss")
        return labels
    }()
    
    // Pace views
    lazy var paceContainer: [UILabel] = {
        var labels = self.createLabelsWith(name: "pace", value: "00:00", unit: "min/km")
        return labels
    }()
    
    // Calories views
    lazy var caloriesContainer: [UILabel] = {
        var labels = self.createLabelsWith(name: "burn", value: "000", unit: "kCal")
        return labels
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupDistanceViews()
        setupDurationViews()
        setupPaceViews()
        setupCaloriesViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createLabelsWith(name: String, value:String, unit:String) -> [UILabel] {
        
        let titleLabel = UILabel()
        titleLabel.text = name.uppercased()
        titleLabel.textColor = self.titleTextColor
        titleLabel.textAlignment = .center
        titleLabel.font = self.titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value.uppercased()
        valueLabel.textColor = self.valueTextColor
        valueLabel.textAlignment = .center
        valueLabel.font = self.valueFont
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.textColor = self.unitTextColor
        unitLabel.textAlignment = .center
        unitLabel.font = self.unitFont
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return [titleLabel, valueLabel, unitLabel]
    }
    
    func setupDistanceViews() {
        
        let distanceTitle = distanceContainer[0]
        self.addSubview(distanceTitle)

        // x, y, width, height constraints
        distanceTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        distanceTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        distanceTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        distanceTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let distanceValue = distanceContainer[1]
        self.addSubview(distanceValue)
        
        // x, y, width, height constraints
        distanceValue.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        distanceValue.topAnchor.constraint(equalTo: distanceTitle.bottomAnchor).isActive = true
        distanceValue.widthAnchor.constraint(equalTo: distanceTitle.widthAnchor).isActive = true
        distanceValue.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let distanceUnit = distanceContainer[2]
        self.addSubview(distanceUnit)
        
        // x, y, width, height constraints
        distanceUnit.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        distanceUnit.topAnchor.constraint(equalTo: distanceValue.bottomAnchor).isActive = true
        distanceUnit.widthAnchor.constraint(equalTo: distanceValue.widthAnchor).isActive = true
        distanceUnit.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupDurationViews() {
    
        let durationTitle = durationContainer[0]
        self.addSubview(durationTitle)
        
        // x, y, width, height constraints
        durationTitle.leftAnchor.constraint(equalTo: distanceContainer[0].rightAnchor).isActive = true
        durationTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        durationTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.30).isActive = true
        durationTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let durationValue = durationContainer[1]
        self.addSubview(durationValue)
        
        // x, y, width, height constraints
        durationValue.leftAnchor.constraint(equalTo: distanceContainer[0].rightAnchor).isActive = true
        durationValue.topAnchor.constraint(equalTo: durationTitle.bottomAnchor).isActive = true
        durationValue.widthAnchor.constraint(equalTo: durationTitle.widthAnchor).isActive = true
        durationValue.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let durationUnit = durationContainer[2]
        self.addSubview(durationUnit)
        
        // x, y, width, height constraints
        durationUnit.leftAnchor.constraint(equalTo: distanceContainer[0].rightAnchor).isActive = true
        durationUnit.topAnchor.constraint(equalTo: durationValue.bottomAnchor).isActive = true
        durationUnit.widthAnchor.constraint(equalTo: durationTitle.widthAnchor).isActive = true
        durationUnit.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupPaceViews() {
        
        let paceTitle = paceContainer[0]
        self.addSubview(paceTitle)
        
        // x, y, width, height constraints
        paceTitle.leftAnchor.constraint(equalTo: durationContainer[0].rightAnchor).isActive = true
        paceTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        paceTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.20).isActive = true
        paceTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let paceValue = paceContainer[1]
        self.addSubview(paceValue)
        
        // x, y, width, height constraints
        paceValue.leftAnchor.constraint(equalTo: durationContainer[0].rightAnchor).isActive = true
        paceValue.topAnchor.constraint(equalTo: paceTitle.bottomAnchor).isActive = true
        paceValue.widthAnchor.constraint(equalTo: paceTitle.widthAnchor).isActive = true
        paceValue.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let paceUnit = paceContainer[2]
        self.addSubview(paceUnit)
        
        // x, y, width, height constraints
        paceUnit.leftAnchor.constraint(equalTo: durationContainer[0].rightAnchor).isActive = true
        paceUnit.topAnchor.constraint(equalTo: paceValue.bottomAnchor).isActive = true
        paceUnit.widthAnchor.constraint(equalTo: paceTitle.widthAnchor).isActive = true
        paceUnit.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupCaloriesViews() {
        
        let caloriesTitle = caloriesContainer[0]
        self.addSubview(caloriesTitle)
        
        // x, y, width, height constraints
        caloriesTitle.leftAnchor.constraint(equalTo: paceContainer[0].rightAnchor).isActive = true
        caloriesTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        caloriesTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        caloriesTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let caloriesValue = caloriesContainer[1]
        self.addSubview(caloriesValue)
        
        // x, y, width, height constraints
        caloriesValue.leftAnchor.constraint(equalTo: paceContainer[0].rightAnchor).isActive = true
        caloriesValue.topAnchor.constraint(equalTo: caloriesTitle.bottomAnchor).isActive = true
        caloriesValue.widthAnchor.constraint(equalTo: caloriesTitle.widthAnchor).isActive = true
        caloriesValue.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        let caloriesUnit = caloriesContainer[2]
        self.addSubview(caloriesUnit)

        // x, y, width, height constraints
        caloriesUnit.leftAnchor.constraint(equalTo: paceContainer[0].rightAnchor).isActive = true
        caloriesUnit.topAnchor.constraint(equalTo: caloriesValue.bottomAnchor).isActive = true
        caloriesUnit.widthAnchor.constraint(equalTo: caloriesValue.widthAnchor).isActive = true
        caloriesUnit.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
}
