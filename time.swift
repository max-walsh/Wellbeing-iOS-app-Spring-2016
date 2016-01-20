//
//  time.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/12/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import Foundation
public extension NSDate {
	func xDays(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: x, toDate: self, options: [])!
	}
	func xWeeks(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: x, toDate: self, options: [])!
	}
	func xHours(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: x, toDate: self, options: [])!
	}
	func xMinutes(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: x, toDate: self, options: [])!
	}
	func xHoursMinutes(x:Int, y:Int) -> NSDate {
		let newDate: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: x, toDate: self, options: [])!
		
		return NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: y, toDate: newDate, options: [])!
		
	}
	
	var hoursFromToday: Int{
		return (NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour)%24
		
	}
	var weeksFromToday: Int{
		return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: self, toDate: NSDate(), options: []).weekOfYear
	}
	var relativeDateString: String {
		if weeksFromToday > 0 { return weeksFromToday > 1 ? "\(weeksFromToday) weeks and \(hoursFromToday) hours" : "\(weeksFromToday) week and \(hoursFromToday) hours"   }
		if hoursFromToday > 0 { return hoursFromToday > 1 ? "\(hoursFromToday) hours" : "\(hoursFromToday) hour"   }
		return ""
	}
	
}