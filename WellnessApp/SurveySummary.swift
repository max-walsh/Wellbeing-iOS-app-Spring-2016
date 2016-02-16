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
    var WeeklyTotal = Queue<Int>()
    var DailyComplete = 0
    var WeeklyComplete = Queue<Int>()
    
    init(a: Int, b: Int) {
        self.DailyTotal = a
        self.DailyComplete = b
    }
    
}