//
//  SurveySummary.swift
//  WellnessApp
//
//  Created by Max Walsh on 2/14/16.
//  Copyright © 2016 anna. All rights reserved.
//

import Foundation

class SurveySummary {
    
    var DailyTotal = 0
    var WeeklyTotal = 0
    var DailyComplete = 0
    var WeeklyComplete = 0
    
    init(a: Int, b: Int, c: Int, d:Int) {
        self.DailyTotal = a
        self.WeeklyTotal = b
        self.DailyComplete = c
        self.WeeklyComplete = d
    }
    
}